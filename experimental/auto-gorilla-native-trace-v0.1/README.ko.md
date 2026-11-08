# AutoGorilla Native Trace v0.1 — 기본 수동 패링 경로 대조

이 패키지는 자동 패링 구현판이 아니라 기본 게임 경로를 기록하는 진단판입니다.
기존 자동 패링 코드의 피격 후 판정/이벤트 억제/강제 전이를 전부 제외한 독립 패키지입니다.
다른 AutoGorilla 버전과 동시에 활성화하면 대조 결과가 무효가 됩니다.

## 설치
게임을 종료하고 이전 AutoGorilla 버전을 모두 비활성화합니다.
AutoGorilla-NativeTrace-v0.1.zip을 MO2에 별도 모드로 설치하고 이것만 활성화합니다.
CET와 redscript는 유지합니다. Native Settings UI는 선택 사항이며 설치돼 있으면 메뉴를 제공합니다.
MO2를 통해 실행하고 저장을 불러옵니다. 자동 패링은 하지 않습니다.
게임용 컴파일 실패 시 r6/logs/redscript_rCURRENT.log를 확인하세요.

## 테스트 (수동)
1. 고릴라 암을 꺼내 같은 링 상대와 가까이 마주 봅니다.
2. 가능하면 Mods → AutoGorilla Native Trace → 테스트 구간 표시를 누릅니다. 추적은 기본 켜짐입니다.
3. 방어 버튼을 길게 눌러 일반 방어를 1회 합니다.
4. 적 공격이 닿기 직전에 방어 버튼을 눌러 수동 패링을 3회 시도합니다.
5. 패링 성공 후 공격 버튼을 누르지 않아도 반격 동작과 피해가 나오는지 확인합니다.
6. 그 다음 패링 후 직접 공격 버튼을 누르는 경우도 1회 시도합니다.
7. 일반 약공격도 1회 해서 실제 공격 생성/피해 계측의 대조 기준을 남깁니다.
8. 메뉴에서 추적을 끄거나 게임을 종료하고 AutoGorilla.log를 보내주세요.
방어/반격 동작과 적 체력 감소가 실제로 보였는지도 함께 알려주세요.
수동 패링 타이밍을 못 맞췄다면 성공하지 않았다고 알려주면 됩니다. 성공했다고 가정하지 않습니다.

## 왜 이 대조가 필요한가
앞선 자동화는 피격 시 IsDeflecting을 임시로 만들어 피해를 패링으로 처리하고, 뒤늦게 무기 상태를 연결했습니다.
이는 기본 게임의 방어 입력 → 상태 진입 → 그 상태에서 피격 → 성공 이벤트 → 반격 순서와 다릅니다.
v0.3.1에서 반격 후보 검사0, deflect_wait 후 일반 방어/대기로 복귀가 관측돼 정적 함수 목록만으로 전이 원인을 확정할 수 없습니다.
상체 입력 상태와 무기 상태, 실제 호출되는 전이/반격 레코드가 사용자 게임에서 어떻게 연결되는지 확인해야 합니다.

## 조사한 기본 2.5 스크립트 경로
- MeleeTransition.IsBlockPressed: MeleeBlock의 just-pressed 입력 확인.
- MeleeTransition.IsBlockHeld: UpperBody가6인지 확인. 단순히 무기 상태가 Deflect인지 확인하는 함수가 아닙니다.
- MeleeDeflectEvents.OnEnter: Deflect 애니메이션 요청, IsDeflecting 스탯 추가, 근접 무기 상태10 설정.
- DamageManager.ProcessDefensiveState: 기본 공격 종류/방향/IsDeflecting 조건에 따라 WasDeflected와 적 패링 반응 처리.
- DamageManager.SendNameEventToPSM: successfulDeflect 값을 플레이어와 활성 무기 양쪽에 QueueEvent로 전달.
- MeleeDeflectDecisions: temporary successfulDeflect의 valid 여부를 사용.
- MeleeDeflectAttackDecisions: 기본 반격 공격 레코드 유무 확인.
- MeleeDeflectAttackEvents: 상태20과 기본 근접 공격 이벤트 연결.
- MeleeAttackGenericEvents: 현재 상태의 공격 레코드/애니메이션 데이터 설정 및 Attack 애니메이션 요청.
- 이후 공격 시점에 CreateMeleeAttack → SpawnAttackGameEffect → 기본 StartAttack, 스태미나 소비.
- DamageSystem: 실제 타격의 피해 계산과 DealDamages.
MeleeBlockAttack은 별도 경로이며 기본 코드에서 방어 상태와 공격 버튼을 요구합니다. 이것도 함께 추적합니다.

## 기록 범위
플레이어에 전달된 MeleeBlock/약공격/강공격 입력 이벤트, 관련 전이 함수의 결과 변화, 기본 이벤트 진입/종료,
UpperBody/근접 무기 상태, IsDeflecting/IsBlocking, 스태미나, temporary 성공값,
공격 레코드 로드 성공/딜레이/지속시간/스태미나 비용, StartAttack 반환값,
DealDamages 전후 대상 체력을 기록합니다.
PlayerPuppet에 해당 입력 이벤트가 전달되지 않는 경우에는 OnAction 줄이 없을 수 있습니다.
그 경우에도 상태 함수 안에서 실제 입력값/just-pressed를 별도로 기록합니다.
전이 함수 로그는 같은 결과/입력/상태의 반복을 생략합니다. 로그가 없다는 사실만으로 함수가 존재하지 않는다고 판단하지 않습니다.
버퍼는 512줄이며 0.1초마다 비웁니다. 넘치면 buffer_dropped 경고가 나옵니다.

## 전투 동작 보존
26개 wrapper는 원래 함수를 정확히 한 번 호출하고 원래 반환값을 유지합니다.
이 패키지는 게임 스탯/피해/입력/애니메이션/상태 전이 조건을 변경하지 않습니다.
추적 전용 필드/버퍼만 변경합니다. 다른 전투 모드의 변경까지 제거하는 것은 아닙니다.
추적을 켜면 함수 호출/로그 기록에 따른 부하는 있을 수 있습니다.
이 기록으로 성공적인 수동 패링 경로를 확인한 뒤, 자연 경로의 입력/준비 단계만 자동화할 수 있는 지점을 검토합니다.
아직 확인하지 않은 입력 주입 API나 자동 패링 성공을 주장하지 않습니다.

## 로그
bin/x64/plugins/cyber_engine_tweaks/mods/AutoGorilla/AutoGorilla.log
bin/x64/plugins/cyber_engine_tweaks/scripting.log
MO2 Overwrite에도 있을 수 있습니다. [AutoGorilla NativeTrace]가 이번 기록입니다.
기존 로그가 이어질 수 있으므로 최신 NativeTrace loaded 줄 이후를 확인하세요.

## 검증
26개 wrapper 시그니처를 공개 2.5 소스와 대조했습니다.
각 wrapper가 원래 함수를 한 번 호출하고 gameplay 변경 API를 사용하지 않는지 검사했습니다.
Lua 5.4 모의 환경에서 로그 순서/버퍼 배출/UI 스위치/구간 표시/누락 경고/종료 배출/선택 UI 누락 처리를 확인했습니다.
게임용 redscript 컴파일, 실제 CET 실행, 게임 내 수동 패링 계측은 아직 미검증입니다.
사용자 로그/개인 경로/게임 파일/기반 모드 파일은 배포하지 않습니다.

소스 근거:
https://codeberg.org/adamsmasher/cyberpunk/commit/17c62d000310f8938beb9593b3892c6c4febeffb
cyberpunk/player/psm/meleeTransitions.swift, upperBodyTransitions.swift, cyberpunk/damage/damageManager.swift, damageSystem.swift
Native Settings API: https://github.com/justarandomguyintheinternet/CP77_nativeSettings

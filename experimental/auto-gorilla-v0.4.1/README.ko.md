# AutoGorilla v0.4.1 — 공격 타이밍 측정용

v0.4.0 자동 동작은 그대로 두고, 공격한 NPC 식별값/공격 레코드/공격 상태 변화/실제 피격 시점을 연결하는 계측만 추가했습니다.
움찔거림이 해결된 버전이 아닙니다. 이 기록으로 중복 시도와 너무 이른 방어를 구분합니다.

## 사용자가 할 일
1. 게임 종료 후 기존 AutoGorilla와 별도 NativeTrace를 모두 끄고 이 ZIP만 활성화합니다.
2. Mods → AutoGorilla에서 자동 패링/자동 반격/진단 로그를 켭니다. 추가비용0, 시도간격0.3초로 둡니다.
3. 같은 상대와 가까이 마주 보고 약20초 동안 공격받습니다. 공격/방어 버튼은 누르지 않아도 됩니다. 필요하면 수동 방어로 전투를 마무리하세요.
4. AutoGorilla.log 하나를 보내주세요. 순서 구분이나 영상 촬영은 필요하지 않습니다.
컴파일 오류가 나면 대신 r6/logs/redscript_rCURRENT.log를 보내주세요.

## 추가 계측
TIMING phase: 5m 안 NPC 상체 상태 변화, NPC ID, 관측 공격 상태 주기 번호.
TIMING deflect_enter: 방어 진입 당시 감지한 후보 NPC와 그 공격 상태 진입 후 경과 시간.
TIMING contact BEFORE/AFTER: 실제 공격한 NPC ID, 실제 AttackRecord ID, 공격 종류, 접촉 번호, 패링/방어 결과.
공격 상태가 여러 연속타를 포괄할 수 있으므로 cycle은 고유 공격번호라고 단정하지 않습니다.
firstObservation/beginFirstObserved=1은 공격 시작을 처음부터 본 것이 아니라 중간 관측일 수 있다는 표시입니다.
phaseAge는 그 NPC의 관측 시작으로부터의 시간입니다. 실제 애니메이션 시작/예정 타격 시각이라고 주장하지 않습니다.
서로 다른 상대가 섞여도 npc ID와 record로 분리해서 분석합니다.
공격 레코드 이름은 같은 종류의 여러 공격에서 재사용될 수 있습니다.

## 설치/설정/로그
CET, redscript, Native Settings UI는 유지합니다. MO2를 통해 실행합니다.
기존 개인 settings.json은 ZIP에 포함하지 않습니다. 기존 모드 폴더/Overwrite에 있는 설정을 보존하거나 UI에서 다시 설정하세요.
전용 로그: bin/x64/plugins/cyber_engine_tweaks/mods/AutoGorilla/AutoGorilla.log
공통 로그: bin/x64/plugins/cyber_engine_tweaks/scripting.log
MO2 Overwrite에도 있을 수 있습니다. 최신 v0.4.1 이후 기록을 확인하세요.

## 검증
41개 wrapper 선언을 공개 게임2.5 소스와 대조했습니다.
설정/UI/저장/로드/로그 배출 Lua 모의 테스트와 ZIP 무결성 검사를 통과했습니다.
자동 동작은 v0.4.0과 같으며, 타이밍 계측 코드의 게임용 컴파일/실제 기록은 아직 미검증입니다.
가짜 패링 플래그/성공 이벤트/피격 보류/별도 가짜 반격은 사용하지 않습니다.
사용자 개인 로그는 이 공개 배포물에 포함하지 않았습니다.

기본 경로/구현 범위 안내:
# AutoGorilla v0.4.1 — 기본 패링 선행 준비 시험판

기존 피격 후 강제 패링/반격 방식은 제거했습니다. 이번에는 피격 전에 기본 Deflect 진입만 준비합니다.
게임 내 컴파일 및 실제 자동 동작은 아직 미검증입니다. 모든 공격 자동 패링 완성판이 아닙니다.

## 수동 경로 대조에서 확인한 점
수동 패링 기록에서 성공한 패링 7회 모두 기본 MeleeDeflectAttack과 실제 StartAttack 성공으로 이어졌습니다.
반격 후보 EnterCondition 로그가 없어도 정상 경로가 성립했고, UpperBody=0에서도 반격한 사례가 있었습니다.
따라서 이전 버전의 counter_checks=0 또는 UpperBody=0만으로 실패 원인을 단정하지 않습니다.
수동 공격은 공격 레코드 로드 → 기본 Attack 애니메이션 요청 → SpawnAttackGameEffect → DealDamages까지 관측됐습니다.
기존 DealDamages 직후 체력 조회는 같은 값일 수 있으므로 실제 피해 확정의 유일한 근거로 사용하지 않습니다.
이번 버전은 게임이 발행한 OnDamageDealt의 resourcesLost 기반 damage 이벤트도 기록합니다.
사용자 로그 원문은 이 공개 배포물에 포함하지 않았습니다.

## 새 구조
1. 고릴라 암을 꺼낸 근접 대기 상태에서 정면 가까운 NPC의 공격 상태를 감지합니다.
2. 기본 Deflect의 진입 조건만 자동으로 허용합니다. 기본 무기/쿨다운/중단 조건은 유지합니다.
3. 기본 MeleeDeflectEvents가 방어 애니메이션과 IsDeflecting을 설정합니다.
4. 이후 실제 피격에서 기본 DamageManager가 패링 성공을 결정합니다.
5. successfulDeflect는 원래처럼 플레이어/무기로 전달합니다. 차단하거나 가짜 temporary 성공값을 만들지 않습니다.
6. 기본 반격 조건, 공격 레코드, 애니메이션, 공격 생성, 스태미나 비용, 피해 처리가 이어집니다.

반격 스위치가 켜졌을 때 하위 전이 조건은 원래 반환값을 유지합니다.
반격 스위치 끄기만 해당 자동 방어의 반격 전이를 차단하며 수동 패링 경로는 그대로 둡니다.
추가 비용은 실제 기본 패링 성공을 관측한 뒤 차감합니다.
피해 배율은 이 모드 요청으로 진입한 기본 반격 무기의 실제 근접 피해 계산에만 곱합니다.
IsDeflecting 임시 추가, WasDeflected 강제 추가, 성공 이벤트 억제/가짜 전달,
피격 이벤트 보류/재생, 방어/반격 애니메이션 직접 호출, 강제 반격 타이밍은 사용하지 않습니다.
적 체력을 직접 깎는 별도 가짜 공격도 없습니다.

## 현재 감지 범위와 불확실성
카메라 조준점 가까운 NPC 한 명이 대상이며, 정면 60도 이내/거리3m/상대가 나를 향하는 기본 방어 각도 조건을 사용합니다.
그 NPC의 실제 UpperBody 상태가 Attack 또는 ChargedAttack인 경우만 준비합니다.
NPC가 든 무기가 확인되면 근접 무기인지도 확인합니다. 무기가 없는 맨손 NPC는 배제하지 않습니다.
보스/맥스택 등급 및 적대 관계를 이유로 제외하지 않습니다.
기본 피격 판정은 변경하지 않으므로 방어 각도/공격 종류 등 최종 성공 여부는 기본 게임이 결정합니다.
공격 중/차지 중/회피 중/메뉴/중단 상태는 자동 준비 대상이 아닙니다.
NPC 공격 상태가 실제 타격보다 얼마나 먼저 켜지는지는 공격마다 다를 수 있습니다.
너무 일찍 방어 상태가 열리면 기본 패링 시간창이 먼저 끝날 수 있습니다. 실패 시 적만 강제로 밀어내지 않습니다.
여러 상대/화면 밖 상대/아주 빠른 공격/느린 차지 공격은 이 감지 방식으로 놓칠 수 있습니다.
이 버전의 목적은 확인된 기본 경로를 실제 자동 준비에서도 재현할 수 있는지 검증하는 것입니다.
기본 조준 보정은 유지합니다. 총알 반사/카타나/다른 근접 무기는 아직 구현하지 않았습니다.

## 설치
게임을 종료합니다. 기존 AutoGorilla 모든 버전과 별도 NativeTrace 패키지를 비활성화합니다.
AutoGorilla-v0.4.1-native-first.zip을 MO2에 새 모드로 설치하고 이 버전만 활성화하세요.
추적 코드는 이 ZIP에 포함돼 있으므로 별도 추적판을 함께 켜지 마세요.
CET, redscript, Native Settings UI는 유지하고 MO2로 게임을 실행합니다.
Native Settings UI: https://www.nexusmods.com/cyberpunk2077/mods/3518
설정은 Mods → AutoGorilla에서 변경하며 자동 저장합니다. 개인 settings.json은 ZIP에 포함하지 않습니다.
기존 설정 파일은 보존하거나 UI에서 다시 설정하세요. MO2 Overwrite도 확인하세요.

## 첫 테스트
자동 패링/자동 반격/진단 로그를 켭니다.
추가 스태미나 비용0, 최소 자동 방어 시도 간격0.3초, 피해 배율1.0으로 설정합니다.
상대와 가까이 마주 보고 공격/방어 버튼을 누르지 않은 채 근접 공격 5회 정도 받습니다.
방어 동작 / 반격 동작 / 적 체력 감소 / 적만 밀려나는 경우를 구분해 알려주세요.
이전 수동 테스트처럼 순서를 맞출 필요는 없습니다. 수동 동작이 섞여도 로그로 구분합니다.
테스트용 저장을 사용하고 필요하면 수동 방어로 전투를 종료하세요.

## 설정
자동 패링 / 패링 후 자동 반격 / 추가 스태미나 비용 / 최소 자동 방어 시도 간격 / 반격 피해 배율 / 진단 로그.
기존 기본값(추가비용10/간격1.2/배율1)은 유지합니다. 첫 테스트에서는 위 권장값으로 바꾸세요.
간격은 성공 횟수가 아닌 자동 방어 시도 간격이며, 실패한 방어 시도에도 적용됩니다.
추가비용0도 기본 반격 자체 스태미나 비용은 없애지 않습니다.
이미 시작한 동작은 기본 게임의 종료 경로를 따릅니다. 강제 종료/로드 정리도 추가했습니다.

## 로그
AutoGorilla.log 및 scripting.log에 기본 추적과 AUTO 표시를 함께 기록합니다.
AUTO native Deflect entered BEFORE contact: 공격 상태 감지로 기본 Deflect에 진입.
AUTO native parry confirmed: 그 창 안에서 기본 게임이 패링을 확인.
AUTO original counter entered: 기본 반격 진입.
AUTO native window ended without parry: 방어 시도는 했지만 창 안에 기본 패링 성공이 없었음.
SpawnAttackGameEffect AFTER started=1: 실제 기본 공격 시작 성공.
native damage event actualResourcesLost: 기본 피해 시스템이 발행한 실제 소모 자원 합계 이벤트.
auto_deflect/native_parry/native_counter: 이 모드 소유 시도/패링/반격 횟수.
sensor: 감지 대상 상태. no_front_target/front_target_phase=숫자/front_melee_attack 등.
기본 게임의 판정·피해 이벤트가 있어도 시각적 동작과 적 체력 변화는 함께 확인해야 합니다.

전용 로그: bin/x64/plugins/cyber_engine_tweaks/mods/AutoGorilla/AutoGorilla.log
공통 로그: bin/x64/plugins/cyber_engine_tweaks/scripting.log
컴파일: r6/logs/redscript_rCURRENT.log
최신 v0.4.1 loaded 이후 기록을 보내주세요. MO2 Overwrite에도 있을 수 있습니다.

## 검증 범위
38개 wrapper 시그니처가 공개 2.5 게임 스크립트에 존재하는지 확인했습니다.
자동화 코드에서 패링 플래그/성공 이벤트 조작과 강제 반격 타이밍이 제거됐는지 검사했습니다.
Lua 5.4 모의 환경에서 UI 6항목, JSON 저장/복원, 새 설정 연결,
자동 반격 끄기 시 방어 요청 유지, 진행 중 반격 유지, 새 플레이어/로드 적용, 추적 로그 배출, 선택 UI 누락 처리를 확인했습니다.
NPC 감지/타이밍/상태 머신의 실제 동작 및 이번 코드의 게임용 컴파일은 미검증입니다.

근거: https://codeberg.org/adamsmasher/cyberpunk/commit/17c62d000310f8938beb9593b3892c6c4febeffb
cyberpunk/player/psm/meleeTransitions.swift, defaultTransition.swift, cyberpunk/damage/damageManager.swift, damageSystem.swift,
cyberpunk/ai/Conditions/aiAutonomousConditions.swift, cyberpunk/puppet/scriptedPuppet.swift
API: https://github.com/justarandomguyintheinternet/CP77_nativeSettings
게임/기반 모드/참고 모드 코드 및 개인 로그 파일은 재배포하지 않습니다.

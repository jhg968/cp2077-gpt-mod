# AutoGorilla v0.3.0 — 기본 방어 동작을 거쳐 반격 연결

실험 버전입니다. 게임 내 컴파일 및 동작 검증이 필요합니다.

## 변경
이전 버전은 피격 계산에서 기본 패링 성공 이벤트를 먼저 보내고 뒤늦게 Deflect 동작을 요청했습니다.
v0.3.0은 이 모드가 임시 IsDeflecting을 적용하는 동기 호출 동안에만 successfulDeflect 전달을 보류합니다.
수동 패링 등 이 범위 밖의 이벤트는 그대로 전달합니다.
자동 Deflect 상태 진입 후 최소 0.12초가 지나면 기본 MeleeDeflectAttack 전이 조건에 성공을 제공합니다.
순간적인 temporary 성공 값을 넣던 코드는 제거했습니다. 상태 전이 자체는 기본 게임 그래프를 사용합니다.
Deflect 요청은 0.5초, 소유권 확인은 피격 후 0.8초까지만 유효합니다.
자동 반격을 꺼도 자동 패링의 방어 동작 요청은 유지합니다.
반격 상태 진입 후 해당 상태의 scriptInterface.owner 무기를 추적해 공격 생성/피해 계산을 계측합니다.
CET 폴링에서 근접 상태 숫자만으로 반격 소유 플래그를 끄던 처리를 제거했습니다.
정상/강제 종료, 메뉴/무기 교체/설정 변경/로드 시 정리는 유지합니다.
보스/맥스택/적대 관계 제외는 다시 추가하지 않았습니다.
기본 Deflect 쿨다운 중에는 임시 자동 패링을 만들지 않습니다.
방어 무시 공격, 빠른 근접 공격, 기본 방어 각도, 고릴라 암 대기 상태, 스태미나/무기 패링 조건은 유지합니다.

초기 피격에서 패링을 판정하고 그 후 기본 동작을 요청하는 방식 자체는 여전히 실험적입니다.
모든 공격에 방어/반격 애니메이션과 타격이 보장된다고 주장하지 않습니다.
무한 스태미나, 적 체력 직접 감소, 별도 가짜 반격 공격은 추가하지 않았습니다.

## 설치
게임을 종료하고 이전 AutoGorilla 버전을 끕니다.
AutoGorilla-v0.3.0-experimental.zip을 MO2에 설치하고 이 버전만 활성화하세요.
CET, redscript, Native Settings UI를 유지합니다.
Native Settings UI: https://www.nexusmods.com/cyberpunk2077/mods/3518
MO2로 게임을 실행하고 Mods → AutoGorilla에서 설정합니다.
기존 settings.json은 ZIP에 포함하지 않습니다. 기존 모드 폴더 또는 MO2 Overwrite에 있는 설정을 보존하거나 UI에서 다시 설정하세요.

## 첫 테스트
자동 패링/자동 반격/진단 로그를 켜고 추가 스태미나 비용은 0으로 설정하세요.
패링 가능한 정면 근접 공격을 5회 정도 받습니다. 공격/방어 버튼은 누르지 않습니다.
1. 기본 방어 동작이 보이는가?
2. 뒤이어 팔로 실제 반격하는가?
3. 적의 체력이 감소하는가?
4. 적만 밀려나고 내 동작은 없는 경우가 남는가?
결과와 AutoGorilla.log를 보내주세요. 컴파일 실패 시 redscript_rCURRENT.log가 필요합니다.
세이브/퀘스트 승패 처리는 별도로 확인해야 합니다. 다른 자동 방어 모드는 테스트 프로필에서 끄세요.

## 진단 필드
parry: 이 모드가 기본 패링 판정을 확인한 횟수.
deflect_enter: 자동 Deflect 방어 동작 상태 진입 횟수.
counter_enter: 이 모드 요청으로 기본 반격 상태를 소유한 횟수.
effect_attempt: 해당 반격 무기의 기본 공격 생성 함수 호출 횟수.
effect_started: 위 함수에서 기본 StartAttack이 성공을 반환한 횟수.
outgoing: 반격 소유 플래그 중 플레이어 근접 타격이 피해 계산에 도달한 횟수.
hit_pipeline: 그중 반격 상태가 소유한 무기까지 일치한 횟수. 이때 설정 피해 배율을 적용합니다.
어떤 카운터도 최종 적 피해 성공을 단독으로 증명하지 않습니다. 적 체력 감소도 확인해야 합니다.
나머지 seen/reason/state/StrongArms/CanDeflect/stamina/parry_stamina/pending도 유지합니다.

로그:
bin/x64/plugins/cyber_engine_tweaks/mods/AutoGorilla/AutoGorilla.log
bin/x64/plugins/cyber_engine_tweaks/scripting.log
r6/logs/redscript_rCURRENT.log
MO2 Overwrite에도 로그/설정이 생성될 수 있습니다.

## 설정
자동 패링 / 자동 반격 / 추가 스태미나 비용(기본10) / 최소 간격(기본1.2초) / 반격 피해 배율(기본1) / 진단 로그.
설정은 자동 저장되고 다음 처리부터 반영됩니다. 이미 시작한 반격은 정상 종료합니다.
추가 비용0은 모드의 추가 패링 비용만 없애며 기본 반격 비용은 유지합니다.
카타나/다른 근접 무기/총알 반사는 아직 구현하지 않았습니다.
기본 근접 조준 보정은 유지됩니다.

## 확인 범위
추가/변경한 wrapper 시그니처를 포함해 사용하는 모든 wrapper 선언이 공개 2.5 게임 스크립트에 있는지 대조했습니다.
CET json.lua 기반 설정 저장/복원, UI 변경 콜백, 메뉴 정리, Deflect 중 요청 유지, 자동 반격 끄기 시 방어 요청 유지에 대해 Lua 5.4 모의 테스트를 수행했습니다.
이는 CET LuaJIT/네이티브 UI/게임 상태 머신/애니메이션 테스트가 아닙니다.
이번 버전의 게임용 컴파일/실제 동작은 미검증입니다.
사용자 로그와 개인 경로는 공개 배포물에 포함하지 않았습니다.

## 출처
게임 스크립트: https://codeberg.org/adamsmasher/cyberpunk/commit/17c62d000310f8938beb9593b3892c6c4febeffb
Native Settings UI API: https://github.com/justarandomguyintheinternet/CP77_nativeSettings
참고 모드 코드 및 기반 모드 파일은 복사/포함하지 않았습니다.

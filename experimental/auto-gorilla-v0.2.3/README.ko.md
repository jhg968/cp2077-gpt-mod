# v0.2.3 — 반격 요청 수명 수정과 스태미나/공격 생성 진단

## 변경
공유 Pending 검사에서 근접 대기 상태 요구를 제거했습니다. 대기 상태 요구는 자동 Deflect 진입 결정에만 유지합니다.
기존에는 Deflect 진입 도중 상태10으로 바뀌면 Lua 정리나 OnEnter의 Pending 재검사에서 요청이 사라질 수 있었습니다.
요청 유효시간은 0.2초에서 0.5초로 늘렸습니다. 무기 일치, 스위치, 메뉴 정리, 1회 소비, 쿨다운은 유지합니다.
무한 스태미나나 기본 반격 스태미나 비용 무효화는 추가하지 않았습니다.

## 설치/테스트
기존 AutoGorilla를 끄고 AutoGorilla-v0.2.3-experimental.zip만 활성화하세요. Native Settings UI는 유지합니다.
Mods → AutoGorilla에서 자동 패링/자동 반격/진단 로그를 켭니다.
먼저 추가 스태미나 비용을 0으로 설정하고 같은 상대에게 5~10회 공격받아 비교하세요.
0은 이 모드의 추가 패링 비용만 제거합니다. 기본 게임의 반격 비용은 남습니다.
내 방어, 실제 반격 동작, 적 체력 감소를 각각 기록하고 전용 AutoGorilla.log를 보내주세요.
이전 설정 파일은 새 모드 폴더에 보존하거나 UI에서 다시 설정할 수 있습니다.

## 새 로그
stamina: 현재 실제 스태미나 수치.
parry_stamina: 추가 패링 비용을 차감하기 직전/직후 스태미나. 기본 반격 비용까지 포함한 총비용이 아닙니다.
effect_started: 자동 반격 소유 플래그가 켜진 동안 기본 SpawnAttackGameEffect가 실제 StartAttack 성공을 반환한 횟수.
이는 실제 공격 생성 경로 관측이며 적 타격/최종 피해 성공을 의미하지 않습니다.
pending: 현재 자동 반격 대기 요청.
기존 hit_pipeline=0만으로 실제 타격 부재를 단정하지 않습니다. 이 값은 플래그/무기/현재 상태 필터도 통과해야 증가합니다.

## 검증
Lua 설정/저장/메뉴 정리 테스트와 상태10/20에서 대기 요청이 유지되는 회귀 테스트를 모의 환경에서 통과했습니다.
게임 스크립트에서 SpawnAttackGameEffect의 정확한 시그니처와 StartAttack 반환 경로를 확인했습니다.
이번 redscript 수정과 신규 hook의 게임용 컴파일/게임 실행은 미검증입니다.
사용자 로그는 공개 배포물에 포함하지 않습니다.

---

# AutoGorilla v0.2.3 — 상대 등급·적대 관계 제외 제거

## 변경
보스/맥스택이라는 등급만으로 제외하던 조건과 적대 NPC만 허용하던 조건을 제거했습니다.
가부키 링 같은 퀘스트 대련 상대도 이 두 조건 때문에 제외되지 않습니다.
모든 공격을 강제로 패링 가능하게 만드는 변경은 아닙니다.
기본 방어 각도, 방어 무시 공격 제외, 무기 패링 가능 스탯, 빠른 근접 공격 제외는 유지했습니다.
빠른 근접 공격은 조사한 기본 게임의 패링 분기에서도 제외됩니다.
현재 고릴라 암 근접 대기 상태만 대상으로 하며, 공격/차지/회피 등 동작 중 발동 범위는 확장하지 않았습니다.
일반 플레이에서 패링 가능한 공격 전부를 빠짐없이 처리하는지는 게임 테스트가 필요합니다.
카타나/다른 근접 무기/총알 반사는 아직 구현하지 않았습니다.

## 설치
1. 게임을 종료하고 이전 AutoGorilla 버전을 비활성화합니다.
2. AutoGorilla-v0.2.3-experimental.zip을 MO2에서 설치하고 이 버전만 활성화합니다.
3. CET, redscript, Native Settings UI는 유지합니다.
4. MO2로 게임을 실행하고 Mods → AutoGorilla에서 자동 패링/자동 반격/진단 로그를 켭니다.
Native Settings UI: https://www.nexusmods.com/cyberpunk2077/mods/3518
개인 settings.json은 ZIP에 포함하지 않습니다. 기존 모드 폴더에 설정이 있으면 동일 상대 경로로 보존하거나 UI에서 다시 설정하세요.
MO2 Overwrite에 있는 설정도 확인하세요.

## 설정
자동 패링 / 패링 후 자동 반격 / 추가 스태미나 비용(기본10) / 최소 간격(기본1.2초) / 반격 피해 배율(기본1.0) / 진단 로그.
설정은 변경 즉시 적용하고 settings.json에 자동 저장합니다.
진행 중 반격은 정상 종료하고 대기 요청은 끄기 시 취소합니다. 진행 중 쿨다운은 유지합니다.
기본 반격 자체의 스태미나 비용은 추가 비용과 별도로 발생할 수 있습니다.
설정: bin/x64/plugins/cyber_engine_tweaks/mods/AutoGorilla/settings.json

## 테스트
가부키 링에서 먼저 수동 패링으로 실제 패링 가능한 공격인지 확인합니다.
그 뒤 자동 패링/반격을 켜고 고릴라 암을 꺼낸 채 공격/방어 버튼 없이 같은 종류의 공격을 받습니다.
내 피해 방어, 반격 동작, 적 체력 감소를 각각 확인하세요.
같은 공격 3회 정도를 테스트한 직후 로그를 보내주세요. 퀘스트 승패 처리도 정상인지 확인이 필요합니다.

## 진단
전용 로그: bin/x64/plugins/cyber_engine_tweaks/mods/AutoGorilla/AutoGorilla.log
공통 출력: bin/x64/plugins/cyber_engine_tweaks/scripting.log
컴파일: r6/logs/redscript_rCURRENT.log
MO2 Overwrite에도 생성될 수 있습니다.
seen=플레이어 방어 처리 호출 횟수, reason=가장 최근 피격의 첫 차단 조건/결과.
state=현재 근접 무기 상태(대기2), StrongArms=고릴라 암 태그, CanDeflect=무기 패링 가능 스탯.
parry / counter_enter / hit_pipeline=패링 확인 / 자동 반격 진입 / 반격 피해 계산 경로 횟수.
hit_pipeline만으로 최종 적 피해를 확정하지 않습니다.

## 검증과 제한
redscript는 두 등급/적대 관계 차단문만 제거했고 다른 패링 조건이 유지됐는지 비교했습니다.
기존 설정/저장/UI 콜백/플레이어 연결의 Lua 모의 테스트와 ZIP 무결성 검사를 수행했습니다.
이번 버전의 게임용 컴파일, 실제 대련 패링/반격/피해/퀘스트 처리는 미검증입니다.
기본 패링/반격 상태를 사용하며 적 체력을 직접 깎는 가짜 반격은 사용하지 않습니다.
기본 근접 반격의 AimSnap/조준 보정은 유지됩니다.

## 출처
게임 2.5 공개 스크립트: https://codeberg.org/adamsmasher/cyberpunk/commit/17c62d000310f8938beb9593b3892c6c4febeffb
Native Settings API: https://github.com/justarandomguyintheinternet/CP77_nativeSettings
참고 모드 코드를 복사하지 않았고 게임/기반 모드 파일, 사용자 로그를 배포물에 포함하지 않습니다.

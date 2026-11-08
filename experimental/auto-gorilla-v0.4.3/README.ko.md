# AutoGorilla v0.4.3 — v0.4.2 크래시 경로 분리 빌드

이 빌드는 크래시 해결이 검증된 안정판이 아닙니다. v0.4.2는 계속 사용 중단 상태입니다.

## 로그에서 확인한 내용
v0.4.2 실행의 redscript 컴파일은 완료됐고, scripting.log에는 Lua loaded 및 bridge ready가 모두 있었습니다.
전용 AutoGorilla.log에 bootstrap만 남았다는 사실로 초기화 실패라고 단정할 수 없었습니다.
두 실행의 마지막 기록은 NPC 상태 변경 근처에서 끊겼습니다. 마지막 로그 줄이 크래시 발생 위치라는 보장은 없습니다.
스택 기록이 없으므로 정확한 원인은 아직 확정하지 못했습니다.

## 제거/복원한 범위
실행 이력이 있는 v0.4.1을 기준으로 작성했습니다.
NPCStatesComponent.ChangeUpperBodyState wrapper는 v0.4.1과 바이트 단위로 동일하게 복원했습니다.
v0.4.2의 GetCurrentUpperBodyState 추가 호출과 NoteNPC 경로, NPC 콜백에서 플레이어에 후보를 전달하는 코드를 제거했습니다.
ag42Suggested/ag42PreparedNPC/새 NPC attemptedCycle 필드도 포함하지 않습니다.
후보 조회와 화면 각도 검사는 v0.4.1의 GetObjectClosestToCrosshair/EulerAngles 방식으로 복원했습니다.
가까운 다른 NPC가 플레이어에게 직접 후보를 전달하는 기능은 빠졌으므로 대상은 다시 조준점 가까운 NPC 한 명입니다.

중복 시도/늦은 방어 제한은 플레이어 쪽의 마지막 대상/관측 주기 필드로만 처리합니다.
처음0.12초 안에 시작이 확인된 공격 상태에만 반응하고, 같은 마지막 대상/주기에는 다시 시도하지 않습니다.
쿨다운은 패링 성공 뒤에 적용합니다. 실패한 가드 시도에는 걸지 않습니다.
기본 패링/반격/공격 생성 경로는 유지합니다. 가짜 성공 플래그나 성공 이벤트 억제는 없습니다.
NPC의 기존 타이밍 추적 필드는 v0.4.1과 같고, 기록을 꺼도 추적 메타데이터는 갱신합니다.

## 우선 장착 확인만
1. 게임 종료 후 v0.4.2 및 다른 AutoGorilla/별도 NativeTrace를 모두 비활성화합니다.
2. 이 ZIP을 MO2에 새 모드로 설치하고 이것만 활성화합니다. 이전 버전에 덮어쓰기 병합하지 마세요.
3. CET/redscript/Native Settings UI는 유지하고 MO2로 실행합니다.
4. 기존과 같은 저장을 불러와 고릴라 암을 한 번 꺼낼 수 있는지만 확인하세요. 전투 테스트는 아직 필요 없습니다.
5. 종료되면 반복 재현하지 말고 비활성화하세요. 실행되면 '장착 가능'이라고 알려주세요.
컴파일 및 장착 성공 여부가 이 빌드에서 확인되기 전에는 자동 패링 개선 효과를 주장하지 않습니다.

## 설정과 범위
Mods → AutoGorilla에서 설정합니다. 설정 JSON은 기존처럼 자동 저장합니다.
개인 settings.json은 ZIP에 포함하지 않습니다. 기존 모드 폴더/Overwrite 설정을 보존하거나 UI에서 다시 설정할 수 있습니다.
추가 스태미나 비용, 패링 성공 후 최소 간격, 반격 피해 배율과 각 스위치는 유지합니다.
장착이 확인된 후에만 전투에서 추가비용0/최소간격0.3초/배율1/진단로그 켜기로 비교할 예정입니다.
고릴라 암 대기 상태만 대상입니다. 공격/회피 등 동작 중 발동 범위는 확대하지 않았습니다.
보스/맥스택/적대 관계로 강제 제외하지 않습니다. 패링 성공은 기본 게임 판정에 맡깁니다.
모든 공격의 자동 패링과 매끄러운 가드 동작은 아직 완성되지 않았습니다.

## 로그
bin/x64/plugins/cyber_engine_tweaks/mods/AutoGorilla/AutoGorilla.log
bin/x64/plugins/cyber_engine_tweaks/scripting.log
r6/logs/redscript_rCURRENT.log
MO2 Overwrite에도 있을 수 있습니다. 전용 로그에 기록이 없더라도 공통 로그와 함께 판단해야 합니다.

## 확인한 것 / 확인하지 못한 것
확인: NPC 콜백의 v0.4.1 정확 복원, v0.4.2 후보 전달 경로와 새 NPC 필드 제거,
41개 게임 함수 선언 대조, Lua 설정/저장/로드/로그 모의 테스트, ZIP 내용/무결성 검사.
미확인: 이 빌드의 실제 게임용 컴파일, 장착 크래시 해소, 실제 자동 패링/반격 결과.
Lua 테스트와 함수 존재 확인은 네이티브 게임 실행 안전성을 검증하지 못합니다.
사용자 개인 로그/경로/게임/기반 모드 파일은 배포물에 포함하지 않았습니다.

근거: https://codeberg.org/adamsmasher/cyberpunk/commit/17c62d000310f8938beb9593b3892c6c4febeffb
API: https://github.com/justarandomguyintheinternet/CP77_nativeSettings

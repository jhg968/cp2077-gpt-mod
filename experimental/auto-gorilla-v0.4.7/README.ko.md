# AutoGorilla v0.4.7 — AttackTime 기반 정밀 타격 신호 시험판

## v0.4.6 결과
가부키 기록의 관측된 통지는 isWindUp=1뿐이었고 false 전환은 없었습니다.
따라서 isWindUp=false만 허용하던 옵션은 모든 후보를 제외했습니다. 이 가정과 필터는 폐기했습니다.
새 버전은 v0.4.4 기반이며 v0.4.5 애니메이션 교체 및 v0.4.6 isWindUp hook/필터를 포함하지 않습니다.

## 실제 확인한 AI 공격 생성 경로
AISubActionAttackWithWeapon_Record_Implementation:
Activate: AttackTime=0이면 즉시 AttackWithWeapon.
Update: AttackTime>0이고 duration이 AttackTime에 도달하면 AttackWithWeapon.
Deactivate: AttackTime<0이면 종료 시 AttackWithWeapon.
AttackWithWeapon: 실제 무기/공격 레코드 설정, PrepareAttack, StartAttack.
이번 버전은 이 함수들을 원래대로 실행하면서 NPC 자체의 예정 시간/레코드/호출 순서만 기록합니다.
NPC 상태 콜백에서 플레이어에 후보를 전달하는 v0.4.2 코드는 복원하지 않습니다.

## 옵션
정밀 타격 신호 (실험), 기본 꺼짐: v0.4.4 방식으로 동작하며 새 공격 생성 시점 정보를 기록합니다.
켜짐: 이 AI 경로의 근접 공격이 확인되고 공격 생성까지 남은 시간이 -0.04~0.10초인 경우만 Deflect를 준비합니다.
최근 AI 갱신이0.12초 이상 지난 신호는 제외합니다.
정밀 모드에서는 이전의 넓은 NPC 공격 상태 최초0.12초 제한 대신 실제 subaction 시퀀스/예정시간을 사용합니다.
거리/기본 방어 방향/무기/대기상태/쿨다운 조건은 유지합니다.
공격 시간이0이거나 종료 시 생성되는 공격은 미리 예고할 시간이 없을 수 있으며, 별도 엔진 공격 경로에는 신호가 없을 수 있습니다.
이런 경우 가드가 멈추거나 늦을 수 있으므로 옵션을 끄고 로그를 확인해야 합니다.
가드 성공/피해를 강제로 만들거나 실제 피격을 보류하지 않습니다.

## 설치/짧은 확인
게임 종료 후 기존 AutoGorilla/별도 추적판을 모두 끄고 이 ZIP만 별도 모드로 활성화합니다.
CET/redscript/Native Settings UI는 유지합니다. 우선 장착이 정상인지 확인하세요.
정상이면 추가비용0/성공후간격0.3초/배율1/진단로그 켜기를 유지합니다.
Mods → AutoGorilla의 '정밀 타격 신호 (실험)'를 켜고 약10초 비교하세요.
가드를 아예 안 하거나 잘 맞으면 즉시 끄고 수동 방어로 종료한 뒤 로그를 보내주세요.
꺼진 상태는 v0.4.4 기준 동작이며, 기존 준비 모션 제외 옵션은 제거됐습니다.
이번 버전은 두 번 가드 해결을 보증하는 완성판이 아닙니다.

## 로그
SWING npc=... seq=... contact=... remaining=... attackTime=... duration=... record=...
예정 공격 생성 시점과 피격의 관계를 기록합니다. seq는 해당 AI subaction 활성화 순서이지 고유 타격ID로 보장하지 않습니다.
SWING contact no_valid_attack_schedule은 해당 경로를 아직 확인하지 못했거나 중단/실패했다는 뜻입니다.
정밀 모드 제외: no_fresh_swing_schedule / outside_swing_lead_window / same_swing_already_attempted.
기존 실제 기본 패링/반격/공격 생성/피해 이벤트도 유지합니다.
전용: bin/x64/plugins/cyber_engine_tweaks/mods/AutoGorilla/AutoGorilla.log
공통: bin/x64/plugins/cyber_engine_tweaks/scripting.log
컴파일: r6/logs/redscript_rCURRENT.log
MO2 Overwrite에도 있을 수 있습니다.

## 검증
46개 wrapper 선언과 AttackTime/Update/StartAttack 경로를 공개2.5 소스에서 확인했습니다.
설정7항목/옵션/JSON/로드 및 로그 배출의 Lua 모의 테스트, ZIP 검증 통과.
게임용 컴파일/새 hook 안정성/가부키 공격이 해당 경로를 쓰는지/시간창 적합성/체감 개선은 미검증입니다.
함수가 존재하고 기본 코드가 그렇게 동작한다는 사실만으로 사용자 공격 전체에서 이 경로가 호출된다고 가정하지 않습니다.
사용자 로그/개인 경로/게임 및 기반 모드 파일은 공개 배포하지 않습니다.
근거: https://codeberg.org/adamsmasher/cyberpunk/commit/17c62d000310f8938beb9593b3892c6c4febeffb
core/ai/actions/tweakAISubActions.swift (AISubActionAttackWithWeapon_Record_Implementation)

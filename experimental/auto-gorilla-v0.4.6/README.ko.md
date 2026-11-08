# AutoGorilla v0.4.6 — 준비 동작 구분용 기본 AI 통지 검증

v0.4.4 기반입니다. v0.4.5의 애니메이션 교체/생략은 포함하지 않습니다.
이번 버전은 발견한 기본 isWindUp 정보를 계측하고 실험적으로 필터링하는 빌드입니다. 두 번 가드 문제가 해결됐다고 보증하지 않습니다.

## 조사 근거
기본 AISubActionMeleeAttackAttemptEvent_Record_Implementation.Update는
record.IsWindUp() 값을 AIAttackAttemptEvent.isWindUp에 넣어 실제 공격 대상과 공격자에게 이벤트를 보냅니다.
이 함수의 context/target/record.IsWindUp을 관측하되 원래 함수는 한번 호출하고 반환값도 유지합니다.
새 AI hook은 NPC 자신의 추적 필드에만 데이터를 저장합니다. NPC 상태 콜백에서 플레이어에게 후보를 전달하지 않습니다.
기록 출력과 방어 후보 평가는 기존 플레이어 쪽 후보 조회/피격 관측에서 수행합니다.
GetCurrentAttack이나 EffectPreAction_PreAttack보다 직접적인 준비 구분 정보가 발견돼 이 통지를 우선 검증합니다.
이 통지가 가부키 링의 모든 공격에서 사용되는지, false 통지가 타격보다 충분히 일찍 오는지는 미확인입니다.

## 옵션
'준비 모션 제외 (실험)' 기본 꺼짐: v0.4.4의 기존 자동 동작을 유지하면서 통지 기록을 남깁니다.
켜짐: 대상 NPC가 플레이어를 향해 보낸 isWindUp=false 공격 시도가 최근0.25초 안에 확인된 경우만 자동 방어를 준비합니다.
기존 근접/거리/방어방향/대기상태/최초0.12초 및 중복 제한도 그대로 적용합니다.
따라서 false 통지가 늦거나 없으면 패링을 놓칠 수 있습니다. 켜짐 상태에서 모든 자동 패링이 멈추면 끄세요.
isWindUp=true/false의 실제 통지와 피격 사이 시간을 로그로 확인한 후, 다음 수정에서 기본값과 필터를 결정해야 합니다.
고정 지연을 모든 공격에 적용하거나 실제 피해를 취소해 가짜 반격을 만드는 방식은 사용하지 않습니다.

## 설치와 짧은 비교
1. 게임 종료 후 기존 AutoGorilla와 별도 추적판을 모두 끄고 v0.4.6만 활성화합니다. CET/redscript/Native Settings UI는 유지합니다.
2. 우선 고릴라 암 장착이 정상인지 확인합니다. 튕기면 중단하고 비활성화하세요.
3. Mods → AutoGorilla에서 진단 로그를 켜고 추가비용0/최소간격0.3초/배율1을 유지합니다.
4. '준비 모션 제외 (실험)'를 끈 채 같은 상대에게 약10초 공격받습니다.
5. 옵션을 켠 채 약10초 비교합니다. 자동 방어가 사라지거나 잘 맞으면 즉시 끄고 수동으로 전투를 마무리하세요.
6. 두 번 가드가 줄었는지/반격이 유지되는지와 AutoGorilla.log를 보내주세요. 순서가 섞여도 괜찮습니다.
새 옵션은 기존 settings.json이 있어도 기본 꺼짐이며 변경값은 자동 저장합니다.

## 로그
ATTEMPT stage=candidate/contact npc=... seq=... isWindUp=... age=... record=...
실제 AI 공격 시도 통지와 피격을 NPC별로 연결합니다.
ATTEMPT status=no_event는 해당 NPC에서 통지를 아직 관측하지 못했다는 뜻입니다.
seq는 이 AI 함수의 통지 호출 횟수이며 고유 타격번호로 단정하지 않습니다.
필터 제외 사유: no_attack_attempt_event / windup_filtered / attack_attempt_expired.
기존 AUTO 기본 패링/반격/공격생성/피해 로그도 유지합니다.
전용: bin/x64/plugins/cyber_engine_tweaks/mods/AutoGorilla/AutoGorilla.log
공통: bin/x64/plugins/cyber_engine_tweaks/scripting.log
컴파일: r6/logs/redscript_rCURRENT.log
MO2 Overwrite에도 있을 수 있습니다.

## 검증과 제한
43개 wrapper 선언을 공개2.5 게임 소스와 대조했습니다.
설정7개/새 옵션 기본값/변경/JSON 저장/복원 및 기존 연결의 Lua 모의 테스트와 ZIP 검증 통과.
AI Update의 원래 반환/실행 보존을 확인했고, NPC 상태 콜백은 v0.4.4 그대로입니다.
게임용 컴파일, 새 AI 통지의 발생 시점과 필터 동작, 실행 안정성/체감 개선은 미검증입니다.
실제 타격을 구분하는 정보가 맞는지 아직 검증 전이므로 준비 모션 제외는 실험 옵션입니다.
사용자 로그/개인 경로/게임 및 기반 모드 파일은 공개 배포하지 않습니다.
근거: https://codeberg.org/adamsmasher/cyberpunk/commit/17c62d000310f8938beb9593b3892c6c4febeffb
core/ai/actions/tweakAISubActions.swift (AISubActionMeleeAttackAttemptEvent_Record_Implementation)

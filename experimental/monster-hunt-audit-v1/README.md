# Monster Hunt Audit v1 — CP2077 2.50

괴물 사냥(sts_wat_kab_07) 일괄 완료 기능 개발용 읽기 전용 CET 진단입니다. 완료 기능은 없습니다.

## 설치 및 수집

1. ZIP을 별도 모드로 설치하거나 게임 루트에 풀어 bin 경로가 합쳐지게 합니다. 기존 의뢰/프레임워크 모드는 그대로 둡니다.
2. 게임을 새로 실행하고 괴물 사냥 진행 중인 세이브를 불러온 후 15초 정도 기다립니다.
3. 다음 파일을 첨부합니다: bin/x64/plugins/cyber_engine_tweaks/mods/MonsterHuntAudit/MonsterHuntAudit.txt
4. 보고서가 없으면 bin/x64/plugins/cyber_engine_tweaks/scripting.log를 첨부합니다.
5. 재수집: CET 오버레이 → Monster Hunt Audit v1 → Collect snapshot. 보고서는 덮어씁니다.

GetPlayer/GetQuestsSystem/GetFactStr로 상태만 읽습니다. 자동 수집은 프로세스당 한 번이며, 세이브 변경 후 버튼으로 재수집하세요. IO는 이 모드의 텍스트 보고서만 기록합니다.

## 범위와 검증

업로드한 GameVersion 2500의 sts_wat_kabuki.questphase.json에서 식별한 39개 팩트를 조회합니다. 0은 미설정과 명시적 0을 구분하지 못합니다. 팩트만으로 실제 보상 지급, 일지 성공, 후속 의뢰 해금은 입증할 수 없습니다. 일반 완료와 비살상 완료를 자동 선택하지 않습니다.

LuaJIT 모의 테스트: 자동 1회, 수동 재수집, 플레이어 로드 대기, 개별 조회 실패, 파일 출력 실패 처리 통과. CP2077 실행 검증은 아직 하지 못했습니다.

제거: MonsterHuntAudit 폴더 또는 별도 설치 모드를 제거합니다.

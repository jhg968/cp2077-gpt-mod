# Monster Hunt Native Path Trial v1 — SOURCE ONLY

완성된 자동 완료 모드가 아닙니다. CP2077 2.50 「괴물 사냥」(sts_wat_kab_07)의 원본 처치 경로를 시험하는 소스입니다. 게임용 .archive는 포함하지 않습니다. WolvenKit에서 JSON을 변환하고 프로젝트를 빌드해야 합니다.

## 동작과 범위

ArchiveXL이 메인 퀘스트에 별도 페이즈를 추가합니다. 페이즈는 준비 팩트만 기록하고 사용자의 요청을 기다립니다. CET 버튼은 그 요청 팩트 하나만 1로 바꿉니다. 이후 게임 엔진의 questCharacterManagerCombat_Kill이 #kab_07_com_enemies 커뮤니티의 Jotaro 한 명을 대상으로 실행됩니다.

원본 의뢰의 일지, 보상 레코드, vanilla 완료 팩트는 이 모드가 직접 수정하지 않습니다. 원본 의뢰가 실제 처치를 감지하고, 지역 이탈과 완료 보고를 거쳐 보상을 지급하는지 확인하는 실험입니다. 비살상 루트, 다른 의뢰, NCPD는 지원하지 않습니다.

중요한 미검증 사항: 별도 메인 페이즈 문맥에서 대상 EntityReference가 해석되는지, 대상 스트리밍 상태, 처치 노드 동작, 세이브 복원 시 페이즈 주입. 따라서 목표 NPC가 로드될 수 있도록 호-오 클럽에 접근한 별도 저장에서 시험하세요. 원거리 일괄 완료를 제공하지 않습니다.

## WolvenKit 빌드

1. 새 빈 프로젝트를 만듭니다. 이전에 추출한 가부키 원본을 포함하지 마세요.
2. 이 ZIP의 WolvenKit/source/raw/jhg968 폴더를 새 프로젝트의 source/raw/ 아래에 복사합니다. 결과: source/raw/jhg968/quest_trials/monster_hunt_native_v1.questphase.json
3. WolvenKit Project Explorer의 raw 영역에서 해당 JSON을 우클릭하고 Convert from JSON을 실행합니다.
4. source/archive/jhg968/quest_trials/monster_hunt_native_v1.questphase가 생겼는지 확인합니다. JSON 변환 실패 시 오류를 보내고 중단하세요.
5. 프로젝트를 Pack/빌드해서 생성된 .archive를 찾습니다. 실제 프로젝트 이름에 따라 .archive 이름은 달라도 됩니다.
6. ZIP의 install 폴더 내용을 별도 MO2 모드 폴더에 넣고, 빌드한 .archive를 같은 모드의 archive/pc/mod/ 아래에 추가합니다. .archive.xl과 CET init.lua도 함께 있어야 합니다.

최종 설치 예:
archive/pc/mod/<빌드한프로젝트>.archive
archive/pc/mod/MonsterHuntNativeTrial.archive.xl
bin/x64/plugins/cyber_engine_tweaks/mods/MonsterHuntNativeTrial/init.lua

## 시험

1. 기존 슬롯을 보존하고 시험용 별도 수동 저장을 준비합니다. 모드 설치 후 MO2로 게임을 새로 실행합니다.
2. 괴물 사냥 진행 중인 세이브를 불러와 호-오 클럽으로 접근합니다. 가능하면 조타로가 로드된 상태에서 시험합니다.
3. CET → Monster Hunt Native Trial v1 → Collect status. ready=1이어야 합니다. ready=0이면 실행하지 말고 최신 ArchiveXL 로그를 보내주세요.
4. Run lethal-path trial (one attempt)를 한 번 누릅니다. 이번 시험은 조타로 처치 루트입니다.
5. 원본 의뢰의 목표 변화, 지역 이탈 안내, 레지나 연락, 보상을 확인합니다. 지역을 떠나라는 목표가 뜨면 직접 떠나주세요.
6. 120초 이후 Collect status로 다시 수집하고 MonsterHuntNativeTrial.txt와 일지/보상 변화 내용을 보내주세요.

보고서 위치: bin/x64/plugins/cyber_engine_tweaks/mods/MonsterHuntNativeTrial/MonsterHuntNativeTrial.txt
MO2에서는 진단 모드 실제 폴더 또는 Overwrite에 생성됩니다. 파일이 없으면 scripting.log를 첨부하세요.

ready=1은 주입된 대기 페이즈 실행만, dispatched=1은 처치 노드를 통과한 것만 뜻합니다. 둘 다 처치나 보상 지급의 증거가 아닙니다. kab_07_jotaro_killed 변경과 원본 의뢰의 일지/보상까지 각각 확인해야 합니다.

시도 후 타깃이 처리되지 않으면 재시도하지 말고 보고서를 보내주세요. 요청은 세이브에 남으며, 재시험은 요청 전 저장으로 되돌아가야 합니다. 요청을 0으로 초기화하는 기능은 제공하지 않습니다.

## 검증

ArchiveXL v1.28.0 소스(0984aa1c94df3c090ffe8eee6f549e1d4d466136)의 quest.phases 주입 및 기존 세이브 ForceStartNode 경로를 확인했습니다. 메인 퀘스트 리소스 별칭은 ArchiveXL 기본 QuestBaseScope.xl을 사용합니다. Codeware 소스(b56f0f66749a7a54ffa4d1a6c403ddc655a37ca7)의 공개 ExecuteNode는 outputSockets를 소비하지 않아 원본 그래프 후속 실행을 입증할 수 없으므로 사용하지 않습니다.

정적 검사: JSON 핸들 참조, 대상 Jotaro 한정, 게임 보상/일지 직접 수정 없음. LuaJIT 모의 검사: 자동 실행 없음, 요청 1회, 준비·시작·완료·실패·기존 결과·플레이어 부재 차단. 통과했습니다.

게임 리소스 변환/아카이브 빌드/게임 실행은 이 환경에서 검증하지 못했습니다. 소스 생성에 사용한 JSON 형식 버전은 업로드된 WolvenKit 10.0.0 beta2의 0.0.9, GameVersion 2500입니다. 원본 가부키 전체 파일은 재배포하지 않습니다.

Toggle Quest Tags 2.2.3 KR 보완 v1

첨부된 최신 Toggle Quest Tags 2.2.3 원본을 기준으로 만든 한국어 패치입니다. 2.2.3 원본이 필요합니다.

확인한 차이:
- 번역 문구는 Toggle quest tag → 퀘스트 태그 전환 한 개이며 누락은 없습니다.
- 구형 KR은 InventoryItemModeLogicController.SetInventoryItemButtonHintsHoverOut()의 선언을 private로 덮어씁니다. 2.2.3 원본은 public입니다.

수정: 2.2.3 원본 전체를 유지하고 표시 문구 한 개만 한국어로 교체했습니다. 최신 public 선언을 포함해 입력 처리/태그 전환/필터 로직은 원본 그대로입니다. 구형 KR의 접근 범위 차이가 실제 게임 오류를 유발했는지는 파일 비교만으로 확정하지 않습니다.

MO2 적용:
1. 기존 Toggle Quest Tags KR을 비활성화합니다.
2. Toggle Quest Tags 2.2.3 원본은 활성화합니다.
3. 이 ZIP을 별도 모드로 설치하고 원본 아래에 배치합니다.
4. r6/scripts/toggleQuestTags.reds의 최종 제공자가 새 패치인지 확인합니다.
5. MO2로 게임을 완전히 다시 실행하고 최신 redscript_rCURRENT.log에서 컴파일 완료를 확인합니다.

수동 적용: 기존 toggleQuestTags.reds를 게임 경로 밖에 백업한 뒤 이 ZIP의 동일 경로 파일로 교체합니다. 원본 r6/input/ToggleQuestTags.xml은 유지하세요.

확인: 인벤토리/배낭에서 적용 가능한 아이템에 마우스를 올려 퀘스트 태그 전환 버튼 안내와 단축키 작동을 확인하세요. 원본 입력 XML의 기본 키는 T 및 컨트롤러 왼쪽 스틱 클릭이며, 사용자 입력 설정을 변경하지 않습니다.

검증: 최신 원본 대비 번역 문자열 한 개만 변경, 번역 영역 아래 모든 바이트 일치, 최신 public 선언 유지, ZIP CRC 통과. 실제 REDscript 컴파일과 게임 실행은 아직 미검증입니다.

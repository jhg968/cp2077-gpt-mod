# 실행 API 조사 결과

- Codeware 공개 ExecuteNode: root phase context에서 단일 노드 실행 후 outputSockets를 사용하지 않음. 원본 그래프 연결 진행을 보장하는 근거 없음.
- Codeware 내부 QuestPhaseExecutor::ExecutePath: 별도 구현이 있으나 공개 RTTI 메서드로 노출되지 않음. QuestPhaseRegistry bootstrap 훅은 현재 주석 처리되어 있어 활성 registry로 가정하지 않음.
- ArchiveXL v1.28.0: quest.phases 설정의 parent로 메인 .quest를 지정하면 기존 세이브 복원 시 추가 phase를 ForceStartNode로 시작하는 코드가 있음. 이 경로를 후보로 선택.
- 원본 Monster Hunt: 실제 Jotaro 상태 조건 → 처치 fact → 목표 갱신 → 플레이어 지역 이탈 → 일지 성공 → 완료 보고/보상. fact만 바꾸면 앞쪽 실제 상태 대기 노드를 통과하지 않음.
- 이 소스는 최소 침습 경로 검증용이다. 실행 성공, 목표 사망, 의뢰 성공, 지급 완료는 각각 별도 관찰이 필요하다.

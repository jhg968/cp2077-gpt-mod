# RealSkinn read-only arm probe v1

The user's 08:20 v2 log confirms both source resources loaded (female 3 options, male 2) and the female base/EP1 customization targets received all 3 female options. The visible arm remains absent. Resource assignment alone does not establish entity assembly or rendering correctness.

This probe records live arm component names, enabled flags, 64-bit chunk masks, mesh references, mesh appearance, origin appearance path, and render layer, plus female source/target customization resource and definition names. It uses Codeware's Entity.GetComponents and reflected component fields. No appearance/entity setters, body tags, player data or save files are edited. LoadResource is used for inspection and can cause normal resource-load callbacks in other mods.

## 사용

1. 게임 종료. 원본 RealSkinn과 v2 패치는 그대로 유지합니다. 이전 진단 패치 v1은 비활성화 상태로 둡니다.
2. 이 ZIP을 MO2의 새 모드로 추가합니다. 기존 init.lua를 덮어쓰는 패치가 아니라 독립적인 CET 진단 모드입니다.
3. 게임을 새로 실행하고 문제가 있는 세이브를 불러옵니다.
4. 고릴라 암즈를 꺼낸 상태로 25초 정도 유지합니다. 테스트 중에는 저장하지 마세요.
5. scripting.log 또는 mods/RealSkinnArmProbe 폴더의 모드별 로그에서 `[RealSkinnArmProbe v1]` 기록을 확인해 공유합니다.
6. 로그를 수집한 뒤 이 Probe 모드는 비활성화할 수 있습니다.

CET Bindings에 선택적 수동 스냅샷 항목도 추가됩니다. 자동 로그가 있으면 단축키 설정은 필요 없습니다.
일부 필드가 해당 런타임에 노출되지 않으면 unavailable/nil로 기록합니다. 실행 중 오류가 나면 ERROR로 기록합니다.

## 해석의 한계

- enabled=false 또는 chunkMask=0은 숨김/비활성화 후보를 보여 주지만 어떤 모드가 설정했는지까지 알려주지 않습니다.
- mesh 경로와 외형 이름이 있어도 실제 재질/텍스처 및 올바른 모델이 로딩됐다는 보장은 없습니다.
- 팔이 다른 장착 엔티티에 있다면 플레이어만 조회해서는 놓칠 수 있어 ArmsCyberware/WeaponRight/WeaponLeft 슬롯도 읽습니다.
- 원본 CCO 리소스와 대상 CCO의 resource 경로 및 정의를 비교하지만 어떤 옵션이 최종 캐릭터에 적용됐는지는 추가 대조가 필요합니다.
- 자동 캡처는 플레이어가 존재한 뒤 누적 3/10/20초에 최대 3번만 수행합니다.

모의 LuaJIT 검사 3개를 통과했습니다. 동기/비동기 콜백과 리소스 실패, 정확한 uint64 키 처리를 확인하고, fixture의 게임 상태 필드를 변경하면 실패하도록 검사했습니다. 실제 CET 게임 실행은 미검증입니다.

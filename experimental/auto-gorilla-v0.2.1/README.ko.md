# v0.2.1 진단 업데이트

이 버전은 원인을 확인하기 위한 진단판입니다. 패링 조건을 완화하거나 미확인 원인을 수정했다고 주장하지 않습니다.
기존 AutoGorilla 버전을 끄고 이 ZIP만 활성화하세요. settings.json이 기존 모드에 있으면 새 모드의 같은 상대 경로에 복사하거나 UI에서 다시 설정하세요. Overwrite 설정 파일도 확인하세요.
Mods → AutoGorilla → 진단 로그를 켜고, 고릴라 암을 꺼낸 채 정면의 일반 근접 적에게 3회 정도 공격받으세요.
그 뒤 AutoGorilla.log 또는 scripting.log에서 [AutoGorilla] 줄을 보내주세요.

진단 필드:
- seen: 플레이어를 대상으로 방어 처리 함수가 호출된 횟수. 0이면 아직 그 경로의 피격을 관측하지 못했습니다.
- reason: 가장 최근 방어 처리의 첫 차단 조건/결과. 현재 상태 자체를 나타내는 값은 아닙니다.
- state: 현재 근접 무기 상태, 2가 이 모드에서 요구하는 대기 상태입니다.
- StrongArms: 현재 무기의 StrongArms 태그 유무.
- CanDeflect: 현재 무기의 CanWeaponDeflect 스탯. 무기가 없으면 -1입니다.
- parry / counter_enter / hit_pipeline: 패링 확인 / 자동 반격 진입 / 반격 피해 경로 횟수.

주요 reason:
missing_StrongArms_tag: 현재 무기가 고릴라 암 태그로 식별되지 않음.
weapon_cannot_deflect: 패링 가능 스탯이 0 이하.
not_idle_or_dodging_or_menu: 대기 상태/회피 제외/메뉴 제외 조건 중 하나가 충족되지 않음.
outside_defend_angle: 기존 게임 방어 각도 조건 밖.
unblockable_record: 방어 무시 공격, 의도적으로 제외.
native_did_not_deflect: 모드 조건은 통과했지만 기본 처리에서 패링 확인 실패.
parry_confirmed: 기본 패링 판정 확인.
이후 총탄 등을 맞으면 reason은 새 피격 결과로 바뀔 수 있으므로 근접 공격 직후 로그가 필요합니다.

Lua 시작/초기화/설정 연결 메시지는 진단 스위치와 무관하게 출력합니다.
이제 print와 spdlog.info를 함께 사용하여 scripting.log 및 mods/AutoGorilla/AutoGorilla.log 양쪽에 남깁니다.
전용 로그가 빈 것만으로 이전 버전 로딩 실패를 판단할 수 없습니다.
모의 환경에서 기존 설정 테스트와 전용 logger 호출을 확인했습니다. 새로운 redscript 진단 코드의 게임 내 컴파일은 아직 미검증입니다.
사용자의 첨부 로그/경로/다른 모드 목록은 이 공개 배포물에 포함하지 않습니다.

---

# AutoGorilla v0.2.1 — Native Settings UI 설정창

고릴라 암 자동 패링·반격 실험 모드입니다. v0.2.1는 게임 내 설정창과 설정 저장을 추가합니다.
게임용 redscript 컴파일 및 실제 게임 동작은 아직 미검증입니다.

## 설치 / 업데이트
1. 게임을 완전히 종료합니다.
2. [Native Settings UI](https://www.nexusmods.com/cyberpunk2077/mods/3518)를 다운로드해 MO2에 설치하고 활성화합니다. 해당 페이지의 현재 요구 사항도 확인하세요.
3. 기존 AutoGorilla v0.1은 비활성화합니다. v0.1과 v0.2.1를 동시에 활성화하지 마세요.
4. AutoGorilla-v0.2.1-experimental.zip을 MO2의 압축파일에서 모드 설치로 설치하고 활성화합니다.
5. 모드 최상위에는 bin과 r6가 있어야 합니다. MO2를 통해 게임을 실행합니다.
6. 게임 메뉴의 Mods → AutoGorilla에서 설정합니다. 기본 Settings 화면과 별도인 Native Settings UI의 Mods 메뉴입니다.
7. 제거: 게임 종료 후 AutoGorilla 모드를 비활성화합니다. Root Builder 사용 환경은 복사된 파일 정리도 필요할 수 있습니다.

기반: Cyberpunk 2077 2.5 / Windows / MO2 / 호환되는 CET와 redscript.
AutoGorilla는 별도의 Mod Settings, TweakXL, ArchiveXL을 직접 사용하지 않습니다.
Native Settings UI 파일은 재배포하지 않습니다. 위 원본 페이지에서 설치하세요.

## 설정 항목
| 항목 | 기본값 | 범위 |
|---|---|---|
| 자동 패링 | 켜짐 | 켜기/끄기 |
| 패링 후 자동 반격 | 켜짐 | 켜기/끄기 |
| 추가 스태미나 비용 | 10 | 0–100 |
| 최소 발동 간격 | 1.2초 | 0.3–10초 |
| 반격 피해 배율 | 1.0 | 0–5 |
| 진단 로그 | 꺼짐 | 켜기/끄기 |

변경 즉시 적용하고 자동 저장합니다. reds 파일 수정과 설정 변경 후 재시작은 필요 없습니다.
진행 중인 반격은 끄기 후에도 정상 종료하며, 대기 중인 자동 반격 요청은 취소합니다.
이미 진행 중인 쿨다운은 유지하고 새 간격은 다음 패링부터 적용합니다.
게임/세이브 로드 후 0.1초 간격으로 현재 플레이어에 설정을 다시 적용합니다.
CET 설정 연결이 준비되지 않았다면 자동 패링은 비활성화 상태로 유지됩니다.
Native Settings UI만 없으면 저장된 값/기본값으로 실행되지만 설정 메뉴는 표시되지 않고 CET 콘솔에 안내가 나옵니다.
Native Settings UI의 Defaults 기능으로 항목을 기본값으로 복원할 수 있습니다.

## 설정 파일
bin/x64/plugins/cyber_engine_tweaks/mods/AutoGorilla/settings.json
최초 설정 변경 때 생성합니다. 설치 ZIP에는 개인 설정을 덮어쓰는 settings.json이 없습니다.
MO2에서는 모드 폴더 또는 Overwrite에 생성될 수 있습니다. 업데이트 시 이 파일을 보존하세요.
설정은 세이브별이 아닌 이 설정 파일을 공유하는 설치 환경에 적용됩니다.
읽을 수 없는 JSON은 기본값으로 처리하고 로그를 남기며, 다음 설정 변경 때 파일을 다시 저장합니다.
쓰기 실패는 CET 콘솔의 Cannot save settings 메시지로 확인할 수 있습니다.

## 테스트 순서
1. Mods → AutoGorilla 메뉴와 6개 항목이 보이는지 확인합니다.
2. 진단 로그를 켜고 추가 비용 17, 간격 2.3초, 배율 1.4 등 구분되는 값을 선택합니다.
3. 메뉴를 닫았다 열어 값이 유지되는지, 게임 종료/재시작 후에도 유지되는지 확인합니다.
4. 자동 패링을 끄고 일반 근접 공격에 자동 방어하지 않는지 확인합니다.
5. 자동 패링만 켜고 자동 반격은 꺼서 두 기능이 분리되는지 확인합니다.
6. 둘 다 켜고 고릴라 암을 든 대기 상태에서 정면의 일반 근접 적에게 공격받습니다.
7. 내 피해 방어 / 실제 반격 동작 / 적 체력 감소를 각각 기록합니다.
8. 무기 교체, 메뉴 진입, 세이브 로드 후 설정과 전투 상태가 정상인지 확인합니다.
테스트용 수동 저장을 사용하고 다른 자동 방어 모드는 테스트 프로필에서 끄세요.

## 로그와 제한
CET 콘솔의 [AutoGorilla] 출력에서 parry / counter_enter / hit_pipeline을 확인합니다.
hit_pipeline은 피해 계산 경로 진입 횟수이며 최종 피해 성공은 적 체력 감소로 확인해야 합니다.
redscript 컴파일 로그: r6/logs/redscript_rCURRENT.log
CET 기본 로그: bin/x64/plugins/cyber_engine_tweaks/cyber_engine_tweaks.log
MO2 가상 경로에서 생성된 로그는 Overwrite에도 있을 수 있습니다.

범위는 v0.1과 같습니다. 고릴라 암을 꺼내 근접 대기 중 정면의 일반 적대 NPC 근접 공격만 대상으로 합니다.
공격/차지/회피 중, 빠른 근접 공격, 방어 무시 공격, 보스/맥스택은 제외합니다.
카타나/다른 근접 무기/총알 반사는 아직 구현하지 않았습니다.
추가 비용은 기본 반격 자체 스태미나 비용과 별도입니다.
기본 게임의 패링/반격 상태와 피해 처리를 사용하며 적 체력을 직접 깎지 않습니다.
기본 반격의 AimSnap/조준 보정은 유지됩니다.

## 이 환경에서 확인한 내용
Native Settings UI 원본 addTab/addSubcategory/addSwitch/addRangeFloat API를 확인했습니다.
참조 커밋: 4065b51456f5e3df8f29e1dc3c07edcc294e68e9
설정 검증/범위 제한, 실제 CET json.lua를 사용한 저장/복원, 손상 JSON 복구,
6개 UI 콜백, 플레이어 설정 반영, 플레이어 재생성 후 복원, 메뉴 정리, UI 의존성 누락을
Lua 5.4 기반 모의 환경에서 테스트했습니다. 실제 CET LuaJIT/네이티브 UI 렌더링 테스트는 아닙니다.
게임용 컴파일, UI 표시와 한글 표시, 실제 패링/반격/피해는 사용자 게임에서 확인해야 합니다.

## 출처
Native Settings UI API: https://github.com/justarandomguyintheinternet/CP77_nativeSettings
CET JSON/샌드박스 API: https://github.com/maximegmd/CyberEngineTweaks
게임 2.5 공개 스크립트: https://codeberg.org/adamsmasher/cyberpunk/commit/17c62d000310f8938beb9593b3892c6c4febeffb
참고 설명: https://www.nexusmods.com/cyberpunk2077/mods/10745
참고 설명: https://www.nexusmods.com/cyberpunk2077/mods/14596
두 참고 모드 파일/코드와 게임/기반 모드 파일은 포함하지 않았습니다.

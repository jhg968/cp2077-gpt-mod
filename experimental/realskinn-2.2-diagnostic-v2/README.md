# v2 추가 수정

사용자의 08:16:35 실행에서 v1은 소스 콜백을 미등록 콜백으로 오판했습니다.
원인은 GetHash()의 uint64 값 객체를 Lua 테이블 키로 직접 사용한 것입니다.
같은 숫자여도 새 객체라면 LuaJIT의 테이블 키로 일치하지 않을 수 있습니다.
이는 v1 진단 패치의 결함이며, 원래 고릴라 암즈 투명 현상의 원인을 확정한 것은 아닙니다.

v2는 등록/콜백 양쪽에서 `tostring(token:GetHash())`로 정확한 문자열 키를 사용합니다.
`tonumber`는 2^53 이상에서 정밀도를 잃으므로 사용하지 않습니다.
실제 로그와 같은 새 uint64 객체로 v1 중단을 재현하고, 수정본에서 비동기/역순/동기 및 실패 처리 테스트를 통과했습니다.

기존 v1을 끄고 이 v2 ZIP을 별도 MO2 모드로 설치하세요. 원본 RealSkinn은 계속 켜고 v2가 원본 init.lua를 덮어쓰도록 설정하세요.
새로 실행한 뒤 scripting.log의 `[RealSkinnDiag v2]` 중 `SOURCE READY`, `SOURCES COMPLETE`, `APPLY`, `PATCH` 및 오류를 확인합니다.

---

# RealSkinn Gorilla Arms 2.2 — loading fix and diagnostics v2

User-provided RealSkinn 2.2 Lua initialization code contains a malformed male resource path and an invalid pending-source count (`#` on a hash-keyed table). This unofficial patch fixes those two problems and logs the actual resource-patching results. It is NOT a confirmed VTK 2.0.6 compatibility fix.

The 07:48 scripting log confirms RealSkinn loads and runs onInit, but the original script does not report whether its resource callbacks succeed. VTK VanillaHD and ANGEL XL files provided by the user declare body types and torso patches, not a direct Gorilla Arms hide rule. Kiasu's core defines conditional arm-hiding tags; this patch does not modify those tags.

## 설치

1. 게임을 완전히 종료합니다.
2. 이전 진단 패치 v1은 비활성화합니다. 원본 RealSkinn 2.2, 원본 아카이브, VTK/ANGEL 및 필수 의존성은 그대로 유지합니다.
3. ZIP을 MO2에 별도 모드로 설치해 원본 RealSkinn보다 높은 파일 우선순위를 줍니다.
4. 게임을 새로 실행합니다. CET Reload All Mods로 대체하지 마세요.
5. 기존에 증상이 있던 세이브에서 여성 고릴라 암즈가 여전히 투명한지 확인합니다. 테스트 중에는 저장하지 마세요.
6. 새 실행의 `bin/x64/plugins/cyber_engine_tweaks/scripting.log`를 공유합니다. 모드별 로그에 출력됐다면 `mods/2bt_Gorilla_Arms` 폴더의 새 `.log`도 확인하세요.

ZIP은 기존 init.lua 하나만 덮어씁니다. 별도의 두 번째 CET 모드 폴더를 만들지 않습니다. 바디/재질/메시 아카이브와 전역 숨김 태그는 변경하지 않습니다.

## 로그 해석

`[RealSkinnDiag v2] START`가 없으면 이 init.lua가 실행되지 않았거나 다른 스크립트 로그에 기록된 것입니다.
`SOURCE READY`는 원본 아카이브에서 외형 옵션을 읽었음을 나타냅니다.
`SOURCES COMPLETE`는 로드 요청이 완료된 뒤에만 출력됩니다. 읽은 옵션 수와 실패 수를 확인하세요.
`APPLY`와 `PATCH ... matched=N`은 대상 리소스에 실제로 대입한 옵션을 보여 줍니다. 이것만으로 팔이 화면에 정상 표시된다는 뜻은 아닙니다.
`ERROR`는 경로 로딩, nil 리소스 또는 콜백 실행 실패를 나타냅니다.
`WARNING source option overlap`는 두 소스가 같은 옵션 이름을 제공했다는 뜻입니다. 이 패치는 원본처럼 마지막으로 읽은 소스를 유지하고 출처를 기록합니다. 성별 분기를 임의로 바꾸지 않았습니다.

## 변경 및 검증

- 남성 기본 CCO 경로의 단일 역슬래시(`\f`) 오류 수정.
- pending 카운터와 scheduling barrier로 소스 완료 순서에 관계없이 대상 로드를 한 번 시작.
- 콜백 등록 전에 토큰을 보관하여 즉시 완료되는 콜백도 처리.
- 소스 준비 전 Resource/Load 이벤트는 준비 완료 후 적용.
- 리소스 실패, 매칭 옵션 수, 옵션 출처, 콜백 오류를 로그에 기록.
- 모의 테스트 20개(일반 숫자 및 매 호출 새 uint64 객체)와 v1 결함 재현: 비동기/동기/역순/조기 이벤트/여성 소스 실패/전체 실패/대상 실패/매칭 없음/nil 소스/옵션 중복.

모의 테스트는 실제 CET/Codeware 게임 실행 검증을 대신하지 않습니다. 게임 내 테스트는 아직 미실시입니다.
테스트 재실행에는 Python의 lupa 패키지가 필요합니다. `python test_diagnostic.py`로 실행합니다.

## 원복

MO2에서 이 진단 패치만 비활성화하여 원본 RealSkinn init.lua를 복구합니다.

원본 Lua와 리소스는 사용자가 제공한 2BT RealSkinn Gorilla Arms 2.2를 기반으로 합니다. 이 ZIP은 비공식 Lua 수정본만 포함합니다.

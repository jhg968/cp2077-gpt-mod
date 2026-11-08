# AutoGorilla v0.1 — Cyberpunk 2077 2.5 실험 버전

고릴라 암 자동 근접 패링과 기본 반격 상태 연결을 시험하는 redscript + CET 모드입니다.
게임용 컴파일 및 실제 게임 동작은 아직 검증하지 않았습니다. 완성판이 아닙니다.

## 요구 사항
Windows, Cyberpunk 2077 2.5, 해당 게임 버전에서 정상 작동하는 redscript와 Cyber Engine Tweaks, MO2.
별도 TweakXL/ArchiveXL/Mod Settings는 이 코드에서 사용하지 않습니다.

## 설치
1. 게임을 종료하고 MO2 프로필을 복사해 테스트용으로 사용합니다.
2. 다른 자동 방어/반격 모드를 테스트 프로필에서 끕니다.
3. AutoGorilla-v0.1-experimental.zip을 MO2의 압축파일에서 모드 설치로 설치하고 활성화합니다.
4. 모드 최상위에 r6와 bin 폴더가 있어야 합니다. MO2를 통해 게임을 실행합니다.
5. 게임 종료 후 모드를 비활성화하면 제거됩니다. 기존 Root Builder 배포 환경은 해당 도구의 정리 기능도 필요할 수 있습니다.

## 범위와 설정
고릴라 암을 꺼내 근접 대기 중일 때, 정면의 적대 일반 NPC 근접 공격만 대상으로 합니다.
공격/차지/회피 중, 빠른 근접 공격, 방어 무시 공격, 보스/맥스택은 제외합니다.
카타나/다른 근접 무기/총알 반사는 아직 구현하지 않았습니다.
AutoGorilla.reds 상단의 Parry/Counter는 개별 스위치입니다.
Cost=10은 패링 성공 시 추가 스태미나 비용이며, 기본 반격 비용은 별도로 발생할 수 있습니다.
Interval=1.2초(최소 0.3), Damage=1.0은 반격 피해 배율입니다. 수정 후 게임을 재시작하세요.

## 테스트
1. 별도 수동 저장을 만듭니다. 먼저 모드 없이 고릴라 암 수동 패링/반격이 되는지 확인합니다.
2. 모드를 켜고 일반 근접 적 한 명을 정면에 두고 공격/방어 버튼 없이 공격받습니다.
3. 내 피해 방어, 실제 팔 반격 동작, 적 체력 감소를 각각 기록합니다.
4. 공격 중/회피 중/뒤에서 맞을 때 제외되는지 확인합니다.
5. 무기 교체, 메뉴 진입/복귀, 저장 불러오기 후 상태 고정이나 반복 발동이 없는지 확인합니다.

## 진단
CET 콘솔의 [AutoGorilla] 출력을 확인하세요.
parry=기본 패링 확인, counter_enter=자동 반격 상태 진입, hit_pipeline=그 반격의 피해 계산 경로 진입 횟수입니다.
hit_pipeline 증가는 최종 피해 성공의 증명이 아닙니다. 적 체력 감소까지 확인해야 합니다.
컴파일 실패 시 게임을 종료하고 모드를 비활성화한 뒤 r6/logs/redscript_rCURRENT.log의 첫 ERROR부터 확인합니다.
CET 기본 진단 로그: bin/x64/plugins/cyber_engine_tweaks/cyber_engine_tweaks.log
MO2 가상 경로에서 생성된 로그는 Overwrite에도 있을 수 있습니다.

## 검증과 제한
감싸는 게임 함수 8개가 아래 2.5 공개 스크립트에 실제 선언되어 있음을 확인했습니다.
Lua 5.4 파서 문법 검사 통과. CET LuaJIT 실행, redscript 게임용 컴파일, 실제 동작은 미검증입니다.
피해 처리 시 임시 IsDeflecting modifier를 추가한 뒤 같은 호출 안에서 제거하고 기본 패링 판정을 사용합니다.
그 후 0.2초 이내 기본 MeleeDeflect 상태에 진입해 successfulDeflect를 전달하는 실험적 연결입니다.
프레임 간 이벤트 전달과 고릴라 암 반격 레코드가 사용자 게임에서 작동하는지 확인해야 합니다.
적 체력을 직접 깎거나 별도의 가짜 반격 피해를 만드는 코드는 없습니다.
기본 근접 반격의 AimSnap/조준 보정은 유지되므로 화면 보정이 생길 수 있습니다.
쿨다운, 진행 중 플래그, 무기/요청 유효시간 검사와 종료/로드 정리를 사용합니다. 실제 상태 정리는 게임 테스트가 필요합니다.

## 조사 출처와 권한
공개 게임 스크립트: https://codeberg.org/adamsmasher/cyberpunk/commit/17c62d000310f8938beb9593b3892c6c4febeffb
주요 경로: cyberpunk/damage/damageManager.swift, damageSystem.swift, cyberpunk/player/psm/meleeTransitions.swift
참고 설명: https://www.nexusmods.com/cyberpunk2077/mods/10745
참고 설명: https://www.nexusmods.com/cyberpunk2077/mods/14596
두 Nexus 모드의 파일은 확보하지 않았고 해당 코드를 복사하지 않았습니다. 이 ZIP에는 게임/기반 모드 파일을 포함하지 않습니다.
Cyber Ninja는 수정/사용을 허용하되 재업로드 작성자 표기 등의 조건이 있습니다.
총알 반사 모드는 수정/자산 사용에 사전 허가를 요구하므로 별도 권한 없이 재사용하지 않습니다.

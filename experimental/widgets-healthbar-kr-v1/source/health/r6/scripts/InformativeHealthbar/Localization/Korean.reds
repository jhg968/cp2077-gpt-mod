// Informative Healthbar - Korean Localization
module InformativeHealthbar

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

public class Korean extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    
    // ============================================
    // CORE — Mod Name & Categories
    // ============================================
    this.Text("IH.Core.mod.Name", "Informative Healthbar");
    this.Text("IH.Core.category.LayoutTheme", "레이아웃 & 테마");
    this.Text("IH.Core.category.VanillaTweaks", "바닐라 HUD 조정");
    this.Text("IH.Core.category.BuffsDebuffs", "버프 & 디버프");
    this.Text("IH.Core.category.WidgetSorting", "위젯 정렬");
    this.Text("IH.Core.category.CoreStats", "위젯: 핵심 스탯");
    this.Text("IH.Core.category.CustomTrackers", "위젯: 커스텀 트래커");
    this.Text("IH.Core.category.ModSupport", "위젯: 모드 지원");

    // ============================================
    // CORE — Layout & Theme
    // ============================================
    this.Text("IH.Core.theme.Name", "색상 테마");
    this.Text("IH.Core.theme.Desc", "색상 테마를 선택합니다: 전체 색상, 아이콘 색상, 클래식 블루, 클래식 옐로, 클래식 레드");
    this.Text("IH.Core.theme.FullColored", "전체 색상");
    this.Text("IH.Core.theme.IconColored", "아이콘 색상");
    this.Text("IH.Core.theme.ClassicBlue", "클래식 블루");
    this.Text("IH.Core.theme.ClassicYellow", "클래식 옐로");
    this.Text("IH.Core.theme.ClassicRed", "클래식 레드");
    this.Text("IH.Core.theme.ClassicWhite", "클래식 화이트");

    this.Text("IH.Core.position.Name", "위치");
    this.Text("IH.Core.position.Desc", "체력 바 아래는 겹침을 피하지만 스태미나 바를 아래로 밀어냅니다. 위쪽은 체력 바 위에 표시됩니다.");
    this.Text("IH.Core.position.Above", "체력 바 위");
    this.Text("IH.Core.position.Below", "체력 바 아래");

    this.Text("IH.Core.offsetX.Name", "X 오프셋");
    this.Text("IH.Core.offsetX.Desc", "X 방향(좌우) 오프셋을 보정합니다. 레벨 프레임에 맞추려면 -66.0으로 설정하세요.");
    this.Text("IH.Core.offsetY.Name", "Y 오프셋");
    this.Text("IH.Core.offsetY.Desc", "Y 방향(상하) 오프셋을 보정합니다.");
    this.Text("IH.Core.childMargin.Name", "위젯 간격");
    this.Text("IH.Core.childMargin.Desc", "각 스탯 사이의 가로 간격을 조정합니다.");
    this.Text("IH.Core.panelScale.Name", "패널 크기");
    this.Text("IH.Core.panelScale.Desc", "전체 패널을 확대하거나 축소합니다(1.0이 기본 크기).");

    // ============================================
    // CORE — Vanilla HUD Tweaks
    // ============================================
    this.Text("IH.Core.hideLevelBadge.Name", "바닐라 레벨 배지 숨기기");
    this.Text("IH.Core.hideLevelBadge.Desc", "체력 바 왼쪽에 붙은 큰 캐릭터 레벨 배지를 숨깁니다. 레벨 표시 위젯과 함께 사용하세요. (E3 HUD가 활성화된 경우 무시됨)");
    this.Text("IH.Core.hideBars.Name", "바닐라 바 숨기기");
    this.Text("IH.Core.hideBars.Desc", "바닐라 체력, RAM, 경험치 바를 숨깁니다. (E3 HUD가 활성화된 경우 무시됨)");
    this.Text("IH.Core.hideCounters.Name", "바닐라 카운터 숨기기");
    this.Text("IH.Core.hideCounters.Desc", "숫자 체력 및 RAM 카운터를 숨깁니다. (E3 HUD가 활성화된 경우 무시됨)");
	this.Text("IH.Core.hideBuffs.Name", "바닐라 버프 숨기기");
    this.Text("IH.Core.hideBuffs.Desc", "체력 바 옆에 표시되는 상태 효과 아이콘(버프 및 디버프)을 숨깁니다. (E3 HUD가 활성화된 경우 무시됨)");
    this.Text("IH.Core.ramFix.Name", "RAM 바 수정 활성화");
    this.Text("IH.Core.ramFix.Desc", "사이버덱 RAM 슬롯이 많을 때 RAM 바를 줄이고, 현재/최대 카운터 표시를 추가하며, 큰 RAM 바가 체력 바 위치를 밀어내지 않도록 합니다. (참고: 충돌 방지를 위해 E3 HUD가 감지되면 자동으로 비활성화됩니다!)");
	this.Text("IH.Core.alwaysShowBars.Name", "항상 체력 바 표시");
    this.Text("IH.Core.alwaysShowBars.Desc", "전투 중이 아니거나 체력이 가득 찬 상태에서도 체력 바가 자동으로 숨겨지지 않게 합니다.");
	this.Text("IH.Core.showRamText.Name", "RAM 카운터 텍스트 표시");
    this.Text("IH.Core.showRamText.Desc", "체력 바에 RAM 현재/최대 카운터를 숫자로 표시합니다.");
    this.Text("IH.Core.ramHOffset.Name", "RAM 카운터 - 가로 오프셋");
    this.Text("IH.Core.ramHOffset.Desc", "양수 = 오른쪽, 음수 = 왼쪽. 기본값 0.");
    this.Text("IH.Core.ramVOffset.Name", "RAM 카운터 - 세로 오프셋");
    this.Text("IH.Core.ramVOffset.Desc", "양수 = 위, 음수 = 아래. 기본값 0.");
    this.Text("IH.Core.ramFontSize.Name", "RAM 카운터 - 글꼴 크기");
    this.Text("IH.Core.ramFontSize.Desc", "RAM 카운터 텍스트의 글꼴 크기입니다. 기본값 32.");

    // ============================================
    // CORE — Buffs & Debuffs
    // ============================================
    this.Text("IH.Core.debuffStyle.Name", "디버프 색상 스타일");
    this.Text("IH.Core.debuffStyle.Desc", "디버프 색상 방식을 선택합니다. 바닐라 = 모두 파란색, 아이콘만 = 빨간 아이콘, 전체 = 디버프 위젯 전체 빨간색.");
    this.Text("IH.Core.debuffStyle.Vanilla", "바닐라");
    this.Text("IH.Core.debuffStyle.IconsOnly", "아이콘만");
    this.Text("IH.Core.debuffStyle.FullColor", "전체 색상");
	this.Text("IH.Core.debuffStyle.IconsOnly_Green", "아이콘만(녹색 버프)");
    this.Text("IH.Core.debuffStyle.FullColor_Green", "전체 색상(녹색 버프)");

    this.Text("IH.Core.debuffCounterPos.Name", "카운터 위치");
    this.Text("IH.Core.debuffCounterPos.Desc", "지속시간 카운터를 상태 효과 아이콘 위/아래 중 어디에 표시할지 선택합니다.");
    this.Text("IH.Core.debuffCounterPos.Above", "아이콘 위");
    this.Text("IH.Core.debuffCounterPos.Below", "아이콘 아래");

    // ============================================
    // CORE — Widget Sorting
    // ============================================
    this.Text("IH.Core.widgetSorting.Name", "커스텀 위젯 정렬 활성화");
    this.Text("IH.Core.widgetSorting.Desc", "스탯 패널 위젯의 좌우 순서를 직접 재배치할 수 있습니다.");

    // ============================================
    // CORESTATS
    // ============================================
    this.Text("IH.CoreStats.showLifepath.Name", "라이프패스 표시");
    this.Text("IH.CoreStats.showLifepath.Desc", "아이콘과 라이프패스 이름을 표시합니다. The Fresh Start와 호환됩니다. (레벨 표시가 활성화된 경우 무시됨)");
    this.Text("IH.CoreStats.showLevel.Name", "레벨 표시(라이프패스 대체)");
    this.Text("IH.CoreStats.showLevel.Desc", "라이프패스 텍스트를 캐릭터 레벨로 대체합니다.");
    this.Text("IH.CoreStats.showStreetCred.Name", "평판 표시");
    this.Text("IH.CoreStats.showStreetCred.Desc", "현재 평판을 표시합니다.");
    this.Text("IH.CoreStats.showMoney.Name", "소지금 표시");
    this.Text("IH.CoreStats.showMoney.Desc", "Numerals Get Commas 모드를 사용해 표시 형식을 지정합니다.");
    this.Text("IH.CoreStats.showCarryWeight.Name", "소지 무게 표시");
    this.Text("IH.CoreStats.showCarryWeight.Desc", "Flesh And Chrome - Carry Overhaul과 호환됩니다.");
    this.Text("IH.CoreStats.weightDisplay.Name", "소지 무게 형식");
    this.Text("IH.CoreStats.weightDisplay.Desc", "절대값(현재/최대) 또는 백분율(%) 중 선택합니다.");
    this.Text("IH.CoreStats.weightDisplay.Values", "수치");
    this.Text("IH.CoreStats.weightDisplay.Percentage", "백분율");
    this.Text("IH.CoreStats.showArmor.Name", "방어력 표시");
    this.Text("IH.CoreStats.showArmor.Desc", "현재 방어력 수치를 표시합니다. Chrome Plating 사용 시 방어구 내구도 %로 전환됩니다.");
    this.Text("IH.CoreStats.lifepathHybrid", "하이브리드");

    this.Text("IH.CoreStats.lifepathOrder.Name", "순서: 라이프패스 / 레벨");
    this.Text("IH.CoreStats.streetCredOrder.Name", "순서: 평판");
    this.Text("IH.CoreStats.moneyOrder.Name", "순서: 소지금");
    this.Text("IH.CoreStats.weightOrder.Name", "순서: 소지 무게");
    this.Text("IH.CoreStats.armorOrder.Name", "순서: 방어력");

    // ============================================
    // CLOCK
    // ============================================
    this.Text("IH.Clock.showClock.Name", "게임 시계 표시");
    this.Text("IH.Clock.showClock.Desc", "나이트 시티의 현재 게임 내 시간을 표시합니다. 미니맵 없는 설정에 적합합니다!");
    this.Text("IH.Clock.clockOrder.Name", "순서: 게임 시계");
	this.Text("IH.Clock.clockFormat.Name", "게임 시계: AM/PM 사용");
    this.Text("IH.Clock.clockFormat.Desc", "24시간제와 12시간제(AM/PM) 시계 형식을 전환합니다.");
	this.Text("IH.Clock.Suffix.AM", " AM"); //leading space
    this.Text("IH.Clock.Suffix.PM", " PM"); //leading space

    // ============================================
    // HEALTH
    // ============================================
    this.Text("IH.Health.showTracker.Name", "체력 트래커 표시");
    this.Text("IH.Health.showTracker.Desc", "체력을 정확한 수치 또는 백분율로 표시합니다.");
    this.Text("IH.Health.healthDisplay.Name", "체력 형식");
    this.Text("IH.Health.healthDisplay.Desc", "절대값(현재/최대) 또는 백분율(%) 중 선택합니다.");
    this.Text("IH.Health.healthDisplay.Values", "수치");
    this.Text("IH.Health.healthDisplay.Percentage", "백분율");
    this.Text("IH.Health.healthTrackerOrder.Name", "순서: 체력 트래커");

    // ============================================
    // KILLS
    // ============================================
    this.Text("IH.Kills.showTracker.Name", "처치 트래커 표시");
    this.Text("IH.Kills.showTracker.Desc", "총 누적 처치 수(처치 + 제압)를 표시합니다.");
    this.Text("IH.Kills.killsTrackerOrder.Name", "순서: 처치 트래커");
    this.Text("IH.Kills.useStealthrunner.Name", "Stealthrunner 기록 사용");
    this.Text("IH.Kills.useStealthrunner.Desc", "기본 게임의 처치 트래커를 Stealthrunner의 처치 기록으로 대체합니다.");
	
    // ============================================
    // CAMO
    // ============================================
    this.Text("IH.Camo.showCamo.Name", "광학 위장 표시");
    this.Text("IH.Camo.showCamo.Desc", "광학 위장의 활성 충전량/쿨다운을 표시합니다. 100%일 때는 자동으로 숨깁니다.");
    this.Text("IH.Camo.camoOrder.Name", "순서: 광학 위장");
    this.Text("IH.Camo.prefix", "위장");

    // ============================================
    // OS COOLDOWN
    // ============================================
    this.Text("IH.OS.showCooldown.Name", "OS 쿨다운 표시");
    this.Text("IH.OS.showCooldown.Desc", "산데비스탄과 버서크의 활성 충전량/쿨다운을 표시합니다. 완전히 준비되면 자동으로 숨깁니다.");
    this.Text("IH.OS.osCooldownOrder.Name", "순서: OS 쿨다운");
    this.Text("IH.OS.prefixSandy", "산데");
    this.Text("IH.OS.prefixBerserk", "버서크");

    // ============================================
    // PACIFIST
    // ============================================
    this.Text("IH.Pacifist.showTracker.Name", "비살상 트래커 표시");
    this.Text("IH.Pacifist.showTracker.Desc", "총 누적 비살상 제압 수(의식을 잃은 적)를 표시합니다.");
    this.Text("IH.Pacifist.pacifistTrackerOrder.Name", "순서: 비살상 트래커");
    this.Text("IH.Pacifist.useStealthrunner.Name", "Stealthrunner 기록 사용");
    this.Text("IH.Pacifist.useStealthrunner.Desc", "기본 게임의 비살상 제압 트래커를 Stealthrunner의 기록으로 대체합니다.");

    // ============================================
    // RAM TRACKER
    // ============================================
    this.Text("IH.RAM.showTracker.Name", "RAM 트래커 표시");
    this.Text("IH.RAM.showTracker.Desc", "사이버덱 RAM을 텍스트 카운터로 표시합니다. 사이버덱을 장착하지 않으면 자동으로 숨깁니다.");
    this.Text("IH.RAM.ramTrackerOrder.Name", "순서: RAM 트래커");

    // ============================================
    // STAMINA
    // ============================================
    this.Text("IH.Stamina.showStamina.Name", "스태미나 표시");
    this.Text("IH.Stamina.showStamina.Desc", "스태미나 백분율을 동적으로 표시합니다. Flesh & Chrome과 호환됩니다.");
    this.Text("IH.Stamina.staminaOrder.Name", "순서: 스태미나");
    this.Text("IH.Stamina.useFACColors.Name", "Flesh & Chrome 스태미나 색상");
    this.Text("IH.Stamina.useFACColors.Desc", "스태미나 위젯에 Flesh & Chrome 기반 동적 색상을 적용합니다.");

    // ============================================
    // FLESH & CHROME: ENERGY
    // ============================================
    this.Text("IH.Energy.showEnergy.Name", "Flesh & Chrome: 에너지 표시");
    this.Text("IH.Energy.showEnergy.Desc", "Flesh & Chrome 모드의 현재 에너지 수치를 표시합니다.");
    this.Text("IH.Energy.energyOrder.Name", "순서: 에너지(Flesh & Chrome)");

    // ============================================
    // WANTED
    // ============================================
    this.Text("IH.Wanted.showWanted.Name", "수배 레벨 표시");
    this.Text("IH.Wanted.showWanted.Desc", "현재 NCPD 수배 단계를 표시합니다(1~5).");
    this.Text("IH.Wanted.hideWantedZero.Name", "수배 해제 시 숨기기");
    this.Text("IH.Wanted.hideWantedZero.Desc", "활성화하면 현상금이 없을 때 트래커가 완전히 사라집니다. 비활성화하면 해제 상태로 계속 표시됩니다.");
	this.Text("IH.Wanted.showSubMetrics.Name", "수배 세부 정보 표시");
    this.Text("IH.Wanted.showSubMetrics.Desc", "수배도 진행률과 도주·해제 타이머 등 NCPD 추격 세부 정보를 표시합니다.");
    this.Text("IH.Wanted.wantedOrder.Name", "순서: 수배 레벨");
    this.Text("IH.Wanted.clear", "해제");
	this.Text("IH.Wanted.Heat", " | 수배도: ");
    this.Text("IH.Wanted.PercentSuffix", "%");
    this.Text("IH.Wanted.Evading", " | 도주: ");
    this.Text("IH.Wanted.Clearing", " | 해제: ");
    this.Text("IH.Wanted.SecSuffix", "초");

    // ============================================
    // DRUG DEALER
    // ============================================
    this.Text("IH.DrugDealer.showRank.Name", "Drug Dealer: 등급 표시");
    this.Text("IH.DrugDealer.showRank.Desc", "현재 범죄 제국 등급을 HUD에 표시합니다.");
    this.Text("IH.DrugDealer.showTerror.Name", "Drug Dealer: 공포 표시");
    this.Text("IH.DrugDealer.showTerror.Desc", "구역 공포 수치를 백분율로 표시합니다. 활성 상태일 때만 보입니다.");
    this.Text("IH.DrugDealer.ddRankOrder.Name", "순서: Drug Dealer 등급");
    this.Text("IH.DrugDealer.ddTerrorOrder.Name", "순서: Drug Dealer 공포");
    this.Text("IH.DrugDealer.defaultRank", "말단 약팔이");

    // ============================================
    // EWH
    // ============================================
    this.Text("IH.EWH.showWidget.Name", "EWH: 무기 노출도 표시");
    this.Text("IH.EWH.showWidget.Desc", "Environmental Weapon Handling의 노출도 백분율을 표시합니다.");
    this.Text("IH.EWH.ewhOrder.Name", "순서: 무기 노출도(EWH)");

    // ============================================
    // SYNTHDOSE
    // ============================================
    this.Text("IH.SynthDose.replaceBar.Name", "SynthDose: 독성");
    this.Text("IH.SynthDose.replaceBar.Desc", "SynthDose 독성 수치를 표시합니다.");
	this.Text("IH.SynthDose.HideZeroName", "SynthDose: 0%일 때 숨기기");
	this.Text("IH.SynthDose.HideZeroDesc", "활성화하면 독성이 0%일 때 트래커가 완전히 사라집니다. 비활성화하면 계속 표시됩니다.");
    this.Text("IH.SynthDose.toxicityOrder.Name", "순서: 독성(SynthDose)");

    // ============================================
    // WANNABE EDGERUNNER (WE)
    // ============================================
    this.Text("IH.WE.replaceBar.Name", "Wannabe Edgerunner: 바 대체");
    this.Text("IH.WE.replaceBar.Desc", "인간성 바를 숨기고 깔끔한 위젯으로 대신 표시합니다.");
    this.Text("IH.WE.humanityOrder.Name", "순서: 인간성(WE)");

    // ============================================
    // CHROME PLATING
    // ============================================
    this.Text("IH.ChromePlating.showWornArmor.Name", "Chrome Plating: 마모 방어구");
    this.Text("IH.ChromePlating.showWornArmor.Desc", "Chrome Plating의 마모 방어구 %를 여기에 표시합니다. 켜면 중복 표시를 막기 위해 Chrome Plating의 자체 HUD 위젯이 숨겨집니다.");
    this.Text("IH.ChromePlating.hideWornArmorZero.Name", "마모 방어구 0%일 때 숨기기");
    this.Text("IH.ChromePlating.hideWornArmorZero.Desc", "활성화하면 마모 방어구 수치가 0%가 되었을 때 완전히 사라집니다. 비활성화하면 계속 표시되며 빨간색으로 바뀝니다.");
    this.Text("IH.ChromePlating.wornArmorOrder.Name", "순서: 마모 방어구");
	
	// ============================================
    // OXYGEN
    // ============================================
    this.Text("IH.Oxygen.showOxygen.Name", "산소 표시");
    this.Text("IH.Oxygen.showOxygen.Desc", "수영 중 산소 백분율을 동적으로 표시합니다.");
    this.Text("IH.Oxygen.oxygenOrder.Name", "순서: 산소");

    // ============================================
    // FPS TRACKER
    // ============================================
    this.Text("IH.FPS.showFPS.Name", "FPS 표시");
    this.Text("IH.FPS.showFPS.Desc", "실시간 초당 프레임 수 카운터를 표시합니다.");
    this.Text("IH.FPS.fpsMode.Name", "FPS 표시 모드");
    this.Text("IH.FPS.fpsMode.Desc", "표준: 0.5초 평균. 프레임 시간: ms 지연 표시 추가. 스터터 트래커: 1% 하위값/최소값 표시.");
	this.Text("IH.FPS.UseFrameGen.Name", "프레임 생성");
    this.Text("IH.FPS.UseFrameGen.Desc", "DLSS/FSR로 생성한 프레임을 FPS 계산에 포함합니다. 끄면 엔진이 실제 렌더링한 프레임(raw FPS)만 측정합니다. 게임에서 해당 측정 데이터를 제공해야 합니다.");

	// FPS Dropdown Values
    this.Text("IH.FPS.fpsMode.Standard", "표준");
    this.Text("IH.FPS.fpsMode.FrameTime", "프레임 시간");
    this.Text("IH.FPS.fpsMode.StutterTracker", "스터터 트래커");
    this.Text("IH.FPS.fpsOrder.Name", "순서: FPS 트래커");
	// FPS In-Widget Text
    this.Text("IH.FPS.Suffix.FPS", " FPS");
    this.Text("IH.FPS.Suffix.ms", "ms");
    this.Text("IH.FPS.Prefix.Min", "(최소: ");

    // ============================================
    // 1ST NIGHT CITY BANK
    // ============================================
    this.Text("IH.FNCB.showWidget.Name", "1st NC Bank: 트래커 표시");
    this.Text("IH.FNCB.showWidget.Desc", "1st Night City Bank 잔액과 활성 대출 부채를 표시합니다.");
    this.Text("IH.FNCB.displayMode.Name", "1st NC Bank: 표시 모드");
    this.Text("IH.FNCB.displayMode.Desc", "은행 & 부채: 잔액과 대출을 표시합니다. 부채만: 부채가 없으면 숨깁니다. 순자산: 지갑+은행-부채. 일일 납부액: 오늘 납부액을 표시합니다.");
    this.Text("IH.FNCB.fncbOrder.Name", "순서: 1st NC Bank 트래커");
	// Bank Dropdown Values
    this.Text("IH.FNCB.displayMode.BankAndDebt", "은행 & 부채");
    this.Text("IH.FNCB.displayMode.DebtOnly", "부채만");
    this.Text("IH.FNCB.displayMode.NetWorth", "순자산");
    this.Text("IH.FNCB.displayMode.DailyDue", "일일 납부액");
	// Bank In-Widget Text (Prefixes/Suffixes)
    this.Text("IH.FNCB.Prefix.NW", "순자산:");
    this.Text("IH.FNCB.Prefix.Debt", "부채:");
    this.Text("IH.FNCB.Prefix.Due", "납부:");
    this.Text("IH.FNCB.Prefix.PastDue", "연체:");
    this.Text("IH.FNCB.Suffix.Days", "일");
	
	// ============================================
    // MARMUR BANK (Legacy)
    // ============================================
    this.Text("IH.MARMUR.showWidget.Name", "Marmur Bank: 트래커 표시");
    this.Text("IH.MARMUR.showWidget.Desc", "HUD에 은행 잔액, 부채 또는 순자산을 표시합니다.");
    this.Text("IH.MARMUR.displayMode.Name", "표시 모드");
    this.Text("IH.MARMUR.displayMode.Desc", "트래커에 표시할 정보를 선택합니다.");
    this.Text("IH.MARMUR.displayMode.BankAndDebt", "잔액 및 부채");
    this.Text("IH.MARMUR.displayMode.DebtOnly", "부채만");
    this.Text("IH.MARMUR.displayMode.NetWorth", "순자산 (은행 + 소지금 - 부채)");
    this.Text("IH.MARMUR.displayMode.InstallmentDue", "잔액 및 다음 상환액");
    this.Text("IH.MARMUR.order.Name", "순서: Marmur Bank 트래커");
    
    // ============================================
    // NIGHT CITY BANK (New Version 0.3+)
    // ============================================
    this.Text("IH.NCB.showWidget.Name", "Night City Bank: 트래커 표시");
    this.Text("IH.NCB.showWidget.Desc", "은행 잔액, 수익률 및 재정 진행 상황을 HUD에 표시합니다.");
    this.Text("IH.NCB.displayMode.Name", "표시 모드");
    this.Text("IH.NCB.displayMode.Desc", "잔액과 함께 표시할 재정 지표를 선택합니다.");
    this.Text("IH.NCB.displayMode.BankOnly", "잔액만");
    this.Text("IH.NCB.displayMode.NetWorth", "순자산 (은행 + 소지금)");
    this.Text("IH.NCB.displayMode.BankAndYield", "잔액 및 일일 수익률");
    this.Text("IH.NCB.displayMode.TotalInterest", "잔액 및 누적 수익");
    this.Text("IH.NCB.displayMode.TotalTax", "잔액 및 누적 납부 세금");
    this.Text("IH.NCB.displayMode.PremiumProgress", "잔액 및 레드 카드 진행도");
    this.Text("IH.NCB.order.Name", "순서: Night City Bank 트래커");

    // --- In-Game Text Prefixes for NCB ---
    this.Text("IH.NCB.Prefix.Profit", "수익: €$ ");
    this.Text("IH.NCB.Prefix.Tax", "세금: €$ ");

    // ============================================
    // COURIER TIMER
    // ============================================
    this.Text("IH.Courier.showTimer.Name", "배달 타이머 표시");
    this.Text("IH.Courier.showTimer.Desc", "차량 배달 임무 중 카운트다운 타이머를 표시합니다. 미니맵 없는 설정에 적합합니다.");
    this.Text("IH.Courier.timerOrder.Name", "순서: 배달 타이머");
	
	// ============================================
    // FILTHY ACCESS POINTS (FAP)
    // ============================================
    this.Text("IH.FAP.showWidget.Name", "FAP: 무결성 표시");
    this.Text("IH.FAP.showWidget.Desc", "Filthy Access Points 모드의 개인 링크 무결성을 표시합니다.");
    this.Text("IH.FAP.hideFull.Name", "무결성 100%일 때 숨기기");
    this.Text("IH.FAP.hideFull.Desc", "활성화하면 무결성이 100%일 때 스탯이 완전히 사라집니다.");
    this.Text("IH.FAP.fapOrder.Name", "순서: 무결성(FAP)");
	
	// ============================================
    // CALENDAR
    // ============================================
    this.Text("IH.Calendar.showWidget.Name", "Calendar: 날짜 표시");
    this.Text("IH.Calendar.showWidget.Desc", "현재 게임 내 날짜를 표시합니다. 'Calendar' 모드가 필요합니다.");
    this.Text("IH.Calendar.format.Name", "날짜 형식");
    this.Text("IH.Calendar.format.Desc", "날짜 표시 방식을 선택합니다.");
    this.Text("IH.Calendar.format.Short", "짧게 (Sat, 10 Apr 2077)");
    this.Text("IH.Calendar.format.Long", "길게 (Saturday, April 10, 2077)");
    this.Text("IH.Calendar.format.ISO", "ISO (2077-04-10)");
    this.Text("IH.Calendar.format.European", "유럽식 (10.04.2077)");
    this.Text("IH.Calendar.format.American", "미국식 (Apr 10, 2077)");
    this.Text("IH.Calendar.calendarOrder.Name", "순서: 달력");
	
	// ============================================
    // FLUSHING ETIQUETTE (FE)
    // ============================================
    this.Text("IH.FE.showBowel.Name", "Flushing Etiquette: 장 압력 표시");
    this.Text("IH.FE.showBowel.Desc", "장 압력을 간결한 백분율 위젯으로 표시합니다.");
    this.Text("IH.FE.hideBowelSafe.Name", "안전한 장 압력일 때 숨기기");
    this.Text("IH.FE.hideBowelSafe.Desc", "활성화하면 압력이 모드의 경고 임계값보다 낮을 때 위젯이 완전히 숨겨집니다.");
    
    this.Text("IH.FE.showHygiene.Name", "Flushing Etiquette: 위생 표시");
    this.Text("IH.FE.showHygiene.Desc", "위생 수준을 간결한 백분율 위젯으로 표시합니다.");
    this.Text("IH.FE.hideHygieneSafe.Name", "청결할 때 위생 숨기기");
    this.Text("IH.FE.hideHygieneSafe.Desc", "활성화하면 위생 수치가 모드의 경고 임계값보다 높을 때 위젯이 완전히 숨겨집니다.");
    
    this.Text("IH.FE.bowelOrder.Name", "순서: 장 압력(FE)");
    this.Text("IH.FE.hygieneOrder.Name", "순서: 위생(FE)");	
	
	// ============================================
    // ARMOR UP
    // ============================================
    this.Text("IH.ArmorUp.showShield.Name", "Armor Up: 실드 포인트 표시");
    this.Text("IH.ArmorUp.showShield.Desc", "현재 실드 포인트를 간결한 백분율 위젯으로 표시하고 Armor Up 모드의 기본 체력 바 UI를 숨깁니다.");
    this.Text("IH.ArmorUp.showUI.Name", "Armor Up: 기본 UI 표시");
    this.Text("IH.ArmorUp.showUI.Desc", "Armor Up 모드가 체력 바에 추가한 기본 실드 바와 오버실드 텍스트를 표시합니다.");
    this.Text("IH.ArmorUp.shieldOrder.Name", "순서: 실드 포인트(Armor Up)");
	
	// ============================================
    // TRUE NIGHT VISION
    // ============================================
    this.Text("IH.TNV.showBattery.Name", "True Night Vision: 배터리 표시");
    this.Text("IH.TNV.showBattery.Desc", "나이트 비전 배터리 잔량을 표시합니다.");
    this.Text("IH.TNV.hideNativeBar.Name", "기본 배터리 바 숨기기");
    this.Text("IH.TNV.hideNativeBar.Desc", "Informative Healthbar 위젯을 사용할 때 True Night Vision의 기본 배터리 바를 숨깁니다.");
    this.Text("IH.TNV.batteryOrder.Name", "순서: 나이트 비전 배터리(True Night Vision)");
	
	// ============================================
    // TRUE FLASHLIGHT
    // ============================================
    this.Text("IH.TF.showBattery.Name", "True Flashlight: 배터리 표시");
    this.Text("IH.TF.showBattery.Desc", "손전등 배터리 잔량을 표시합니다.");
    this.Text("IH.TF.hideFull.Name", "배터리 완충 시 숨기기");
    this.Text("IH.TF.hideFull.Desc", "손전등 배터리가 완전히 충전되어 있으면 위젯을 숨깁니다.");
    this.Text("IH.TF.batteryOrder.Name", "순서: 손전등 배터리(True Flashlight)");
	
	// ============================================
    // DARK FUTURE 
    // ============================================
    this.Text("IH.DF.showHydration.Name", "Dark Future: 수분 표시");
    this.Text("IH.DF.showHydration.Desc", "현재 수분 수치를 간결한 백분율 위젯으로 표시합니다.");
    this.Text("IH.DF.showNutrition.Name", "Dark Future: 영양 표시");
    this.Text("IH.DF.showNutrition.Desc", "현재 영양 수치를 간결한 백분율 위젯으로 표시합니다.");
    this.Text("IH.DF.showEnergy.Name", "Dark Future: 에너지 표시");
    this.Text("IH.DF.showEnergy.Desc", "현재 에너지 수치를 간결한 백분율 위젯으로 표시합니다.");
    this.Text("IH.DF.showNerve.Name", "Dark Future: 정신력 표시");
    this.Text("IH.DF.showNerve.Desc", "현재 정신력 수치를 간결한 백분율 위젯으로 표시합니다.");
    
    this.Text("IH.DF.hydrationOrder.Name", "순서: 수분(Dark Future)");
    this.Text("IH.DF.nutritionOrder.Name", "순서: 영양(Dark Future)");
    this.Text("IH.DF.energyOrder.Name", "순서: 에너지(Dark Future)");
    this.Text("IH.DF.nerveOrder.Name", "순서: 정신력(Dark Future)");
	
	// ============================================
    // SHATTERED CHROME
    // ============================================
    this.Text("IH.SC.showIntegrity.Name", "Shattered Chrome: 무결성 표시");
    this.Text("IH.SC.showIntegrity.Desc", "사이버웨어의 평균 무결성과 파손된 임플란트 수를 표시합니다.");
	this.Text("IH.SC.hideFull.Name", "무결성 100%일 때 숨기기");
    this.Text("IH.SC.hideFull.Desc", "모든 사이버웨어의 무결성이 100%이고 파손된 임플란트가 없으면 위젯을 숨깁니다.");
    this.Text("IH.SC.scOrder.Name", "순서: 무결성(Shattered Chrome)");
	
	// ============================================
    // CONSCIENCE
    // ============================================
    this.Text("IH.CNS.showWidget.Name", "Conscience: 트래커 표시");
    this.Text("IH.CNS.showWidget.Desc", "현재 죄책감 수준을 간단한 백분율 위젯으로 표시합니다. (참고: Conscience 모드 설정에서 자체 HUD를 꺼 주세요.)");
    this.Text("IH.CNS.displayMode.Name", "Conscience: 표시 기준 단계");
    this.Text("IH.CNS.displayMode.Desc", "위젯을 표시하기 시작할 죄책감 단계를 선택합니다.");
    this.Text("IH.CNS.displayMode.Always", "항상 (0% 초과 시)");
    this.Text("IH.CNS.displayMode.Tier1", "1단계부터 (환영)");
    this.Text("IH.CNS.displayMode.Tier2", "2단계부터 (긴장)");
    this.Text("IH.CNS.displayMode.Tier3", "3단계부터 (위기)");
    this.Text("IH.CNS.displayMode.Tier4", "4단계부터 (공황)");
    this.Text("IH.CNS.order.Name", "순서: Conscience (죄책감)");
	
	
  }
}
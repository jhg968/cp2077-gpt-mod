module MinimapWidgets.Translations

import Codeware.Localization.*

public class MinimapWidgets_Korean extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {

    this.Text("MinimapWidgets.Mod.Name", "미니맵 위젯");
    this.Text("MinimapWidgets.Mod.Desc", "미니맵 주변에 정보를 표시하는 위젯입니다.");

    // --- TABS ---
    this.Text("MW.tab.Minimap", "미니맵");
    this.Text("MW.tab.World", "월드");
    this.Text("MW.tab.TimeDate", "시간 및 날짜");
    this.Text("MW.tab.Location", "위치");
    this.Text("MW.tab.Stats", "통계");

    // --- SECTIONS ---
    this.Text("MW.section.MinimapSettings", "미니맵 설정");
    this.Text("MW.section.Markers", "마커");
    this.Text("MW.section.Behavior", "동작");

    this.Text("MW.section.TextCompass", "문자 나침반");
    this.Text("MW.section.CircleCompass", "원형 나침반");
    this.Text("MW.section.Weather", "날씨 위젯");
    
    this.Text("MW.section.Time", "게임 시간 위젯");
    this.Text("MW.section.RealTime", "실제 시간 위젯");
    this.Text("MW.section.Calendar", "달력 위젯");
    
    this.Text("MW.section.District", "지역 위젯");
    this.Text("MW.section.Gang", "갱단 위젯");
    this.Text("MW.section.Fixer", "픽서 위젯");
    this.Text("MW.section.Street", "도로 위젯");
    this.Text("MW.section.Coord", "좌표 위젯");
    
    this.Text("MW.section.FPS", "FPS 위젯");
    this.Text("MW.section.Kills", "처치 수 위젯");
    this.Text("MW.section.Money", "소지금 위젯");

    // --- GROUPS ---
    this.Text("MW.group.General", "일반");
    this.Text("MW.group.Appearance", "외형");
    this.Text("MW.group.Background", "배경");
    this.Text("MW.group.Border", "테두리");
    this.Text("MW.group.Player", "플레이어 아이콘");
    this.Text("MW.group.Roads", "도로");
    this.Text("MW.group.Other", "기타");
    this.Text("MW.group.Behavior", "동작");

    // --- COMMON ---
    this.Text("MW.Common.Position", "위치");
    this.Text("MW.Common.PositionTip", "미니맵 주변에서 표시할 위치를 선택합니다.");
    this.Text("MW.Common.FontSize", "글자 크기");
    this.Text("MW.Common.FontSizeTip", "글자 크기를 설정합니다. 크기가 너무 크면 위젯 위치가 어긋나거나 잘릴 수 있습니다.");
    this.Text("MW.Common.FontStyle", "글꼴 스타일");
    this.Text("MW.Common.FontStyleTip", "위젯의 글꼴 스타일을 선택합니다.");
    this.Text("MW.Common.Color", "색상");
    this.Text("MW.Common.ColorTip", "위젯에 사용할 기본 색상을 선택합니다.");
    this.Text("MW.Common.Opacity", "불투명도");
    this.Text("MW.Common.OpacityTip", "위젯의 불투명도를 설정합니다.");
    this.Text("MW.Common.LetterCase", "대소문자");
    this.Text("MW.Common.LetterCaseTip", "위젯의 대소문자 표시 방식을 선택합니다.");

    // --- POSITIONS ---
    this.Text("MW.pos.AboveLeft", "바깥 위쪽 왼쪽");
    this.Text("MW.pos.AboveCenter", "바깥 위쪽 가운데");
    this.Text("MW.pos.AboveRight", "바깥 위쪽 오른쪽");
    this.Text("MW.pos.TopLeft", "상단 왼쪽");
    this.Text("MW.pos.TopCenter", "상단 가운데");
    this.Text("MW.pos.TopRight", "상단 오른쪽");
    this.Text("MW.pos.BottomLeft", "하단 왼쪽");
    this.Text("MW.pos.BottomCenter", "하단 가운데");
    this.Text("MW.pos.BottomRight", "하단 오른쪽");
    this.Text("MW.pos.BelowLeft", "바깥 아래쪽 왼쪽");
    this.Text("MW.pos.BelowCenter", "바깥 아래쪽 가운데");
    this.Text("MW.pos.BelowRight", "바깥 아래쪽 오른쪽");
    this.Text("MW.pos.Default", "기본값");

    // --- FONTS ---
    this.Text("MW.font.Regular", "보통");
    this.Text("MW.font.Medium", "중간");
    this.Text("MW.font.SemiBold", "세미볼드");
    this.Text("MW.font.Bold", "볼드");

    // --- COLORS ---
    this.Text("MW.color.Blue", "파랑");
    this.Text("MW.color.Red", "빨강");
    this.Text("MW.color.Yellow", "노랑");
    this.Text("MW.color.Green", "초록");
    this.Text("MW.color.White", "흰색");
    this.Text("MW.color.Orange", "주황");
    this.Text("MW.color.Purple", "보라");
    this.Text("MW.color.MildBlue", "연한 파랑");
    this.Text("MW.color.ActiveBlue", "밝은 파랑");
    this.Text("MW.color.MildRed", "연한 빨강");
    this.Text("MW.color.ActiveRed", "밝은 빨강");
    this.Text("MW.color.ActiveYellow", "밝은 노랑");
    this.Text("MW.color.ActiveGreen", "밝은 초록");
    this.Text("MW.color.ActiveWhite", "밝은 흰색");
    this.Text("MW.color.MildOrange", "연한 주황");
    this.Text("MW.color.DarkGold", "짙은 금색");
    this.Text("MW.color.CombatRed", "전투 빨강");
    this.Text("MW.color.StreetCred", "평판 색상");
    this.Text("MW.color.Cyberspace", "사이버스페이스");
    this.Text("MW.color.FastTravel", "빠른 이동 색상");
    this.Text("MW.color.Black", "검정");
    this.Text("MW.color.Default", "기본값");

    // --- LETTER CASE ---
    this.Text("MW.case.Upper", "대문자");
    this.Text("MW.case.Original", "원본 유지");

    // --- MINIMAP TAB ---
    this.Text("MW.Minimap.BackgroundColor", "배경 색상");
    this.Text("MW.Minimap.BackgroundColorTip", "미니맵 배경에 사용할 기본 색상을 선택합니다.");
    this.Text("MW.Minimap.BackgroundOpacityTip", "미니맵 배경의 불투명도를 설정합니다.");
    
    this.Text("MW.Minimap.BorderColor", "테두리 색상");
    this.Text("MW.Minimap.BorderColorTip", "미니맵 테두리에 사용할 기본 색상을 선택합니다.");
    this.Text("MW.Minimap.BorderOpacityTip", "미니맵 테두리의 불투명도를 설정합니다.");
    
    this.Text("MW.Minimap.PlayerColor", "플레이어 아이콘 색상");
    this.Text("MW.Minimap.PlayerColorTip", "미니맵 플레이어 아이콘에 사용할 기본 색상을 선택합니다.");
    this.Text("MW.Minimap.PlayerOpacityTip", "미니맵 플레이어 아이콘의 불투명도를 설정합니다.");
    
    this.Text("MW.Minimap.RoadsColor", "도로 색상");
    this.Text("MW.Minimap.RoadsColorTip", "미니맵 도로에 사용할 기본 색상을 선택합니다.");
    this.Text("MW.Minimap.RoadsOpacityTip", "미니맵 도로의 불투명도를 설정합니다.");
    
    this.Text("MW.Minimap.StarColor", "수배 별 색상");
    this.Text("MW.Minimap.StarColorTip", "수배 별에 사용할 기본 색상을 선택합니다.");
    
    this.Text("MW.Minimap.GPSOpacity", "GPS 경로 불투명도");
    this.Text("MW.Minimap.GPSOpacityTip", "GPS 경로의 불투명도를 설정합니다.");
    
    this.Text("MW.Minimap.MarkersOpacity", "마커 불투명도");
    this.Text("MW.Minimap.MarkersOpacityTip", "모든 마커의 불투명도를 설정합니다.");
    
    this.Text("MW.Minimap.ClampOpacity", "가장자리 마커 불투명도");
    this.Text("MW.Minimap.ClampOpacityTip", "미니맵 가장자리에 고정되는 마커의 불투명도를 설정합니다.");
    
    this.Text("MW.Minimap.ZoneSize", "구역 표시 글자 크기");
    this.Text("MW.Minimap.ZoneSizeTip", "보안 구역과 전투 상태 표시의 글자 크기를 설정합니다.");

    // --- BEHAVIOR ---
    this.Text("MW.Behavior.Vehicle", "차량 모드 (도보 시 숨기기)");
    this.Text("MW.Behavior.VehicleTip", "운전 중에는 미니맵을 표시하고 도보 이동 중에는 숨깁니다.");
    
    this.Text("MW.Behavior.Visuals", "장식 요소 (weapon_name, bg_dots)");
    this.Text("MW.Behavior.VisualsTip", "weapon_name과 bg_dots 같은 장식 요소를 표시하거나 숨깁니다.");
    
    this.Text("MW.Behavior.CombatPulse", "전투 상태 맥동 효과");
    this.Text("MW.Behavior.CombatPulseTip", "전투 상태의 맥동 효과를 표시하거나 숨깁니다.");
    
    this.Text("MW.Behavior.DrivePulse", "자동 운전 맥동 효과");
    this.Text("MW.Behavior.DrivePulseTip", "자동 운전 상태의 맥동 효과를 표시하거나 숨깁니다.");
    
    this.Text("MW.Behavior.ToggleMinimapKey", "미니맵 전환 단축키");
    this.Text("MW.Behavior.ToggleMinimapKeyTip", "미니맵과 수배 HUD를 표시하거나 숨기는 단축키입니다.");

    // --- MARKERS ---
    this.Text("MW.Markers.Enemies", "적 표시");
    this.Text("MW.Markers.EnemiesTip", "미니맵에 적을 표시하거나 숨깁니다.");
    
    this.Text("MW.Markers.EnemiesOnlyTagged", "태그한 적만 표시");
    this.Text("MW.Markers.EnemiesOnlyTaggedTip", "태그한 적만 미니맵에 표시합니다.");
    
    this.Text("MW.Markers.NCPD", "NCPD 표시");
    this.Text("MW.Markers.NCPDTip", "NCPD 경찰과 차량을 표시하거나 숨깁니다.");

    this.Text("MW.Markers.NCPDOnlyTagged", "태그한 NCPD만 표시");
    this.Text("MW.Markers.NCPDOnlyTaggedTip", "태그한 NCPD 경찰과 차량만 미니맵에 표시합니다.");
    
    this.Text("MW.Markers.Loot", "전리품 표시");
    this.Text("MW.Markers.LootTip", "떨어진 전리품을 표시하거나 숨깁니다.");
    
    this.Text("MW.Markers.Devices", "장치 표시");
    this.Text("MW.Markers.DevicesTip", "카메라나 포탑 같은 장치를 표시하거나 숨깁니다.");
    
    this.Text("MW.Markers.Vendor", "상인 표시");
    this.Text("MW.Markers.VendorTip", "상인과 판매 단말기를 표시하거나 숨깁니다.");
    
    this.Text("MW.Markers.VCar", "플레이어 차량 표시");
    this.Text("MW.Markers.VCarTip", "플레이어의 차량을 표시하거나 숨깁니다.");
    
    this.Text("MW.Markers.Travel", "빠른 이동 표시");
    this.Text("MW.Markers.TravelTip", "빠른 이동 지점과 지하철역을 표시하거나 숨깁니다.");
    
    this.Text("MW.Markers.Mappins", "추가 지도 핀 표시");
    this.Text("MW.Markers.MappinsTip", "기본 지도 핀을 더 일찍 표시하고 퀘스트, 의뢰, NCPD 스캐너 핀을 추가합니다.");
    
    this.Text("MW.Markers.ElevationArrow", "높낮이 화살표 표시");
    this.Text("MW.Markers.ElevationArrowTip", "지도 핀의 기본 높낮이 화살표를 표시하거나 숨깁니다.");

    // --- WORLD TAB ---
    this.Text("MW.TextCompass.Enabled", "활성화");
    this.Text("MW.TextCompass.EnabledTip", "문자 나침반 위젯을 켜거나 끕니다.");

    this.Text("MW.CircleCompass.Enabled", "활성화");
    this.Text("MW.CircleCompass.EnabledTip", "켜짐: 원형 나침반 변경 사항을 표시합니다.\n꺼짐: 변경 사항을 숨기고 기본 상태로 복원합니다.");
    this.Text("MW.CircleCompass.Visible", "나침반 원 표시");
    this.Text("MW.CircleCompass.VisibleTip", "나침반 바깥쪽 원을 표시하거나 숨깁니다.");
    this.Text("MW.CircleCompass.NorthSize", "북쪽 화살표 전체 크기");
    this.Text("MW.CircleCompass.NorthSizeTip", "꺼짐: 기본 크기의 표시를 사용합니다.\n켜짐: 전체 크기의 표시를 사용합니다.");
    this.Text("MW.CircleCompass.PositionTip", "원형 나침반의 위치를 선택합니다.");

    this.Text("MW.Weather.Enabled", "활성화");
    this.Text("MW.Weather.EnabledTip", "날씨 위젯을 켜거나 끕니다.");
    
    this.Text("MW.Weather.ClearNight", "맑은 밤");
    this.Text("MW.Weather.Sunny", "맑음");
    this.Text("MW.Weather.Rain", "비");
    this.Text("MW.Weather.LightRain", "약한 비");
    this.Text("MW.Weather.Cloudy", "흐림");
    this.Text("MW.Weather.HeavyClouds", "짙은 구름");
    this.Text("MW.Weather.LightClouds", "옅은 구름");
    this.Text("MW.Weather.Fog", "안개");
    this.Text("MW.Weather.Pollution", "대기 오염");
    this.Text("MW.Weather.Sandstorm", "모래 폭풍");
    this.Text("MW.Weather.ToxicRain", "유독성 비");
    this.Text("MW.Weather.DeepBlue", "짙푸른 하늘");
    this.Text("MW.Weather.SquatMorning", "스쿼트 아침");
    this.Text("MW.Weather.CloudyMorning", "흐린 아침");
    this.Text("MW.Weather.RainyNight", "비 오는 밤");
    this.Text("MW.Weather.CourierClouds", "배송 임무 구름");
    this.Text("MW.Weather.NoData", "정보 없음");
	
    this.Text("MW.Weather.Nova.FogWet", "안개와 보슬비");
    this.Text("MW.Weather.Nova.HazePollution", "연무와 스모그");
    this.Text("MW.Weather.Nova.HeavyFog", "짙은 안개");
    this.Text("MW.Weather.Nova.SunnyWindy", "맑고 바람 부는 날씨");
    this.Text("MW.Weather.Nova.RainAlt1", "비와 구름");
    this.Text("MW.Weather.Nova.RainAlt2", "폭우");
    this.Text("MW.Weather.Nova.DrizzleLight", "약한 이슬비");
    this.Text("MW.Weather.Nova.Sunset", "일몰");
    this.Text("MW.Weather.Nova.OvercastLight", "옅게 흐림");
    this.Text("MW.Weather.Nova.DistantRain", "먼 곳에 내리는 비");
    this.Text("MW.Weather.Nova.DrizzleHeavy", "강한 이슬비");
    this.Text("MW.Weather.Nova.FogRain", "안개와 비");
    this.Text("MW.Weather.Nova.HazeHeavy", "짙은 연무");
    this.Text("MW.Weather.Nova.HeavyDense", "빽빽한 구름");
    this.Text("MW.Weather.Nova.FogDense", "매우 짙은 안개");
    this.Text("MW.Weather.Nova.HighClouds", "구름 많음");
    this.Text("MW.Weather.Nova.HazeRain", "연무와 비");
    this.Text("MW.Weather.Nova.Arid", "메마름");
    this.Text("MW.Weather.Nova.Muggy", "후텁지근함");
    this.Text("MW.Weather.Nova.HazeSmog", "탁한 스모그");
    this.Text("MW.Weather.Nova.FogHaze", "탁한 안개");
    this.Text("MW.Weather.Nova.Softbox", "잿빛 비구름");
    this.Text("MW.Weather.Nova.SoftboxClear", "잿빛 하늘");
    this.Text("MW.Weather.Nova.MemeClouds", "밈 구름");
    this.Text("MW.Weather.Nova.Gloomy", "음산함");
	this.Text("MW.Weather.Nova.Haze", "연무");
	this.Text("MW.Weather.Nova.Smog", "스모그");
	this.Text("MW.Weather.Nova.Windy", "바람");
	this.Text("MW.Weather.Nova.Dew", "이슬");
	this.Text("MW.Weather.Nova.Drizzle", "이슬비");
	this.Text("MW.Weather.Nova.Mist", "옅은 안개");
	this.Text("MW.Weather.Nova.Overcast", "흐림");
    this.Text("MW.Weather.Nova.OvercastBroken", "군데군데 갠 흐린 하늘");
	this.Text("MW.Weather.Nova.Downpour", "장대비");
	this.Text("MW.Weather.Nova.Storm", "폭풍우");
	this.Text("MW.Weather.Nova.Drought", "가뭄");
	this.Text("MW.Weather.Nova.Humid", "습함");
	this.Text("MW.Weather.Nova.Blackout", "암흑");
    this.Text("MW.Weather.Nova.SunnyE3", "E3 맑음");
    this.Text("MW.Weather.Nova.RainQAlt", "비 - 대체");
    this.Text("MW.Weather.Nova.RainWIP", "비 - 개발 중");
    this.Text("MW.Weather.Nova.FogDarkDense", "짙고 어두운 안개");
	
    this.Text("MW.Coord.Enabled", "활성화");
    this.Text("MW.Coord.EnabledTip", "좌표 위젯을 켜거나 끕니다.");
    this.Text("MW.Coord.Decimal", "좌표 소수 자릿수");
    this.Text("MW.Coord.DecimalTip", "좌표 위젯의 정확도와 소수 자릿수를 설정합니다.");
    this.Text("MW.Coord.Interval", "좌표 갱신 주기");
    this.Text("MW.Coord.IntervalTip", "갱신 주기를 초 단위로 설정합니다. 값이 낮으면 성능에 영향을 줄 수 있습니다.");

    // --- TIME TAB ---
    this.Text("MW.Time.Enabled", "활성화");
    this.Text("MW.Time.EnabledTip", "게임 시간 위젯을 켜거나 끕니다.");
    this.Text("MW.Time.Format", "시간 표시 형식");
    this.Text("MW.Time.FormatTip", "24시간제와 12시간제 중 선택합니다.");
    this.Text("MW.Time.Format24", "24시간제 (08:00)");
    this.Text("MW.Time.Format12", "12시간제 (08:00 AM)");
    this.Text("MW.Time.Format24NoLead", "24시간제 (8:00)");
    this.Text("MW.Time.Format12NoLead", "12시간제 (8:00 AM)");
    this.Text("MW.Time.CalendarMod", "달력 (모드 필요)");
	this.Text("MW.Time.StoryDay", "경과 일수 표시");
    this.Text("MW.Time.StoryDayTip", "켜짐: 시계에 경과 일수를 덧붙입니다. Calendar 모드가 필요합니다.\n꺼짐: 선택한 형식으로 게임 시간만 표시합니다.");
	this.Text("MW.Time.StoryDaySeparatorTip", "시간과 경과 일수 사이에 넣을 구분자를 선택합니다.");

    this.Text("MW.RealTime.Enabled", "활성화");
    this.Text("MW.RealTime.EnabledTip", "실제 시간 위젯을 켜거나 끕니다. RedFunctions가 필요합니다.");
    this.Text("MW.RealTime.TimeFormat", "시간 형식");
    this.Text("MW.RealTime.TimeFormatTip", "실제 시간을 표시할 형식을 선택합니다.");
    this.Text("MW.RealTime.TimeFormatHidden", "숨기기");
    this.Text("MW.RealTime.TimeFormat12", "12시간제 (AM/PM)");
    this.Text("MW.RealTime.TimeFormat24", "24시간제");
    this.Text("MW.RealTime.DateFormat", "날짜 형식");
    this.Text("MW.RealTime.DateFormatTip", "실제 날짜를 표시할 형식을 선택합니다.");
    this.Text("MW.RealTime.DateFormatHidden", "숨기기");
    this.Text("MW.RealTime.DateFormatISO", "ISO (YYYY-MM-DD)");
    this.Text("MW.RealTime.DateFormatEU", "유럽식 (DD.MM.YY)");
    this.Text("MW.RealTime.DateFormatUS", "미국식 (MM/DD/YY)");
    this.Text("MW.RealTime.DateFormatDayEU", "유럽식 + 요일");
    this.Text("MW.RealTime.DateFormatDayUS", "미국식 + 요일");
    this.Text("MW.RealTime.Separator", "구분자");
    this.Text("MW.RealTime.SeparatorTip", "날짜와 시간 사이에 넣을 구분자를 선택합니다.");
	
	this.Text("MW.sep.Dash", "대시 (-)");
    this.Text("MW.sep.Pipe", "세로줄 (|)");
    this.Text("MW.sep.Bullet", "가운뎃점 (•)");
    this.Text("MW.sep.Comma", "쉼표 (,)");
    this.Text("MW.sep.Space", "공백 ( )");

    this.Text("MW.Calendar.Enabled", "활성화");
    this.Text("MW.Calendar.EnabledTip", "달력 위젯을 켜거나 끕니다.");
    this.Text("MW.Calendar.Format", "날짜 형식");
    this.Text("MW.Calendar.FormatTip", "날짜 표시 형식을 선택합니다.");
    this.Text("MW.cal.Short", "짧게 (Sat, 10 Apr 2077)");
    this.Text("MW.cal.Long", "길게 (Saturday, April 10, 2077)");
    this.Text("MW.cal.ISO", "ISO (2077-04-10)");
    this.Text("MW.cal.EU", "유럽식 (10.04.2077)");
    this.Text("MW.cal.US", "미국식 (Apr 10, 2077)");
    this.Text("MW.cal.Hidden", "숨기기");
    this.Text("MW.cal.DayToggle", "경과 일수 표시");
    this.Text("MW.cal.DayTip", "선택한 스토리 기준점 이후 경과한 일수를 표시합니다.");
    this.Text("MW.cal.Separator", "구분자");
    this.Text("MW.cal.SeparatorTip", "날짜와 경과 일수 사이에 넣을 구분자를 선택합니다.");
    this.Text("MW.cal.DayPrefix", "경과일");
	this.Text("MW.cal.StoryDayAnchor", "경과 일수 기준점");
    this.Text("MW.cal.StoryDayAnchorTip", "경과 일수를 계산하기 시작할 스토리 시점을 선택합니다.");
    this.Text("MW.cal.AnchorRescue", "구조");
    this.Text("MW.cal.AnchorHeist", "습격");
    this.Text("MW.cal.AnchorPlayingForTime", "2막 시작");
    this.Text("MW.cal.StoryDaySeparatorTip", "시간과 경과 일수 사이에 넣을 구분자를 선택합니다.");

    // --- LOCATION TAB ---
    this.Text("MW.District.Enabled", "활성화");
    this.Text("MW.District.EnabledTip", "지역 위젯을 켜거나 끕니다.");
    this.Text("MW.District.Info", "지역 정보");
    this.Text("MW.District.InfoTip", "표시할 정보 형식을 선택합니다.");
    this.Text("MW.district.Current", "현재 위치");
    this.Text("MW.district.Dash", "구역 - 하위 구역");
    this.Text("MW.district.Pipe", "구역 | 하위 구역");
    this.Text("MW.district.Bullet", "구역 • 하위 구역");
    this.Text("MW.district.DistrictOnly", "구역만");
    this.Text("MW.district.List", "목록");

    this.Text("MW.Gang.Enabled", "활성화");
    this.Text("MW.Gang.EnabledTip", "갱단 위젯을 켜거나 끕니다.");
    this.Text("MW.Gang.Info", "갱단 정보");
    this.Text("MW.Gang.InfoTip", "주변 갱단의 표시 방식을 선택합니다.");
    this.Text("MW.gang.List", "목록");
    this.Text("MW.gang.Dash", "갱단1 - 갱단2");
    this.Text("MW.gang.Pipe", "갱단1 | 갱단2");
    this.Text("MW.gang.Bullet", "갱단1 • 갱단2");

    this.Text("MW.Fixer.Enabled", "픽서 위젯 활성화");
    this.Text("MW.Fixer.EnabledTip", "픽서 위젯을 켜거나 끕니다.");

    this.Text("MW.Street.Enabled", "활성화");
    this.Text("MW.Street.EnabledTip", "도로 위젯을 켜거나 끕니다. StreetLogger가 필요합니다.");
    this.Text("MW.Street.Hide", "도로 밖에서 숨기기");
    this.Text("MW.Street.HideTip", "도로를 벗어나면 위젯을 숨깁니다.");
    this.Text("MW.Street.Format", "도로명 표시 형식");
    this.Text("MW.Street.FormatTip", "도로명 표시 형식을 선택합니다.");
    this.Text("MW.street.Full", "전체 이름");
    this.Text("MW.street.Short", "짧은 이름");
    this.Text("MW.street.CrossFull", "교차로 (전체)");
    this.Text("MW.street.CrossShort", "교차로 (짧게)");


    // --- STATS TAB ---
    this.Text("MW.FPS.Enabled", "활성화");
    this.Text("MW.FPS.EnabledTip", "FPS 위젯을 켜거나 끕니다.");
    this.Text("MW.FPS.TextShow", "FPS 접두사 표시");
    this.Text("MW.FPS.TextShowTip", "\"FPS:\" 접두사를 표시하거나 숨깁니다.");
    this.Text("MW.FPS.Color1", "FPS 접두사 색상");
    this.Text("MW.FPS.Color1Tip", "\"FPS:\" 텍스트의 색상을 선택합니다.");
    this.Text("MW.FPS.Color2", "FPS 수치 색상");
    this.Text("MW.FPS.Color2Tip", "FPS 수치의 색상을 선택합니다.");
    this.Text("MW.Widget.FPS.Prefix", "FPS: ");

    this.Text("MW.Kills.Enabled", "활성화");
    this.Text("MW.Kills.EnabledTip", "처치 수 위젯을 켜거나 끕니다.");
    this.Text("MW.Kills.TextShow", "처치 수 접두사 표시");
    this.Text("MW.Kills.TextShowTip", "\"KILLS:\" 접두사를 표시하거나 숨깁니다.");
    this.Text("MW.Kills.Color1", "처치 수 접두사 색상");
    this.Text("MW.Kills.Color1Tip", "\"KILLS:\" 텍스트의 색상을 선택합니다.");
    this.Text("MW.Kills.Color2", "처치 수 수치 색상");
    this.Text("MW.Kills.Color2Tip", "처치 수 수치의 색상을 선택합니다.");
    this.Text("MW.Widget.Kills.Prefix", "처치: ");

    this.Text("MW.Money.Enabled", "활성화");
    this.Text("MW.Money.EnabledTip", "소지금 위젯을 켜거나 끕니다.");
    this.Text("MW.Money.ShowSymbol", "€$ 기호 표시");
    this.Text("MW.Money.ShowSymbolTip", "통화 기호를 표시하거나 숨깁니다.");
    this.Text("MW.Money.SymbolPos", "통화 기호 위치");
    this.Text("MW.Money.SymbolPosTip", "기호를 금액 앞이나 뒤에 표시합니다.");
    this.Text("MW.money.Front", "앞");
    this.Text("MW.money.Back", "뒤");
    this.Text("MW.Money.Separator", "천 단위 구분자");
    this.Text("MW.Money.SeparatorTip", "큰 금액의 숫자 표시 형식을 선택합니다.");
    this.Text("MW.money.None", "없음");
    this.Text("MW.money.Period", "마침표 (.)");
    this.Text("MW.money.Comma", "쉼표 (,)");
    this.Text("MW.money.Space", "공백 ( )");

  }
}
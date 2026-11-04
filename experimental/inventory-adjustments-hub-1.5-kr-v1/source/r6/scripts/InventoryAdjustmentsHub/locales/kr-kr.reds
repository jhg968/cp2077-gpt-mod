module IAHub.Localization
import Codeware.Localization.*

public class Korean extends ModLocalizationPackage {
	protected func DefineTexts() -> Void {
		// Version 1.1
		this.Text("Gameplay-RPG-Stats-WeaponStats-SmartGunProjectileVelocity", "투사체 속도");
		this.Text("IAH-Stats-PhysicalImpulse", "물리 충격력");
		this.Text("IAH-Stats-MagazineAutoRefill", "탄창 자동 보충");
		this.Text("IAH-Stats-MagazineCapacityBonus", "탄창 용량");
		this.Text("IAH-Stats-ARSMGLMGMod3_SpreadPerShot", "비조준 사격 탄 퍼짐");
		this.Text("IAH-Stats-ARSMGLMGMod2_RecoilKickCover", "엄폐 조준 시 수직 반동 감소");
		this.Text("IAH-Stats-TechMod1_EMPChance", "완전 충전 공격 적중 시 EMP 폭발 확률");
		this.Text("IAH-Stats-SmartMod3_Zone", "스마트 타겟팅 조준선 확대");
		this.Text("IAH-Stats-SmartGunHipTimeToUnlock", "조준선 이탈 후 타겟 고정 유지 시간");
		this.Text("IAH-Stats-ShotgunMod1_DismemberBonus", "신체 절단 확률");
		this.Text("IAH-Stats-DurationBonusBleeding", "출혈 지속 시간");
		this.Text("IAH-Stats-BladeMod1_CritChance", "출혈로 인한 치명타 확률");

		this.Text("IAH-Menu-ModName",							"Inventory Adjustments Hub"); // DO NOT CHANGE

		this.Text("IAH-Menu-Category-Main",						"일반");
		this.Text("IAH-Menu-Category-Items",					"아이템");
		this.Text("IAH-Menu-Category-Weapons",					"무기");
		this.Text("IAH-Menu-Category-EffectIcons",				"효과 아이콘");
		this.Text("IAH-Menu-Category-Tooltips",					"툴팁");
		this.Text("IAH-Menu-Category-Compatibility",			"호환성");

		this.Text("IAH-Menu-Setting-Name-Global",				"IAHub 사용");
		this.Text("IAH-Menu-Setting-Desc-Global",				"모드의 모든 기능을 켜거나 끕니다.");

		this.Text("IAH-Menu-Setting-Name-Layout",				"배치 조정");
		this.Text("IAH-Menu-Setting-Desc-Layout",				"퀘스트·개조 부품·옷장 등의 표시 크기와 위치를 조정합니다. 빈 개조 부품 슬롯이 덜 두드러지게 표시됩니다.");

		this.Text("IAH-Menu-Setting-Name-Plus",					"아이템 등급의 + 표시");
		this.Text("IAH-Menu-Setting-Desc-Plus",					"모든 아이템에 등급의 + 표시를 추가합니다. 여러 표시 방식을 선택할 수 있습니다.");

		this.Text("IAH-Menu-Setting-Name-Craft",				"제작 화면의 신화 아이템 표시");
		this.Text("IAH-Menu-Setting-Desc-Craft",				"제작 메뉴에서 신화 아이템에 해당하는 배경을 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-TypeToName",			"무기 유형 대신 이름 표시");
		this.Text("IAH-Menu-Setting-Desc-TypeToName",			"무기 유형 문구를 해당 무기의 원래 이름으로 바꿉니다.");

		this.Text("IAH-Menu-Setting-Name-HideTypeIcon",			"무기 유형 아이콘 숨기기");
		this.Text("IAH-Menu-Setting-Desc-HideTypeIcon",			"무기 유형 문구 옆의 작은 유형 아이콘을 숨깁니다.");

		this.Text("IAH-Menu-Setting-Name-SmallType",			"무기 유형 문구 축소");
		this.Text("IAH-Menu-Setting-Desc-SmallType",			"무기 유형 문구의 크기를 줄입니다.");

		this.Text("IAH-Menu-Setting-Name-SmallAmmo",			"탄약 문구 축소");
		this.Text("IAH-Menu-Setting-Desc-SmallAmmo",			"탄약 문구의 크기를 줄입니다. 탄약 대신 표시하는 정보에도 적용됩니다.");

		this.Text("IAH-Menu-Setting-Name-AmmoReplacer",			"탄약 표시 대체");
		this.Text("IAH-Menu-Setting-Desc-AmmoReplacer",			"탄약 표시를 다른 유용한 정보로 바꿉니다.");

		this.Text("IAH-Menu-Setting-Name-TypeColorCommon",		"일반 무기 유형 색상");
		this.Text("IAH-Menu-Setting-Desc-TypeColorCommon",		"일반 무기의 유형 문구에 사용할 색상입니다.");

		this.Text("IAH-Menu-Setting-Name-TypeColorIconic",		"신화 무기 유형 색상");
		this.Text("IAH-Menu-Setting-Desc-TypeColorIconic",		"신화 무기의 유형 문구에 사용할 색상입니다.");

		this.Text("IAH-Menu-Setting-Name-AmmoColor",			"탄약 표시 색상");
		this.Text("IAH-Menu-Setting-Desc-AmmoColor",			"탄약 또는 이를 대체하는 정보에 사용할 색상입니다.");

		this.Text("IAH-Menu-Setting-Name-PartsColor",			"무기 부착물 색상");
		this.Text("IAH-Menu-Setting-Desc-PartsColor",			"무기 부착물 아이콘에 사용할 색상입니다.");

		this.Text("IAH-Menu-Setting-Name-WeaponsStatusEffects",	"무기: 상태 효과");
		this.Text("IAH-Menu-Setting-Desc-WeaponsStatusEffects",	"출혈·화상·기절 등의 상태 효과 아이콘을 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-WeaponsAddEffects",	"무기: 추가 효과");
		this.Text("IAH-Menu-Setting-Desc-WeaponsAddEffects",	"헤드샷 피해 배율·방어구 관통 등의 추가 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-WeaponsCritEffects",	"무기: 치명타 효과");
		this.Text("IAH-Menu-Setting-Desc-WeaponsCritEffects",	"치명타 확률·치명타 피해 등의 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-WeaponsMuzzleEffects",	"무기: 총구 부착물");
		this.Text("IAH-Menu-Setting-Desc-WeaponsMuzzleEffects",	"장착한 소음기와 총구 제퇴기의 도탄·반동 등 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-WeaponsScopeEffects",	"무기: 조준경");
		this.Text("IAH-Menu-Setting-Desc-WeaponsScopeEffects",	"장착한 조준경의 흔들림·조준 시간·헤드샷 치명타 등 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-WeaponsModsEffects",	"무기: 개조 부품");
		this.Text("IAH-Menu-Setting-Desc-WeaponsModsEffects",	"장착한 개조 부품의 효과를 표시합니다. 아이콘은 무기 표시 영역의 오른쪽에 나타납니다.");

		this.Text("IAH-Menu-Setting-Name-CWArmsEffects",		"팔 사이버웨어");
		this.Text("IAH-Menu-Setting-Desc-CWArmsEffects",		"팔 사이버웨어의 피해 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-ClothingEffects",		"의상");
		this.Text("IAH-Menu-Setting-Desc-ClothingEffects",		"의상의 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-MuzzlesEffects",		"소음기 및 총구 부착물");
		this.Text("IAH-Menu-Setting-Desc-MuzzlesEffects",		"소음기와 총구 제퇴기의 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-ScopesEffects",		"조준경");
		this.Text("IAH-Menu-Setting-Desc-ScopesEffects",		"조준경의 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-ModsEffects",			"개조 부품");
		this.Text("IAH-Menu-Setting-Desc-ModsEffects",			"개조 부품의 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-EffectsGlow",			"효과 아이콘 발광");
		this.Text("IAH-Menu-Setting-Desc-EffectsGlow",			"모든 효과 아이콘에 은은한 발광 효과를 추가합니다.");

		this.Text("IAH-Menu-Setting-Name-EffectsColorScheme",	"효과 색상 구성");
		this.Text("IAH-Menu-Setting-Desc-EffectsColorScheme",	"효과 아이콘과 능력치에 사용할 색상 구성입니다.");

		this.Text("IAH-Menu-Setting-Name-ClothingTags",			"의상 태그");
		this.Text("IAH-Menu-Setting-Desc-ClothingTags",			"의상에 소속·스타일·가격대 태그가 있으면 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-Magazine",				"탄창 용량 정보");
		this.Text("IAH-Menu-Setting-Desc-Magazine",				"툴팁 하단에 무기의 탄창 용량을 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-Dps",					"무기 DPS 정보");
		this.Text("IAH-Menu-Setting-Desc-Dps",					"무기의 유효 초당 피해량 정보를 추가합니다.");

		this.Text("IAH-Menu-Setting-Name-DpsDot",				"DPS 소수점 구분 기호");
		this.Text("IAH-Menu-Setting-Desc-DpsDot",				"DPS의 소수점 구분 기호를 점으로 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-ModNames",				"개조 부품 설명 대신 이름 표시");
		this.Text("IAH-Menu-Setting-Desc-ModNames",				"장착한 개조 부품의 전체 설명 대신 이름만 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-ColoredStats",			"능력치 색상 적용");
		this.Text("IAH-Menu-Setting-Desc-ColoredStats",			"툴팁의 능력치에 해당 효과의 색상을 적용합니다.");

		this.Text("IAH-Menu-Setting-Name-StatsIcons",			"능력치 효과 아이콘");
		this.Text("IAH-Menu-Setting-Desc-StatsIcons",			"각 능력치에 효과 아이콘을 추가합니다.");

		this.Text("IAH-Menu-Setting-Name-StatsQuantity",		"능력치 표시 범위");
		this.Text("IAH-Menu-Setting-Desc-StatsQuantity",		"툴팁에 표시할 능력치의 범위를 선택합니다. 일부 숨겨진 능력치도 표시할 수 있습니다.");

		this.Text("IAH-Menu-Setting-Name-EQEXModsFix",			"의상 개조 부품 슬롯 제거");
		this.Text("IAH-Menu-Setting-Desc-EQEXModsFix",			"더 이상 사용되지 않는 의상 개조 부품 슬롯을 제거합니다.");

		this.Text("IAH-Menu-Setting-Name-QualityTypeColor",		"무기 유형에 등급 색상 사용");
		this.Text("IAH-Menu-Setting-Desc-QualityTypeColor",		"무기 유형 문구에 무기 등급 색상을 사용합니다. 아래의 색상 설정보다 우선합니다.");

		this.Text("IAH-Enum-Default",							"기본값");

		this.Text("IAH-Enum-Plus-None",							"없음");
		this.Text("IAH-Enum-Plus-V1",							"V1");
		this.Text("IAH-Enum-Plus-V1_1",							"V1.1");
		this.Text("IAH-Enum-Plus-V2",							"V2");
		this.Text("IAH-Enum-Plus-V2_1",							"V2.1");

		this.Text("IAH-Enum-AmmoReplacer-DPS",					"DPS");
		this.Text("IAH-Enum-AmmoReplacer-Magazine",				"탄창 용량");
		this.Text("IAH-Enum-AmmoReplacer-WeaponType",			"무기 유형");
		this.Text("IAH-Enum-AmmoReplacer-None",					"없음");

		this.Text("IAH-Enum-Color-Grey",						"회색");
		this.Text("IAH-Enum-Color-White",						"흰색");
		this.Text("IAH-Enum-Color-LightYellow",					"연노랑");
		this.Text("IAH-Enum-Color-Yellow",						"노랑");
		this.Text("IAH-Enum-Color-LightOrange",					"연주황");
		this.Text("IAH-Enum-Color-Orange",						"주황");
		this.Text("IAH-Enum-Color-LightRed",					"연빨강");
		this.Text("IAH-Enum-Color-Red",							"빨강");
		this.Text("IAH-Enum-Color-Pink",						"분홍");
		this.Text("IAH-Enum-Color-LightPink",					"연분홍");
		this.Text("IAH-Enum-Color-Purple",						"보라");
		this.Text("IAH-Enum-Color-LightPurple",					"연보라");
		this.Text("IAH-Enum-Color-Blue",						"파랑");
		this.Text("IAH-Enum-Color-LightBlue",					"하늘색");
		this.Text("IAH-Enum-Color-Aquamarine",					"청록");
		this.Text("IAH-Enum-Color-Green",						"초록");
		this.Text("IAH-Enum-Color-DarkGreen",					"진초록");
		this.Text("IAH-Enum-Color-SaladGreen",					"연두");

		this.Text("IAH-Enum-ClothingTags-None",					"없음");
		this.Text("IAH-Enum-ClothingTags-Faction",				"소속만");
		this.Text("IAH-Enum-ClothingTags-All",					"모두");

		this.Text("IAH-Enum-StatsQuantity-Intrinsic",			"기본");
		this.Text("IAH-Enum-StatsQuantity-Parts",				"기본 + 부착물");
		this.Text("IAH-Enum-StatsQuantity-Mods",				"기본 + 부착물 + 개조 부품");
		this.Text("IAH-Enum-StatsQuantity-All",					"모두");

		this.Text("IAH-ClothingTags-Rich",						"고급");
		this.Text("IAH-ClothingTags-Simple",					"일반");
		this.Text("IAH-ClothingTags-Poor",						"저가");

		this.Text("IAH-ClothingTags-Biker",						"바이커");
		this.Text("IAH-ClothingTags-Casual",					"캐주얼");
		this.Text("IAH-ClothingTags-Corpo",						"기업");
		this.Text("IAH-ClothingTags-Cowboy",					"카우보이");
		this.Text("IAH-ClothingTags-Formal",					"정장");
		this.Text("IAH-ClothingTags-Industrial",				"작업복");
		this.Text("IAH-ClothingTags-Military",					"군복");
		this.Text("IAH-ClothingTags-Punk",						"펑크");
		this.Text("IAH-ClothingTags-Rocker",					"로커");
		this.Text("IAH-ClothingTags-Samurai",					"사무라이");
		this.Text("IAH-ClothingTags-Sports",					"스포츠");
		this.Text("IAH-ClothingTags-Streetwear",				"스트리트웨어");
		this.Text("IAH-ClothingTags-Stylish",					"세련된 스타일");
		this.Text("IAH-ClothingTags-Tomboy",					"톰보이");

		this.Text("IAH-ClothingTags-Animals",					"애니멀");
		this.Text("IAH-ClothingTags-Aldecaldos",				"알데칼도");
		this.Text("IAH-ClothingTags-Arasaka",					"아라사카");
		this.Text("IAH-ClothingTags-Barghest",					"바게스트");
		this.Text("IAH-ClothingTags-Biotechnica",				"바이오테크니카");
		this.Text("IAH-ClothingTags-KangTao",					"캉 타오");
		this.Text("IAH-ClothingTags-Maelstrom",					"멜스트롬");
		this.Text("IAH-ClothingTags-Militech",					"밀리테크");
		this.Text("IAH-ClothingTags-Moxies",					"목스");
		this.Text("IAH-ClothingTags-NCPD",						"NCPD");
		this.Text("IAH-ClothingTags-SixthStreet",				"식스 스트리트");
		this.Text("IAH-ClothingTags-Scavengers",				"스캐빈저");
		this.Text("IAH-ClothingTags-TraumaTeam",				"트라우마 팀");
		this.Text("IAH-ClothingTags-TygerClaws",				"타이거 클로");
		this.Text("IAH-ClothingTags-Valentinos",				"발렌티노");
		this.Text("IAH-ClothingTags-VoodooBoys",				"부두 보이즈");
		this.Text("IAH-ClothingTags-Wraiths",					"레이스");
		this.Text("IAH-ClothingTags-Zetatech",					"제타테크");

		// Version 1.2
		this.Text("IAH-Menu-Setting-Name-ClothingTagsMarker",	"소속 태그가 있는 의상 표시");
		this.Text("IAH-Menu-Setting-Desc-ClothingTagsMarker",	"소속 태그가 있는 의상의 아이콘에 색상 표시를 추가합니다.");

		// Version 1.3
		this.Text("IAH-Menu-Setting-Name-ModInfoScheme",		"장착한 개조 부품 정보");
		this.Text("IAH-Menu-Setting-Desc-ModInfoScheme",		"장착한 개조 부품의 이름·설명 또는 둘 다 표시합니다.");

		this.Text("IAH-Enum-ModInfoScheme-Desc",				"설명만");
		this.Text("IAH-Enum-ModInfoScheme-Name",				"이름만");
		this.Text("IAH-Enum-ModInfoScheme-NameAndDesc",			"이름과 설명");

		// Version 1.4
		// + modified line 132
		this.Text("IAH-Menu-Setting-Name-WeaponTypePosition",	"무기 유형 표시 위치");
		this.Text("IAH-Menu-Setting-Desc-WeaponTypePosition",	"무기 유형 또는 이름 문구의 위치를 설정합니다.");

		this.Text("IAH-Menu-Setting-Name-ShowAttackTypeRanged",	"공격 유형: 원거리");
		this.Text("IAH-Menu-Setting-Desc-ShowAttackTypeRanged",	"탄약 표시 대체 항목에서 공격 유형을 선택한 경우 원거리 무기의 공격 유형 아이콘을 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-ShowAttackTypeMelee",	"공격 유형: 근접");
		this.Text("IAH-Menu-Setting-Desc-ShowAttackTypeMelee",	"탄약 표시 대체 항목에서 공격 유형을 선택한 경우 근접 무기의 공격 유형 아이콘을 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-AttackTypeColor",		"공격 유형: 색상");
		this.Text("IAH-Menu-Setting-Desc-AttackTypeColor",		"탄약 표시 대체 항목에서 공격 유형을 선택한 경우 공격 유형 아이콘의 색상 구성을 설정합니다.");

		this.Text("IAH-Menu-Setting-Name-WeaponsEffectsScale",	"아이콘 크기");
		this.Text("IAH-Menu-Setting-Desc-WeaponsEffectsScale",	"모든 효과 아이콘의 크기 배율을 설정합니다.");

		this.Text("IAH-Menu-Setting-Name-FoodEffects",			"음식");
		this.Text("IAH-Menu-Setting-Desc-FoodEffects",			"음식의 유형과 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-DrinkEffects",			"음료");
		this.Text("IAH-Menu-Setting-Desc-DrinkEffects",			"음료의 유형과 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-AlcoholEffects",		"주류");
		this.Text("IAH-Menu-Setting-Desc-AlcoholEffects",		"주류의 유형과 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-DrugEffects",			"약물");
		this.Text("IAH-Menu-Setting-Desc-DrugEffects",			"약물의 유형과 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-NicotineEffects",		"담배");
		this.Text("IAH-Menu-Setting-Desc-NicotineEffects",		"담배의 유형과 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-BoosterEffects",		"부스터");
		this.Text("IAH-Menu-Setting-Desc-BoosterEffects",		"각종 부스터의 유형과 효과를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-JunkCost",				"잡동사니 가치");
		this.Text("IAH-Menu-Setting-Desc-JunkCost",				"잡동사니 아이템의 가치를 표시합니다.");

		this.Text("IAH-Menu-Setting-Name-ConsumablesStyle",		"소모품 아이콘 표시 방식");
		this.Text("IAH-Menu-Setting-Desc-ConsumablesStyle",		"소모품에 표시할 아이콘의 기준을 설정합니다.");

		this.Text("IAH-Menu-Setting-Name-DFColorizing",			"배낭의 욕구 아이콘 색상 적용");
		this.Text("IAH-Menu-Setting-Desc-DFColorizing",			"효과 색상 구성에 맞춰 배낭의 욕구 아이콘에 색상을 적용합니다.");

		this.Text("IAH-Menu-Setting-Name-tooltipsScaleItems",	"툴팁 크기");
		this.Text("IAH-Menu-Setting-Desc-tooltipsScaleItems",	"인벤토리 아이템 툴팁의 크기 배율을 설정합니다.");

		this.Text("IAH-Enum-Position-Centered",					"가운데");
		this.Text("IAH-Enum-Position-Left",						"왼쪽");
		this.Text("IAH-Enum-AmmoReplacer-AttackType",			"공격 유형");
		this.Text("IAH-Enum-AttackTypeColor-TypeDependent",		"유형별 색상");
		this.Text("IAH-Enum-AttackTypeColor-TypeDimmed",		"유형별 색상 (어둡게)");
		this.Text("IAH-Enum-IconsStyle-ByItemType",				"아이템 유형 기준");
		this.Text("IAH-Enum-IconsStyle-ByBuffType",				"효과 유형 기준");

		// Version 1.5
		this.Text("IAH-Menu-Setting-Name-ModsWrappingCount",	"개조 부품 표시의 열 수");
		this.Text("IAH-Menu-Setting-Desc-ModsWrappingCount",	"개조 부품 표시 격자의 가로 칸 수를 설정합니다. 사이버덱에도 적용됩니다.");

		this.Text("IAH-Menu-Setting-Name-Manufacturer",			"무기 제조사 로고");
		this.Text("IAH-Menu-Setting-Desc-Manufacturer",			"무기 이름 옆에 제조사 로고를 표시합니다. 원거리 무기에만 적용됩니다.");
	}
}

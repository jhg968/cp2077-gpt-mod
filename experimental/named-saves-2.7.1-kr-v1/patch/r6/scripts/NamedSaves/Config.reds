module NamedSaves.Config

public class NamedSavesConfig {
  @runtimeProperty("ModSettings.mod", "Named Saves")
  @runtimeProperty("ModSettings.category", "일반")
  @runtimeProperty("ModSettings.displayName", "마지막으로 사용한 이름 기억")
  @runtimeProperty("ModSettings.description", "텍스트 입력란이 마지막으로 사용한 저장 파일 이름을 기억합니다.")
  public let rememberLastUsed: Bool = false;

  @runtimeProperty("ModSettings.mod", "Named Saves")
  @runtimeProperty("ModSettings.category", "일반")
  @runtimeProperty("ModSettings.displayName", "모든 캐릭터에서 검색")
  @runtimeProperty("ModSettings.description", "검색란이 비어 있지 않으면 모든 캐릭터 범주의 저장 파일 메모를 검색합니다. 변경 사항은 다음에 게임 불러오기 메뉴를 열 때 적용됩니다.")
  public let searchAllCategories: Bool = false;

  @runtimeProperty("ModSettings.mod", "Named Saves")
  @runtimeProperty("ModSettings.category", "일반")
  @runtimeProperty("ModSettings.displayName", "검색 결과에서 범주 제목 숨기기")
  @runtimeProperty("ModSettings.description", "모든 캐릭터에서 검색할 때 캐릭터 범주의 제목을 숨깁니다. 저장 파일은 기존 순서를 유지합니다. 변경 사항은 다음에 게임 불러오기 메뉴를 열 때 적용됩니다.")
  @runtimeProperty("ModSettings.dependency", "searchAllCategories")
  public let hideCategoryHeaders: Bool = false;

  public static func ShouldRememberLastUsed() -> Bool {
    let config: ref<NamedSavesConfig> = new NamedSavesConfig();
    return config.rememberLastUsed;
  }
}

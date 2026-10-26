module MinimapWidgets.Translations

import Codeware.Localization.*

public class MinimapWidgets_LocalizationProvider extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    switch language {
      case n"ru-ru": return new MinimapWidgets_Russian();
      case n"de-de": return new MinimapWidgets_German();
      case n"fr-fr": return new MinimapWidgets_French();
      case n"it-it": return new MinimapWidgets_Italian();
      case n"pt-br": return new MinimapWidgets_Portuguese();
      case n"kr-kr": return new MinimapWidgets_Korean();
      default:       return new MinimapWidgets_English();
    };
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

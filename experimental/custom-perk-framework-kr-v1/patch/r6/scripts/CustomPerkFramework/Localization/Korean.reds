module CustomPerkFramework.Localization

import Codeware.Localization.*

public class Korean extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("CPF-Level", " 레벨");
    this.Text("CPF-StreetCred", " 평판");
    this.Text("CPF-AttributePoints", "특성 포인트");
    this.Text("CPF-PerkPoints", "특전 포인트");
    this.Text("CPF-TreeNameDefault", "추가 특전");

    this.Text("CPF-Attr-Body", "신체");
    this.Text("CPF-Attr-Reflexes", "반사");
    this.Text("CPF-Attr-Tech", "테크");
    this.Text("CPF-Attr-Intelligence", "지능");
    this.Text("CPF-Attr-Cool", "냉정");

    this.Text("CPF-Footer", "모듈형 특전 확장 시스템");
    this.Text("CPF-NoTrees", "설치된 특전 트리가 없습니다.\n\nCustom Perk Framework를 사용하는 모드를 설치하면 여기에 표시됩니다.");
  }
}

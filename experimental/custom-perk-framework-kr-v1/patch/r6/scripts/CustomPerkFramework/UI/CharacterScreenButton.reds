module CustomPerkFramework.UI

import Codeware.UI.*
import CustomPerkFramework.*

@addField(NewPerksCategoriesGameController)
private let m_customPerkFrameworkButton: ref<inkCanvas>;

@addField(NewPerksCategoriesGameController)
private let m_customPerkFrameworkPopup: ref<CustomPerkScreenPopup>;

@wrapMethod(NewPerksCategoriesGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.CreateCustomPerkFrameworkButton();
}

@addMethod(NewPerksCategoriesGameController)
private func CreateCustomPerkFrameworkButton() -> Void {
  let skillsButton: ref<inkWidget> = inkWidgetRef.Get(this.m_skillsScreenButton);
  if !IsDefined(skillsButton) { return; }

  let parent: ref<inkCompoundWidget> = skillsButton.GetParentWidget() as inkCompoundWidget;
  if !IsDefined(parent) { return; }

  let skillsSize: Vector2 = skillsButton.GetSize();

  let buttonCanvas: ref<inkCanvas> = new inkCanvas();
  buttonCanvas.SetName(n"CustomPerkFrameworkButton");
  buttonCanvas.SetAnchor(inkEAnchor.BottomRight);
  buttonCanvas.SetAnchorPoint(new Vector2(1.0, 1.0));
  buttonCanvas.SetMargin(new inkMargin(0.0, 0.0, 130.0, 380.0));
  buttonCanvas.SetSize(skillsSize);
  buttonCanvas.SetInteractive(true);
  buttonCanvas.Reparent(parent);

  let bg: ref<inkImage> = new inkImage();
  bg.SetName(n"bg");
  bg.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
  bg.SetTexturePart(n"cell_bg");
  bg.SetNineSliceScale(true);
  bg.SetAnchor(inkEAnchor.Fill);
  bg.SetOpacity(0.8);
  bg.SetTintColor(new HDRColor(0.054902, 0.054902, 0.090196, 1.0));
  bg.Reparent(buttonCanvas);

  let frame: ref<inkImage> = new inkImage();
  frame.SetName(n"frame");
  frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
  frame.SetTexturePart(n"cell_fg");
  frame.SetNineSliceScale(true);
  frame.SetAnchor(inkEAnchor.Fill);
  frame.SetOpacity(0.6);
  frame.SetTintColor(new HDRColor(0.9, 0.7, 0.1, 1.0));
  frame.Reparent(buttonCanvas);

  let leftAccent: ref<inkImage> = new inkImage();
  leftAccent.SetName(n"leftAccent");
  leftAccent.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
  leftAccent.SetTexturePart(n"item_side_fg");
  leftAccent.SetNineSliceScale(true);
  leftAccent.SetAnchor(inkEAnchor.CenterLeft);
  leftAccent.SetAnchorPoint(new Vector2(0.0, 0.5));
  leftAccent.SetMargin(new inkMargin(-2.0, 0.0, 0.0, 0.0));
  leftAccent.SetSize(new Vector2(6.0, skillsSize.Y));
  leftAccent.SetTintColor(new HDRColor(1.0, 0.85, 0.2, 1.0));
  leftAccent.SetOpacity(0.8);
  leftAccent.Reparent(buttonCanvas);

  let contentContainer: ref<inkHorizontalPanel> = new inkHorizontalPanel();
  contentContainer.SetName(n"contentContainer");
  contentContainer.SetAnchor(inkEAnchor.Centered);
  contentContainer.SetAnchorPoint(new Vector2(0.5, 0.5));
  contentContainer.SetFitToContent(true);
  contentContainer.SetChildMargin(new inkMargin(8.0, 0.0, 8.0, 0.0));
  contentContainer.Reparent(buttonCanvas);

  let icon: ref<inkImage> = new inkImage();
  icon.SetName(n"icon");
  icon.SetAtlasResource(r"base\\gameplay\\gui\\fullscreen\\hub_menu\\hub_atlas.inkatlas");
  icon.SetTexturePart(n"ico_character_hub");
  icon.SetSize(new Vector2(56.0, 56.0));
  icon.SetTintColor(new HDRColor(1.0, 0.9, 0.3, 1.0));
  icon.SetHAlign(inkEHorizontalAlign.Center);
  icon.SetVAlign(inkEVerticalAlign.Center);
  icon.Reparent(contentContainer);

  let label: ref<inkText> = new inkText();
  label.SetName(n"label");
  label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  label.SetFontStyle(n"Semi-Bold");
  label.SetFontSize(46);
  label.SetLetterCase(textLetterCase.UpperCase);
  label.SetText("추가 특전 트리");
  label.SetTintColor(new HDRColor(1.0, 0.9, 0.3, 1.0));
  label.SetHAlign(inkEHorizontalAlign.Center);
  label.SetVAlign(inkEVerticalAlign.Center);
  label.Reparent(contentContainer);

  let system: ref<CustomPerkFrameworkSystem> = CustomPerkFrameworkSystem.GetInstance(this.m_player.GetGame());
  if IsDefined(system) {
    let treeCount: Int32 = system.GetTreeCount();
    if treeCount > 0 {
      let countBadge: ref<inkText> = new inkText();
      countBadge.SetName(n"countBadge");
      countBadge.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
      countBadge.SetFontStyle(n"Bold");
      countBadge.SetFontSize(28);
      countBadge.SetText("(" + ToString(treeCount) + ")");
      countBadge.SetTintColor(new HDRColor(0.8, 0.7, 0.2, 1.0));
      countBadge.SetHAlign(inkEHorizontalAlign.Center);
      countBadge.SetVAlign(inkEVerticalAlign.Center);
      countBadge.Reparent(contentContainer);
    }
  }

  let hoverHighlight: ref<inkImage> = new inkImage();
  hoverHighlight.SetName(n"hoverHighlight");
  hoverHighlight.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
  hoverHighlight.SetTexturePart(n"cell_bg");
  hoverHighlight.SetNineSliceScale(true);
  hoverHighlight.SetAnchor(inkEAnchor.Fill);
  hoverHighlight.SetOpacity(0.0);
  hoverHighlight.SetTintColor(new HDRColor(1.0, 0.85, 0.2, 1.0));
  hoverHighlight.Reparent(buttonCanvas);

  this.m_customPerkFrameworkButton = buttonCanvas;

  buttonCanvas.RegisterToCallback(n"OnRelease", this, n"OnCustomPerkFrameworkButtonClick");
  buttonCanvas.RegisterToCallback(n"OnHoverOver", this, n"OnCustomPerkFrameworkButtonHoverOver");
  buttonCanvas.RegisterToCallback(n"OnHoverOut", this, n"OnCustomPerkFrameworkButtonHoverOut");
}

@addMethod(NewPerksCategoriesGameController)
protected cb func OnCustomPerkFrameworkButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") || evt.IsAction(n"tap") {
    this.PlaySound(n"Button", n"OnPress");
    this.m_customPerkFrameworkPopup = new CustomPerkScreenPopup();
    this.m_customPerkFrameworkPopup.Open(this, this.m_player);
  }
}

@addMethod(NewPerksCategoriesGameController)
protected cb func OnCustomPerkFrameworkButtonHoverOver(evt: ref<inkPointerEvent>) -> Bool {
  if IsDefined(this.m_customPerkFrameworkButton) {
    let hoverHighlight: ref<inkWidget> = this.m_customPerkFrameworkButton.GetWidgetByPathName(n"hoverHighlight");
    if IsDefined(hoverHighlight) { hoverHighlight.SetOpacity(0.15); }

    let frame: ref<inkWidget> = this.m_customPerkFrameworkButton.GetWidgetByPathName(n"frame");
    if IsDefined(frame) {
      frame.SetTintColor(new HDRColor(1.0, 0.85, 0.2, 1.0));
      frame.SetOpacity(1.0);
    }

    let leftAccent: ref<inkWidget> = this.m_customPerkFrameworkButton.GetWidgetByPathName(n"leftAccent");
    if IsDefined(leftAccent) { leftAccent.SetOpacity(1.0); }
  }
  this.PlaySound(n"Button", n"OnHover");
}

@addMethod(NewPerksCategoriesGameController)
protected cb func OnCustomPerkFrameworkButtonHoverOut(evt: ref<inkPointerEvent>) -> Bool {
  if IsDefined(this.m_customPerkFrameworkButton) {
    let hoverHighlight: ref<inkWidget> = this.m_customPerkFrameworkButton.GetWidgetByPathName(n"hoverHighlight");
    if IsDefined(hoverHighlight) { hoverHighlight.SetOpacity(0.0); }

    let frame: ref<inkWidget> = this.m_customPerkFrameworkButton.GetWidgetByPathName(n"frame");
    if IsDefined(frame) {
      frame.SetTintColor(new HDRColor(0.9, 0.7, 0.1, 1.0));
      frame.SetOpacity(0.6);
    }

    let leftAccent: ref<inkWidget> = this.m_customPerkFrameworkButton.GetWidgetByPathName(n"leftAccent");
    if IsDefined(leftAccent) { leftAccent.SetOpacity(0.8); }
  }
}

@wrapMethod(NewPerksCategoriesGameController)
protected cb func OnUninitialize() -> Bool {
  if IsDefined(this.m_customPerkFrameworkButton) {
    this.m_customPerkFrameworkButton.UnregisterFromCallback(n"OnRelease", this, n"OnCustomPerkFrameworkButtonClick");
    this.m_customPerkFrameworkButton.UnregisterFromCallback(n"OnHoverOver", this, n"OnCustomPerkFrameworkButtonHoverOver");
    this.m_customPerkFrameworkButton.UnregisterFromCallback(n"OnHoverOut", this, n"OnCustomPerkFrameworkButtonHoverOut");
  }
  wrappedMethod();
}

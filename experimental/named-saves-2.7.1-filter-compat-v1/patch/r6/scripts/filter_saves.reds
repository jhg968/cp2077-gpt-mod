module FilterSaves

import Codeware.UI.TextInput.*
import Codeware.UI.*

// CUSTOM FUNCS AND TYPES

public func GetLifepathFilterButtonAction() -> CName { return n"world_map_menu_cycle_filter_next"; }

public func GetSaveTypeFilterButtonAction() -> CName { return n"world_map_menu_cycle_filter_prev"; }

class FilterSavesConfig {
  public static func RememberType() -> Bool = false
  public static func RememberLifepath() -> Bool = false
  public static func SaveTypeFilter(filter: SaveTypeFilter) -> Void {}
  public static func SaveLifepathFilter(filter: LifePathFilter) -> Void {}
  public static func GetSavedTypeFilter() -> SaveTypeFilter { return SaveTypeFilter.All; }
  public static func GetSavedLifepathFilter() -> LifePathFilter { return LifePathFilter.All; }
}

public func GetLifepathFilterText(filter: LifePathFilter) -> String {
  let choice: String = "";
  switch filter {
    case LifePathFilter.All:
      choice = GetLocalizedText("LocKey#45642"); // "Show All"
      break;
    case LifePathFilter.Corpo:
      choice = GetLocalizedText("LocKey#1800"); // "Corpo"
      break;
    case LifePathFilter.Nomad:
      choice = GetLocalizedText("LocKey#1799"); // "Nomad"
      break;
    case LifePathFilter.StreetKid:
      choice = GetLocalizedText("LocKey#1801"); // "StreetKid"
      break;
    case LifePathFilter.Invalid:
      choice = GetLocalizedText("LocKey#3178953369"); // "Fresh Start"
      break;
    default:
      break;
  }
  // Lifepath: choice
  return GetLocalizedText("LocKey#46336") + ": " + choice;
}

public func GetSaveTypeFilterText(filter: SaveTypeFilter) -> String {
  let choice: String = "";
  switch filter {
    case SaveTypeFilter.All:
      choice = GetLocalizedText("LocKey#45642"); // "Show All"
      break;
    case SaveTypeFilter.AutoSaves:
      choice = GetLocalizedText("LocKey#50915"); // "AutoSave-"
      break;
    case SaveTypeFilter.QuickSaves:
      choice = GetLocalizedText("LocKey#50914"); // "Quicksave"
      break;
    case SaveTypeFilter.ManualSaves:
      choice = GetLocalizedText("LocKey#50913"); // "ManualSave-"
      break;
    case SaveTypeFilter.PointOfNoReturn:
      choice = GetLocalizedText("LocKey#76974"); // "PointOfNoReturn-"
      break;
    // case SaveTypeFilter.EndGameSave:
    //   choice = GetLocalizedText("LocKey#76975"); // "EndGameSave-"
    //   break;
    default:
      break;
  }

  // Type: choice
  return GetLocalizedText("LocKey#22100") + ": " + StrReplace(choice, "-", "");
}

public enum LifePathFilter {
  All = 0,
  Corpo = 1,
  Nomad = 2,
  StreetKid = 3,
  Invalid = 4
}

public enum SaveTypeFilter {
  All = 0,
  ManualSaves = 1,
  QuickSaves = 2,
  AutoSaves = 3,
  PointOfNoReturn = 4,
  // EndGameSave = 5
}

public func IsFreshStartInstalled() -> Bool {
  let newStart: ref<LifePath_Record> = TweakDBInterface.GetLifePathRecord(t"LifePaths.NewStart");
  return IsDefined(newStart);
}

// INPUT DEVICE TRACKING

// Uses raw input instead of ink pointer events to tell if kbm
public class FilterSavesInputTracker {
  private let usingPad: Bool;
  private let gogButton: wref<inkWidget>;
  private let keyHandler: wref<CallbackSystemHandler>;
  private let axisHandler: wref<CallbackSystemHandler>;

  public static func Create(gameCtrl: wref<inkGameController>, gogButton: wref<inkWidget>) -> ref<FilterSavesInputTracker> {
    let self: ref<FilterSavesInputTracker> = new FilterSavesInputTracker();
    let player: ref<GameObject> = gameCtrl.GetPlayerControlledObject();
    self.usingPad = IsDefined(player) && player.PlayerLastUsedPad();
    self.gogButton = gogButton;
    self.UpdateGogButton();
    self.keyHandler = GameInstance.GetCallbackSystem().RegisterCallback(n"Input/Key", self, n"OnKeyInput", true);
    self.axisHandler = GameInstance.GetCallbackSystem().RegisterCallback(n"Input/Axis", self, n"OnAxisInput", true);
    return self;
  }

  public func Unregister() -> Void {
    this.keyHandler.Unregister();
    this.axisHandler.Unregister();
  }

  public func IsUsingPad() -> Bool {
    return this.usingPad;
  }

  private cb func OnKeyInput(event: ref<KeyInputEvent>) {
    this.SetUsingPad(this.IsPadKey(event.GetKey()));
  }

  private cb func OnAxisInput(event: ref<AxisInputEvent>) {
    let key: EInputKey = event.GetKey();
    if this.IsPadKey(key) {
      if AbsF(event.GetValue()) > 0.3 {
        this.SetUsingPad(true);
      }
    }
    else if Equals(key, EInputKey.IK_MouseX) || Equals(key, EInputKey.IK_MouseY) {
      if event.GetValue() != 0.0 {
        this.SetUsingPad(false);
      }
    }
  }

  private func IsPadKey(key: EInputKey) -> Bool {
    return StrBeginsWith(EnumValueToString("EInputKey", Cast<Int64>(EnumInt(key))), "IK_Pad");
  }

  private func SetUsingPad(usingPad: Bool) -> Void {
    if NotEquals(this.usingPad, usingPad) {
      this.usingPad = usingPad;
      this.UpdateGogButton();
    }
  }

  // The cloud saves button has its own dedicated pad button, so keep pad navigation from landing on it
  private func UpdateGogButton() -> Void {
    if IsDefined(this.gogButton) && this.gogButton.IsVisible() {
      this.gogButton.SetInteractive(!this.usingPad);
    }
  }
}

// On gamepad the cursor is snapped to the hovered list item. If that item gets hidden by a filter,
// the cursor stays locked to the invisible widget, so snap it to the nearest visible item instead.
// After a filter change, also snap if no visible save is hovered (cursor elsewhere or hover not tracked).
// If every save is filtered out, snap to the fallback widget so the cursor isn't left locked on nothing
public func FilterSavesSnapPadCursor(gameCtrl: wref<inkGameController>, list: inkCompoundRef, hiddenHoverIndex: Int32, filterChanged: Bool, opt fallback: wref<inkWidget>) -> Void {
  if hiddenHoverIndex >= 0 {
    FilterSavesMoveCursorToNearestVisible(gameCtrl, list, hiddenHoverIndex, fallback);
    return;
  }
  if !filterChanged {
    return;
  }
  let i: Int32 = 0;
  while i < inkCompoundRef.GetNumChildren(list) {
    let widget: wref<inkWidget> = inkCompoundRef.GetWidgetByIndex(list, i);
    let controller: wref<LoadListItem> = widget.GetController() as LoadListItem;
    if widget.IsVisible() && IsDefined(controller) && controller.IsFilterSavesHovered() {
      return;
    }
    i += 1;
  }
  FilterSavesMoveCursorToNearestVisible(gameCtrl, list, -1, fallback);
}

// Runs the snap on the next frame, once the list has re-laid out after items were hidden,
// so the cursor targets where the widget actually ends up instead of its old position
public class FilterSavesSnapPadCursorCallback extends DelayCallback {
  private let gameCtrl: wref<inkGameController>;
  private let list: inkCompoundRef;
  private let hiddenHoverIndex: Int32;
  private let filterChanged: Bool;

  public static func Create(gameCtrl: wref<inkGameController>, list: inkCompoundRef, hiddenHoverIndex: Int32, filterChanged: Bool) -> ref<FilterSavesSnapPadCursorCallback> {
    let self: ref<FilterSavesSnapPadCursorCallback> = new FilterSavesSnapPadCursorCallback();
    self.gameCtrl = gameCtrl;
    self.list = list;
    self.hiddenHoverIndex = hiddenHoverIndex;
    self.filterChanged = filterChanged;
    return self;
  }

  public func Call() -> Void {
    if IsDefined(this.gameCtrl) {
      FilterSavesSnapPadCursor(this.gameCtrl, this.list, this.hiddenHoverIndex, this.filterChanged);
    }
  }
}

// Returns the index of the list item under the cursor, or -1 if the cursor isn't over the list
public func FilterSavesGetListIndexUnderCursor(gameCtrl: wref<inkGameController>, list: inkCompoundRef) -> Int32 {
  let listWidget: wref<inkWidget> = inkCompoundRef.Get(list);
  let widget: wref<inkWidget> = GameInstance.GetUISystem(gameCtrl.GetPlayerControlledObject().GetGame()).GetInteractableWidgetUnderCursor();
  while IsDefined(widget) {
    let parent: wref<inkWidget> = widget.GetParentWidget();
    if parent == listWidget {
      let i: Int32 = 0;
      while i < inkCompoundRef.GetNumChildren(list) {
        if inkCompoundRef.GetWidgetByIndex(list, i) == widget {
          return i;
        }
        i += 1;
      }
      return -1;
    }
    widget = parent;
  }
  return -1;
}

public class FilterSavesCursorToWidgetCallback extends DelayCallback {
  private let gameCtrl: wref<inkGameController>;
  private let widget: wref<inkWidget>;

  public static func Create(gameCtrl: wref<inkGameController>, widget: wref<inkWidget>) -> ref<FilterSavesCursorToWidgetCallback> {
    let self: ref<FilterSavesCursorToWidgetCallback> = new FilterSavesCursorToWidgetCallback();
    self.gameCtrl = gameCtrl;
    self.widget = widget;
    return self;
  }

  public func Call() -> Void {
    if IsDefined(this.gameCtrl) && IsDefined(this.widget) {
      this.gameCtrl.SetCursorOverWidget(this.widget, 0.0, true);
    }
  }
}

public class FilterSavesApplyVisibilitiesCallback extends DelayCallback {
  private let saveMenu: wref<SaveGameMenuGameController>;
  private let snapTarget: wref<inkWidget>;

  public static func Create(saveMenu: wref<SaveGameMenuGameController>, snapTarget: wref<inkWidget>) -> ref<FilterSavesApplyVisibilitiesCallback> {
    let self: ref<FilterSavesApplyVisibilitiesCallback> = new FilterSavesApplyVisibilitiesCallback();
    self.saveMenu = saveMenu;
    self.snapTarget = snapTarget;
    return self;
  }

  public func Call() -> Void {
    if IsDefined(this.saveMenu) {
      this.saveMenu.FilterSavesApplyVisibilities(true, this.snapTarget);
    }
  }
}

public func FilterSavesMoveCursorToNearestVisible(gameCtrl: wref<inkGameController>, list: inkCompoundRef, fromIndex: Int32, fallback: wref<inkWidget>) -> Void {
  let count: Int32 = inkCompoundRef.GetNumChildren(list);
  let i: Int32 = fromIndex + 1;
  while i < count {
    let widget: wref<inkWidget> = inkCompoundRef.GetWidgetByIndex(list, i);
    if widget.IsVisible() {
      gameCtrl.SetCursorOverWidget(widget, 0.0, true);
      return;
    }
    i += 1;
  }
  i = fromIndex - 1;
  while i >= 0 {
    let widget: wref<inkWidget> = inkCompoundRef.GetWidgetByIndex(list, i);
    if widget.IsVisible() {
      gameCtrl.SetCursorOverWidget(widget, 0.0, true);
      return;
    }
    i -= 1;
  }
  if IsDefined(fallback) && fallback.IsVisible() {
    gameCtrl.SetCursorOverWidget(fallback, 0.0, true);
  }
}

// 2.5 added expand/collapse hints to the load menu, so the hint row runs into the cross progression
// button. Hide the decoration on the button's right side and remove its fixed widths so it ends
// after the middle icon
public func FilterSavesShrinkGogButton(gogButton: wref<inkWidget>) -> Void {
  let button: wref<inkCompoundWidget> = gogButton as inkCompoundWidget;
  if !IsDefined(button) {
    return;
  }
  let fluffRight: wref<inkWidget> = button.GetWidget(n"panels/inkCanvasWidget33");
  if IsDefined(fluffRight) {
    fluffRight.SetVisible(false);
  }
  // the button frame now closes right after the middle icon, so its trailing separator is redundant
  let separator: wref<inkWidget> = button.GetWidget(n"panels/fluff_numbers/separator2");
  if IsDefined(separator) {
    separator.SetVisible(false);
  }
  let minSize: wref<inkWidget> = button.GetWidget(n"minSize");
  if IsDefined(minSize) {
    minSize.SetAffectsLayoutWhenHidden(false);
    minSize.SetVisible(false);
  }
  // bg fills the button, but its fixed width would keep the button wide
  let bg: wref<inkWidget> = button.GetWidget(n"bg");
  if IsDefined(bg) {
    bg.SetWidth(0.0);
  }
}

public class FilterSavesInkBorder extends inkBorder {}

public class FilterSavesTextFlow extends TextFlow {
  protected func CreateWidgets() {
    let text: ref<inkText> = new inkText();
    text.SetName(n"text");
    text.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    text.SetFontStyle(n"Regular");
    text.SetFontSize(50);
    text.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    text.BindProperty(n"tintColor", n"MainColors.PanelRed");
    text.SetHorizontalAlignment(textHorizontalAlignment.Left);
    text.SetVerticalAlignment(textVerticalAlignment.Center);
    text.SetRenderTransformPivot(Vector2(0.0, 0.0));

    this.m_text = text;

    this.SetRootWidget(text);
  }

  public static func Create() -> ref<FilterSavesTextFlow> {
    let self: ref<FilterSavesTextFlow> = new FilterSavesTextFlow();
    self.CreateInstance();

    return self;
  }
}

public class FilterSavesTextInput extends TextInput {
  protected let frame: wref<FilterSavesInkBorder>;
  protected let fill: wref<inkRectangle>;
  protected let interactionFill: wref<inkRectangle>;

  protected func CreateWidgets() {
    let root = new inkCanvas();
    root.SetName(n"input");
    root.SetSize(1000.0, 84.0);
    root.SetMargin(750, 46, 0, 0);
    root.SetAnchor(inkEAnchor.CenterLeft);
    root.SetInteractive(true);
    root.SetSupportFocus(true);
    root.SetVAlign(inkEVerticalAlign.Center);

    let frame: ref<FilterSavesInkBorder> = new FilterSavesInkBorder();
    frame.SetName(n"frame");
    frame.SetOpacity(0.071);
    frame.SetSize(1050.0, 80.0);
    frame.SetMargin(-16.0, 0, 0, 48);
    frame.SetAnchor(inkEAnchor.CenterLeft);
    frame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frame.BindProperty(n"tintColor", n"MainColors.Red");
    frame.SetThickness(2.0);
    frame.Reparent(root);
    this.frame = frame;

    let fill: ref<inkRectangle> = new inkRectangle();
    fill.SetName(n"fill");
    fill.SetSize(1050.0, 80.0);
    fill.SetMargin(-16.0, 0, 0, 48);
    fill.SetAnchor(inkEAnchor.CenterLeft);
    fill.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    fill.BindProperty(n"tintColor", n"MainColors.Fullscreen_PrimaryBackgroundDarkest");
    fill.SetOpacity(0.610);
    fill.Reparent(root);
    this.fill = fill;

    let interactionFill: ref<inkRectangle> = new inkRectangle();
    interactionFill.SetName(n"fill");
    interactionFill.SetSize(1050.0, 80.0);
    interactionFill.SetMargin(-16.0, 0, 0, 48);
    interactionFill.SetAnchor(inkEAnchor.CenterLeft);
    interactionFill.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    interactionFill.BindProperty(n"tintColor", n"MainColors.MildBlue");
    interactionFill.SetOpacity(0.05);
    interactionFill.Reparent(root);
    interactionFill.SetVisible(false);
    this.interactionFill = interactionFill;

    this.m_root = root;

    this.m_measurer = TextMeasurer.Create();
    this.m_measurer.Reparent(this.m_root);

    this.m_viewport = Viewport.Create();
    this.m_viewport.Reparent(this.m_root);

    this.m_selection = Selection.Create();
    this.m_selection.Reparent(this.m_viewport);

    this.m_text = FilterSavesTextFlow.Create();
    this.m_text.Reparent(this.m_viewport);

    this.m_caret = Caret.Create();
    this.m_caret.Reparent(this.m_viewport);

    this.m_wrapper = this.m_viewport.GetRootWidget();

    this.SetRootWidget(this.m_root);
  }

  public static func Create() -> ref<FilterSavesTextInput> {
    let self: ref<FilterSavesTextInput> = new FilterSavesTextInput();
    self.CreateInstance();

    return self;
  }

  public func SetFocusedState(isFocused: Bool) -> Void {
    super.SetFocusedState(isFocused);
  }

  public func SetLeftMargin(margin: Float) -> Void {
    let currentMargin: inkMargin = this.m_root.GetMargin();
    currentMargin.left = margin;
    this.m_root.SetMargin(currentMargin);
  }

  protected func UpdateAppearance() -> Void {
    if this.IsFocused() {
      this.frame.SetOpacity(1.0);
      this.frame.BindProperty(n"tintColor", n"MainColors.Blue");
      this.interactionFill.SetVisible(true);
    }
    else if this.IsHovered() {
      this.frame.SetOpacity(1.0);
      this.frame.BindProperty(n"tintColor", n"MainColors.Red");
      this.interactionFill.SetVisible(false);
    }
    else {
      this.frame.SetOpacity(0.071);
      this.frame.BindProperty(n"tintColor", n"MainColors.Red");
      this.interactionFill.SetVisible(false);
    }
  }

  protected cb func OnHoverOver(event: ref<inkPointerEvent>) -> Bool {
    super.OnHoverOver(event);
    this.UpdateAppearance();
  }

  protected cb func OnHoverOut(event: ref<inkPointerEvent>) -> Bool {   
    super.OnHoverOut(event);
    this.UpdateAppearance();
  }

  protected cb func OnFocusReceived(event: ref<inkEvent>) {
    super.OnFocusReceived(event);
    this.UpdateAppearance();
  }

  protected cb func OnFocusLost(event: ref<inkEvent>) {
    super.OnFocusLost(event);
    this.UpdateAppearance();
  }
}

// LOAD MENU

@addField(LoadGameMenuGameController)
private let m_saveTypeFilter: SaveTypeFilter;

@addField(LoadGameMenuGameController)
private let m_lifePathFilter: LifePathFilter;

@addField(LoadGameMenuGameController)
private let freshStartInstalled: Bool;

@addField(LoadGameMenuGameController)
private let filterSavesSearchBar: wref<FilterSavesTextInput>;

@addField(LoadGameMenuGameController)
private let filterSavesSearchText: String;

@addField(LoadGameMenuGameController)
private let filterSavesInputTracker: ref<FilterSavesInputTracker>;

@wrapMethod(LoadGameMenuGameController)
protected cb func OnInitialize() -> Bool {
  this.m_lifePathFilter = FilterSavesConfig.RememberLifepath() ? FilterSavesConfig.GetSavedLifepathFilter() : LifePathFilter.All;
  this.m_saveTypeFilter = FilterSavesConfig.RememberType() ? FilterSavesConfig.GetSavedTypeFilter() : SaveTypeFilter.All;
  this.freshStartInstalled = IsFreshStartInstalled();

  wrappedMethod();

  let root = this.GetRootWidget() as inkCompoundWidget;
  let holder = root.GetWidget(n"holder") as inkCompoundWidget;
  let parent = holder.GetWidget(n"inkCanvasWidget7") as inkCanvas;

  let input: ref<FilterSavesTextInput> = FilterSavesTextInput.Create();
  input.SetWidth(1000);
  input.SetDefaultText(GetLocalizedTextByKey(n"Mod-Filter-Saves-Filter-Tracked-Quest"));
  input.SetName(n"search_bar");
  input.SetLeftMargin(this.GetSearchBarLeftMargin());
  input.Reparent(parent);

  this.filterSavesSearchBar = input;

  input.RegisterToCallback(n"OnInput", this, n"FilterSavesOnSearchInput");

  this.filterSavesInputTracker = FilterSavesInputTracker.Create(this, inkWidgetRef.Get(this.m_gogButtonWidgetRef));
  FilterSavesShrinkGogButton(inkWidgetRef.Get(this.m_gogButtonWidgetRef));
}

@wrapMethod(LoadGameMenuGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();
  this.filterSavesSearchBar.UnregisterFromCallback(n"OnInput", this, n"FilterSavesOnSearchInput");
  this.filterSavesInputTracker.Unregister();
}

@wrapMethod(LoadGameMenuGameController)
protected cb func OnButtonRelease(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"mouse_left") {
    if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
      this.RequestSetFocus(null);
    }
  }
  
  wrappedMethod(evt);
}

@addMethod(LoadGameMenuGameController)
protected cb func FilterSavesOnSearchInput(widget: ref<inkWidget>) {
  this.filterSavesSearchText = UTF8StrLower(this.StrStrip(this.filterSavesSearchBar.GetText()));
  this.UpdateListItemVisibilities();
}

@if(ModuleExists("NamedSaves.UI"))
@addMethod(LoadGameMenuGameController)
protected func GetSearchBarLeftMargin() -> Float {
  return 1400.0;
}

@if(!ModuleExists("NamedSaves.UI"))
@addMethod(LoadGameMenuGameController)
protected func GetSearchBarLeftMargin() -> Float {
  return 750.0;
}

@if(ModuleExists("NamedSaves.UI"))
@addMethod(LoadGameMenuGameController)
protected func GetNamedSavesSearchQuery() -> String {
  let searchEvent = this.CreateNamedSavesSearchEvent();
  return searchEvent.query;
}

@if(!ModuleExists("NamedSaves.UI"))
@addMethod(LoadGameMenuGameController)
protected func GetNamedSavesSearchQuery() -> String {
  return "";
}

@wrapMethod(LoadGameMenuGameController)
private final func UpdateButtonHints(savesCount: Int32) -> Void {
  wrappedMethod(savesCount);
  if savesCount > 0 {
    this.m_buttonHintsController.AddButtonHint(GetLifepathFilterButtonAction(), GetLifepathFilterText(this.m_lifePathFilter));
    this.m_buttonHintsController.AddButtonHint(GetSaveTypeFilterButtonAction(), GetSaveTypeFilterText(this.m_saveTypeFilter));
  }
}

@wrapMethod(LoadGameMenuGameController)
protected cb func OnButtonRelease(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(GetLifepathFilterButtonAction()) {
    if this.freshStartInstalled {
      this.m_lifePathFilter = IntEnum((EnumInt(this.m_lifePathFilter) + 1) % (Cast<Int32>(EnumGetMax(n"FilterSaves.LifePathFilter")) + 1));
    }
    else {
      this.m_lifePathFilter = IntEnum((EnumInt(this.m_lifePathFilter) + 1) % (Cast<Int32>(EnumGetMax(n"FilterSaves.LifePathFilter"))));
    }
    FilterSavesConfig.SaveLifepathFilter(this.m_lifePathFilter);
    this.UpdateButtonHints(ArraySize(this.m_saves));
    this.UpdateListItemVisibilities(true);
  }
  if evt.IsAction(GetSaveTypeFilterButtonAction()) {
    this.m_saveTypeFilter = IntEnum((EnumInt(this.m_saveTypeFilter) + 1) % (Cast<Int32>(EnumGetMax(n"FilterSaves.SaveTypeFilter")) + 1));
    FilterSavesConfig.SaveTypeFilter(this.m_saveTypeFilter);
    this.UpdateButtonHints(ArraySize(this.m_saves));
    this.UpdateListItemVisibilities(true);
  }

  wrappedMethod(evt);
}

// m_list holds both playthrough group headers and saves, so visibility is applied per group:
// a save is shown only if its group is expanded and it passes the filters, and a header is
// hidden when none of its saves pass the filters
@addMethod(LoadGameMenuGameController)
private func UpdateListItemVisibilities(opt filterChanged: Bool) -> Void {
  let groupIndex: Int32 = 0;
  while groupIndex < ArraySize(this.m_saveWidgetsMap) {
    this.FilterSavesApplyGroupVisibility(groupIndex);
    groupIndex += 1;
  }

  let hiddenHoverIndex: Int32 = -1;
  let i: Int32 = 0;
  while i < inkCompoundRef.GetNumChildren(this.m_list) {
    let controller: wref<LoadListItem> = inkCompoundRef.GetWidgetByIndex(this.m_list, i).GetController() as LoadListItem;
    if IsDefined(controller) && controller.ConsumeFilterSavesHiddenHover() {
      hiddenHoverIndex = i;
    }
    i += 1;
  }
  if this.filterSavesInputTracker.IsUsingPad() {
    FilterSavesSnapPadCursor(this, this.m_list, hiddenHoverIndex, filterChanged, this.filterSavesSearchBar.GetRootWidget());
  }
}

@addMethod(LoadGameMenuGameController)
private func FilterSavesApplyGroupVisibility(playthroughIndex: Int32) -> Void {
  if playthroughIndex < 0 || playthroughIndex >= ArraySize(this.m_saveWidgetsMap) || playthroughIndex >= ArraySize(this.m_saveGroupHeaderWidgets) {
    return;
  }
  let header: wref<inkWidget> = this.m_saveGroupHeaderWidgets[playthroughIndex];
  let groupController: wref<LoadListGroup> = header.GetController() as LoadListGroup;
  let isExpanded: Bool = IsDefined(groupController) && groupController.GetExpandedState();
  let anyMatch: Bool = false;
  for widget in this.m_saveWidgetsMap[playthroughIndex] {
    let controller: wref<LoadListItem> = widget.GetController() as LoadListItem;
    if IsDefined(controller) {
      let passesFilter: Bool = controller.ShouldBeVisible(this.m_lifePathFilter, this.m_saveTypeFilter, this.filterSavesSearchText, this.GetNamedSavesSearchQuery());
      if passesFilter {
        anyMatch = true;
      }
      if controller.FilterSavesSetVisible(isExpanded && passesFilter, true) {
        this.GetSystemRequestsHandler().RequestSavedGameScreenshot(controller.SaveIndex(), controller.GetPreviewImageWidget());
      }
    }
  }
  header.SetAffectsLayoutWhenHidden(false);
  header.SetVisible(anyMatch);
}

// Expanding a group makes all of its saves visible - re-apply the filters afterwards
@wrapMethod(LoadGameMenuGameController)
private final func SetVisibilityOfSavesInGroup(playthroughIndex: Int32, newVisibility: Bool) -> Void {
  wrappedMethod(playthroughIndex, newVisibility);
  this.FilterSavesApplyGroupVisibility(playthroughIndex);
}

@wrapMethod(LoadGameMenuGameController)
protected cb func OnSaveMetadataReady(info: ref<SaveMetadataInfo>) -> Bool {
  // Re-requesting a screenshot (done when a filtered save becomes visible) also re-sends its metadata.
  // Vanilla would add the save to its group again and reorder it, which desyncs the groups from the list
  let playthroughIndex: Int32 = ArrayFindFirst(this.m_playthroughIDs, info.playthroughID);
  if playthroughIndex >= 0 {
    let saveWidget: wref<inkWidget> = this.FindSaveWidget(info.saveIndex);
    if IsDefined(saveWidget) && ArrayContains(this.m_saveWidgetsMap[playthroughIndex], saveWidget) {
      return false;
    }
  }

  wrappedMethod(info);
  // the save is assigned to its playthrough group in the wrapped method
  this.FilterSavesApplyGroupVisibility(ArrayFindFirst(this.m_playthroughIDs, info.playthroughID));
}

// SAVE MENU

@addField(SaveGameMenuGameController)
private let m_lifePathFilter: LifePathFilter;

@addField(SaveGameMenuGameController)
private let freshStartInstalled: Bool;

@addField(SaveGameMenuGameController)
private let filterSavesInputTracker: ref<FilterSavesInputTracker>;

@wrapMethod(SaveGameMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnButtonRelease");
  this.m_buttonHintsController.AddButtonHint(GetLifepathFilterButtonAction(), GetLifepathFilterText(LifePathFilter.All));
  this.m_lifePathFilter = FilterSavesConfig.RememberLifepath() ? FilterSavesConfig.GetSavedLifepathFilter() : LifePathFilter.All;
  this.freshStartInstalled = IsFreshStartInstalled();

  this.RefreshButtonHints();

  this.filterSavesInputTracker = FilterSavesInputTracker.Create(this, inkWidgetRef.Get(this.m_gogButtonWidgetRef));
  FilterSavesShrinkGogButton(inkWidgetRef.Get(this.m_gogButtonWidgetRef));
}

@wrapMethod(SaveGameMenuGameController)
protected cb func OnUninitialize() -> Bool {
  this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnButtonRelease");
  this.filterSavesInputTracker.Unregister();
  wrappedMethod();
}

@addMethod(SaveGameMenuGameController)
private func RefreshButtonHints() -> Void {
  this.m_buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
  this.m_buttonHintsController.AddButtonHint(n"delete_save", GetLocalizedText("UI-Menus-DeleteSave"));
  this.m_buttonHintsController.AddButtonHint(n"select", GetLocalizedText("UI-UserActions-Select"));
  this.m_buttonHintsController.AddButtonHint(GetLifepathFilterButtonAction(), GetLifepathFilterText(this.m_lifePathFilter));
}

@wrapMethod(SaveGameMenuGameController)
protected cb func OnButtonRelease(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.IsAction(GetLifepathFilterButtonAction()) {
    if this.freshStartInstalled {
      this.m_lifePathFilter = IntEnum((EnumInt(this.m_lifePathFilter) + 1) % (Cast<Int32>(EnumGetMax(n"FilterSaves.LifePathFilter")) + 1));
    }
    else {
      this.m_lifePathFilter = IntEnum((EnumInt(this.m_lifePathFilter) + 1) % (Cast<Int32>(EnumGetMax(n"FilterSaves.LifePathFilter"))));
    }
    FilterSavesConfig.SaveLifepathFilter(this.m_lifePathFilter);
    this.RefreshButtonHints();
    this.UpdateListItemVisibilities(true);
  }
}

@addMethod(SaveGameMenuGameController)
private func UpdateListItemVisibilities(opt filterChanged: Bool) -> Void {
  if filterChanged && this.filterSavesInputTracker.IsUsingPad() {
    let target: wref<inkWidget> = this.FilterSavesGetPadCursorTarget();
    if IsDefined(target) {
      // Hiding the item under the gamepad cursor leaves the cursor locked, so move the cursor off it first
      // (like d-pad navigation does) and only hide items on the next frame
      this.SetCursorOverWidget(target, 0.0, true);
      GameInstance.GetDelaySystem(this.GetPlayerControlledObject().GetGame())
        .DelayCallbackNextFrame(FilterSavesApplyVisibilitiesCallback.Create(this, target));
      return;
    }
  }
  this.FilterSavesApplyVisibilities(filterChanged);
}

// Returns the widget to move the cursor to if the hovered save is about to be hidden, otherwise null
@addMethod(SaveGameMenuGameController)
private func FilterSavesGetPadCursorTarget() -> wref<inkWidget> {
  let count: Int32 = inkCompoundRef.GetNumChildren(this.m_list);
  let hoveredIndex: Int32 = FilterSavesGetListIndexUnderCursor(this, this.m_list);
  let i: Int32 = 0;
  // hover events can be missed when the list shifts under a stationary cursor, so they are only a fallback
  while i < count && hoveredIndex < 0 {
    let controller: wref<LoadListItem> = inkCompoundRef.GetWidgetByIndex(this.m_list, i).GetController() as LoadListItem;
    if IsDefined(controller) && controller.IsFilterSavesHovered() && controller.GetRootWidget().IsVisible() {
      hoveredIndex = i;
    }
    i += 1;
  }
  if hoveredIndex < 0 || this.FilterSavesWillBeVisible(hoveredIndex) {
    return null;
  }
  i = hoveredIndex + 1;
  while i < count {
    if this.FilterSavesWillBeVisible(i) {
      return inkCompoundRef.GetWidgetByIndex(this.m_list, i);
    }
    i += 1;
  }
  i = hoveredIndex - 1;
  while i >= 0 {
    if this.FilterSavesWillBeVisible(i) {
      return inkCompoundRef.GetWidgetByIndex(this.m_list, i);
    }
    i -= 1;
  }
  return null;
}

@addMethod(SaveGameMenuGameController)
private func FilterSavesWillBeVisible(index: Int32) -> Bool {
  let controller: wref<LoadListItem> = inkCompoundRef.GetWidgetByIndex(this.m_list, index).GetController() as LoadListItem;
  return IsDefined(controller) && controller.ShouldBeVisible(this.m_lifePathFilter, SaveTypeFilter.All, "", "");
}

@addMethod(SaveGameMenuGameController)
public func FilterSavesApplyVisibilities(filterChanged: Bool, opt snapTarget: wref<inkWidget>) -> Void {
  let button: wref<inkWidget>;
  let controller: wref<LoadListItem>;
  let hiddenHoverIndex: Int32 = -1;
  let i: Int32 = 0;
  while i < inkCompoundRef.GetNumChildren(this.m_list) {
    button = inkCompoundRef.GetWidgetByIndex(this.m_list, i);
    controller = button.GetController() as LoadListItem;
    if IsDefined(controller) {
      if controller.UpdateVisibility(this.m_lifePathFilter, SaveTypeFilter.All, "", "") {
        this.GetSystemRequestsHandler().RequestSavedGameScreenshot(controller.SaveIndex(), controller.GetPreviewImageWidget());
      }
      if controller.ConsumeFilterSavesHiddenHover() {
        hiddenHoverIndex = i;
      }
    }
    i += 1;
  }
  if IsDefined(snapTarget) {
    // the list re-lays out after hiding items, so re-snap to the target once it has settled
    GameInstance.GetDelaySystem(this.GetPlayerControlledObject().GetGame())
      .DelayCallbackNextFrame(FilterSavesCursorToWidgetCallback.Create(this, snapTarget));
  }
  else if this.filterSavesInputTracker.IsUsingPad() && (hiddenHoverIndex >= 0 || filterChanged) {
    GameInstance.GetDelaySystem(this.GetPlayerControlledObject().GetGame())
      .DelayCallbackNextFrame(FilterSavesSnapPadCursorCallback.Create(this, this.m_list, hiddenHoverIndex, filterChanged));
  }
}

@wrapMethod(SaveGameMenuGameController)
protected cb func OnSaveMetadataReady(info: ref<SaveMetadataInfo>) -> Bool {
  wrappedMethod(info);
  this.UpdateListItemVisibilities();
}

// LOAD/SAVE LIST

@addField(LoadListItem)
let m_lifePathFilter: LifePathFilter;

@addField(LoadListItem)
let m_saveTypeFilter: SaveTypeFilter;

@addField(LoadListItem)
let questName: String;

@addField(LoadListItem)
let filterSavesHovered: Bool;

@wrapMethod(LoadListItem)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.m_rootWidget.SetAffectsLayoutWhenHidden(false);
  this.m_lifePathFilter = LifePathFilter.All;
  this.m_saveTypeFilter = SaveTypeFilter.All;
}

@wrapMethod(LoadListItem)
protected cb func OnHoverOver(e: ref<inkPointerEvent>) -> Bool {
  this.filterSavesHovered = true;
  return wrappedMethod(e);
}

@wrapMethod(LoadListItem)
protected cb func OnHoverOut(e: ref<inkPointerEvent>) -> Bool {
  this.filterSavesHovered = false;
  return wrappedMethod(e);
}

@addMethod(LoadListItem)
public func IsFilterSavesHovered() -> Bool {
  return this.filterSavesHovered;
}

// returns true if this item was hovered and has just been hidden, hover out may not fire for hidden widgets, so clear it here
@addMethod(LoadListItem)
public func ConsumeFilterSavesHiddenHover() -> Bool {
  if this.filterSavesHovered && !this.m_rootWidget.IsVisible() {
    this.filterSavesHovered = false;
    return true;
  }
  return false;
}

@wrapMethod(LoadListItem)
public final func SetMetadata(metadata: ref<SaveMetadataInfo>, isVisible: Bool, opt isEp1Enabled: Bool) -> Void {
  wrappedMethod(metadata, isVisible, isEp1Enabled);
  
  this.questName = UTF8StrLower(GetLocalizedText(metadata.trackedQuest));

  switch metadata.lifePath {
    case inkLifePath.Corporate:
      this.m_lifePathFilter = LifePathFilter.Corpo;
      break;
    case inkLifePath.Nomad:
      this.m_lifePathFilter = LifePathFilter.Nomad;
      break;
    case inkLifePath.StreetKid:
      this.m_lifePathFilter = LifePathFilter.StreetKid;
      break;
    case inkLifePath.Invalid:
      this.m_lifePathFilter = LifePathFilter.Invalid;
      break;
    default:
      break;
  }
  
  switch metadata.saveType {
    case inkSaveType.ManualSave:
      this.m_saveTypeFilter = SaveTypeFilter.ManualSaves;
      break;
    case inkSaveType.QuickSave:
      this.m_saveTypeFilter = SaveTypeFilter.QuickSaves;
      break;
    case inkSaveType.AutoSave:
      this.m_saveTypeFilter = SaveTypeFilter.AutoSaves;
      break;
    case inkSaveType.PointOfNoReturn:
      this.m_saveTypeFilter = SaveTypeFilter.PointOfNoReturn;
      break;
    // case inkSaveType.EndGameSave:
    //   this.m_saveTypeFilter = SaveTypeFilter.EndGameSave;
    //   break;
    default:
      break;
  }
}

@addMethod(LoadListItem)
public func UpdateVisibility(lifePathFilter: LifePathFilter, saveTypeFilter: SaveTypeFilter, searchText: String, namedSavesSearchText: String) -> Bool {
  return this.FilterSavesSetVisible(this.ShouldBeVisible(lifePathFilter, saveTypeFilter, searchText, namedSavesSearchText));
}

// Returns true if this item is going to be displayed and should have its image loaded.
// In the grouped load menu, vanilla sets the root widget when a group is expanded/collapsed but the
// inner wrapper when metadata arrives, so includeWrapper keeps both in sync
@addMethod(LoadListItem)
public func FilterSavesSetVisible(shouldShow: Bool, opt includeWrapper: Bool) -> Bool {
  if this.m_emptySlot {
    return false;
  }

  let wasVisible: Bool = this.m_rootWidget.IsVisible() && (!includeWrapper || this.IsVisible());
  this.m_rootWidget.SetVisible(shouldShow);
  if includeWrapper {
    this.SetVisible(shouldShow);
  }
  return !wasVisible && shouldShow;
}

@addMethod(LoadListItem)
public func ShouldBeVisible(lifePathFilter: LifePathFilter, saveTypeFilter: SaveTypeFilter, searchText: String, namedSavesSearchText: String) -> Bool {
  if this.m_emptySlot {
    return true;
  }

  let shouldHide: Bool = false;

  if !Equals(lifePathFilter, this.m_lifePathFilter) && !Equals(lifePathFilter, LifePathFilter.All) {
    shouldHide = true;
  }

  if !Equals(saveTypeFilter, this.m_saveTypeFilter) && !Equals(saveTypeFilter, SaveTypeFilter.All) {
    shouldHide = true;
  }

  if !this.DoesSavePassQuestFilter(searchText) {
    shouldHide = true;
  }

  if !this.DoesSavePassNamedSavesFilter(namedSavesSearchText) {
    shouldHide = true;
  }

  return !shouldHide;
}

@if(ModuleExists("NamedSaves.UI"))
@addMethod(LoadListItem)
protected func DoesSavePassNamedSavesFilter(searchText: String) -> Bool {
  if Equals(searchText, "") {
    return true;
  }
  return StrContains(this.m_customNoteText, searchText);
}

@if(!ModuleExists("NamedSaves.UI"))
@addMethod(LoadListItem)
protected func DoesSavePassNamedSavesFilter(searchText: String) -> Bool {
  return true;
}

@addMethod(LoadListItem)
protected func DoesSavePassQuestFilter(searchText: String) -> Bool {
  if Equals(searchText, "") {
    return true;
  }
  return StrContains(this.questName, searchText);
}

@addMethod(LoadGameMenuGameController)
func StrStrip(text: String) -> String {
  let stripped: String = text;
  while StrLen(stripped) > 0 && StrFindFirst(stripped, " ") == 0 {
    stripped = StrAfterFirst(stripped, " ");
  }
  while StrLen(stripped) > 0 && StrFindLast(stripped, " ") == StrLen(stripped) - 1 {
    stripped = StrBeforeLast(stripped, " ");
  }

  return stripped;
}


// LocKey#15393 : UI-ResourceExports-Filter = Filter
// LocKey#46336 : Story-base-quest-side_quests-sq029-scenes-sq029_xx_debug-sq029_xx_ch_lifepath_displayNameOverride = Lifepath
// 22100 - UI-Sorting-ItemType = Type
// 45642 - UI-Menus-WorldMap-Filter-All = Show All

// 1799 - Gameplay-LifePaths-Nomad = Nomad
// 1800 - Gameplay-LifePaths-Corporate = Corpo
// 1801 - Gameplay-LifePaths-Streetkid = StreetKid

// 50913 - UI-Menus-Saving-ManualSave
// 50914	UI-Menus-Saving-QuickSave	QuickSave-
// 50915 - UI-Menus-Saving-AutoSave
// 76974	UI-Menus-Saving-PointOfNoReturn	PointOfNoReturn-
// 76975	UI-Menus-Saving-EndGameSave	EndGameSave-
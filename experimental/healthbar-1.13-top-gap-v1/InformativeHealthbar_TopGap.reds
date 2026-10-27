module InformativeHealthbar

// Optional layout extension for Informative Healthbar 1.13.
// Keep the information panel at its original position and move the vanilla
// bar/counter widgets down inside their existing parent instead.
@addField(InformativeHealthbarSettings)
@runtimeProperty("ModSettings.mod", "IH.Core.mod.Name")
@runtimeProperty("ModSettings.category", "IH.Core.category.LayoutTheme")
@runtimeProperty("ModSettings.category.order", "5")
@runtimeProperty("ModSettings.displayName", "상단 정보와 체력 바 간격")
@runtimeProperty("ModSettings.description", "체력 바 위 배치에서 정보 줄은 유지하고 체력 바와 숫자를 아래로 이동합니다. Y 오프셋을 0으로 놓고 조절하세요. 0은 원본 배치이며, E3 HUD에서는 적용하지 않습니다.")
@runtimeProperty("ModSettings.min", "0.0")
@runtimeProperty("ModSettings.max", "80.0")
@runtimeProperty("ModSettings.step", "1.0")
public let ihExtraTopGap: Float = 20.0;

@addField(healthbarWidgetGameController)
private let m_ihGapBars: wref<inkWidget>;

@addField(healthbarWidgetGameController)
private let m_ihGapDecoration: wref<inkWidget>;

@addField(healthbarWidgetGameController)
private let m_ihGapBarsBase: Vector2;

@addField(healthbarWidgetGameController)
private let m_ihGapDecorationBase: Vector2;

@addField(healthbarWidgetGameController)
private let m_ihGapRootSize: Vector2;

@addField(healthbarWidgetGameController)
private let m_ihGapRootSizeCaptured: Bool;

@wrapMethod(healthbarWidgetGameController)
private func ApplyIHLayout() {
    wrappedMethod();

    if !IsDefined(this.m_ihSettings) { return; }
    let root = this.GetRootCompoundWidget();
    if !IsDefined(root) { return; }

    let gap: Float = 0.0;
    if Equals(this.m_ihSettings.position, IHPositionMode.Above) && !this.m_isE3HUDActive {
        gap = this.m_ihSettings.ihExtraTopGap;
        if gap < 0.0 { gap = 0.0; }
        if gap > 80.0 { gap = 80.0; }
    }

    let bars = root.GetWidget(n"buffsHolder");
    if IsDefined(bars) {
        if !IsDefined(this.m_ihGapBars) || this.m_ihGapBars != bars {
            this.m_ihGapBars = bars;
            this.m_ihGapBarsBase = bars.GetTranslation();
        }
        bars.SetTranslation(new Vector2(this.m_ihGapBarsBase.X, this.m_ihGapBarsBase.Y + gap));
    }

    let decoration = root.GetWidget(n"inkCanvasWidget5");
    if IsDefined(decoration) {
        if !IsDefined(this.m_ihGapDecoration) || this.m_ihGapDecoration != decoration {
            this.m_ihGapDecoration = decoration;
            this.m_ihGapDecorationBase = decoration.GetTranslation();
        }
        decoration.SetTranslation(new Vector2(this.m_ihGapDecorationBase.X, this.m_ihGapDecorationBase.Y + gap));
    }

    // Reserve bottom space if the original root has an explicit height.
    // Do not impose an arbitrary size on an auto-sized/zero-sized root.
    if !this.m_ihGapRootSizeCaptured {
        this.m_ihGapRootSize = root.GetSize();
        this.m_ihGapRootSizeCaptured = true;
    }
    if this.m_ihGapRootSize.Y > 0.0 {
        root.SetSize(new Vector2(this.m_ihGapRootSize.X, this.m_ihGapRootSize.Y + gap));
    }
}

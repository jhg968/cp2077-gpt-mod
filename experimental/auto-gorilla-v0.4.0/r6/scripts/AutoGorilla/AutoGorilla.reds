// Native-first prototype. Only auto-prepares Deflect; the game determines success.
public class AG4 extends IScriptable {
  public static func Now(p: ref<PlayerPuppet>) -> Float {
    return EngineTime.ToFloat(GameInstance.GetSimTime(p.GetGame()));
  }
  public static func Prepared(p: ref<PlayerPuppet>) -> Bool {
    let age: Float = AG4.Now(p) - p.ag4PreparedAt;
    return p.ag4Prepared && age >= 0.0 && age < 0.15
      && IsDefined(p.ag4PreparedWeapon) && p.ag4PreparedWeapon == GameObject.GetActiveWeapon(p);
  }
  public static func Candidate(si: ref<StateGameScriptInterface>, p: ref<PlayerPuppet>) -> Bool {
    let target: ref<NPCPuppet>;
    let object: ref<GameObject>;
    let angle: EulerAngles;
    let phase: gamedataNPCUpperBodyState;
    let weapon: ref<WeaponObject>;
    p.ag4Sensor = "no_front_target";
    object = si.GetTargetingSystem().GetObjectClosestToCrosshair(p, angle, TSQ_NPC());
    target = object as NPCPuppet;
    if !IsDefined(target) || !ScriptedPuppet.IsActive(target) { return false; };
    if Vector4.Distance(target.GetWorldPosition(), p.GetWorldPosition()) > 3.0 { return false; };
    if AbsF(angle.Yaw) > 60.0 || AbsF(angle.Pitch) > 60.0 { return false; };
    if !DamageManager.IsValidDirectionToDefendMeleeAttack(target.GetWorldForward(), p.GetWorldForward()) { return false; };
    phase = target.GetUpperBodyStateFromBlackboard();
    p.ag4Sensor = "front_target_phase=" + IntToString(EnumInt(phase));
    if NotEquals(phase, gamedataNPCUpperBodyState.Attack) && NotEquals(phase, gamedataNPCUpperBodyState.ChargedAttack) { return false; };
    weapon = GameObject.GetActiveWeapon(target);
    if IsDefined(weapon) && !weapon.IsMelee() { return false; };
    p.ag4Sensor = "front_melee_attack";
    return true;
  }
}
@addField(PlayerPuppet) public let ag4Sensor: String;
@addField(PlayerPuppet) public let ag4Ready: Bool;
@addField(PlayerPuppet) public let ag4Parry: Bool;
@addField(PlayerPuppet) public let ag4Counter: Bool;
@addField(PlayerPuppet) public let ag4Cost: Float;
@addField(PlayerPuppet) public let ag4Interval: Float;
@addField(PlayerPuppet) public let ag4Damage: Float;
@addField(PlayerPuppet) public let ag4Prepared: Bool;
@addField(PlayerPuppet) public let ag4PreparedAt: Float;
@addField(PlayerPuppet) public let ag4PreparedWeapon: wref<WeaponObject>;
@addField(PlayerPuppet) public let ag4DeflectOwned: Bool;
@addField(PlayerPuppet) public let ag4Success: Bool;
@addField(PlayerPuppet) public let ag4CounterArmed: Bool;
@addField(PlayerPuppet) public let ag4CounterActive: Bool;
@addField(PlayerPuppet) public let ag4CounterWeapon: wref<WeaponObject>;
@addField(PlayerPuppet) public let ag4DeflectCount: Int32;
@addField(PlayerPuppet) public let ag4ParryCount: Int32;
@addField(PlayerPuppet) public let ag4CounterCount: Int32;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  this.ag4Sensor = "not_checked";
  this.ag4Ready = false;
  this.ag4Prepared = false;
  this.ag4DeflectOwned = false;
  this.ag4Success = false;
  this.ag4CounterArmed = false;
  this.ag4CounterActive = false;
  this.ag4PreparedWeapon = null;
  this.ag4CounterWeapon = null;
  this.ag4DeflectCount = 0;
  this.ag4ParryCount = 0;
  this.ag4CounterCount = 0;
  return wrappedMethod();
}

@wrapMethod(MeleeDeflectDecisions)
protected final const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let manual: Bool = wrappedMethod(stateContext, scriptInterface);
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let weapon: ref<WeaponObject>;
  let bb: ref<IBlackboard>;
  if manual { if IsDefined(p) { p.ag4Prepared = false; }; return true; };
  if !IsDefined(p) || !p.ag4Ready || !p.ag4Parry { return false; };
  bb = p.GetPlayerStateMachineBlackboard();
  if bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon) != 2 { return false; };
  if this.ShouldInterruptHoldStates(stateContext, scriptInterface) { return false; };
  if stateContext.IsStateActive(n"Locomotion", n"dodge") || stateContext.IsStateActive(n"Locomotion", n"dodgeAir") { return false; };
  if GameInstance.GetBlackboardSystem(p.GetGame()).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.IsInMenu) { return false; };
  if GameObject.IsCooldownActive(p, n"AG4Attempt") || GameObject.IsCooldownActive(scriptInterface.owner, n"Deflect") { return false; };
  weapon = scriptInterface.owner as WeaponObject;
  if !IsDefined(weapon) || !weapon.WeaponHasTag(n"StrongArms") { return false; };
  if !this.CanWeaponDeflect(stateContext, scriptInterface) || this.HasMeleeTargeting(stateContext, scriptInterface) || this.GetStaticBoolParameterDefault("disabled", false) { return false; };
  if scriptInterface.GetStatPoolsSystem().GetStatPoolValue(Cast<StatsObjectID>(p.GetEntityID()), gamedataStatPoolType.Stamina, false) <= MaxF(0.0, p.ag4Cost) { return false; };
  if !AG4.Candidate(scriptInterface, p) { return false; };
  p.ag4Prepared = true;
  p.ag4PreparedAt = AG4.Now(p);
  p.ag4PreparedWeapon = weapon;
  return true;
}

@wrapMethod(MeleeDeflectEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let owned: Bool = IsDefined(p) && AG4.Prepared(p);
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) {
    p.ag4Prepared = false;
    p.ag4DeflectOwned = owned;
    p.ag4Success = false;
    p.ag4CounterArmed = false;
    if owned {
      p.ag4DeflectCount += 1;
      GameObject.StartCooldown(p, n"AG4Attempt", MaxF(0.3, MinF(10.0, p.ag4Interval)), true);
      AGNativeTrace.Push(p, "AUTO native Deflect entered BEFORE contact");
    };
  };
}

// Observe native success. Do not alter IsDeflecting or any hit flag/event.
@wrapMethod(DamageManager)
private final static func ProcessDefensiveState(hitEvent: ref<gameHitEvent>) -> Void {
  let p: ref<PlayerPuppet> = hitEvent.target as PlayerPuppet;
  wrappedMethod(hitEvent);
  if IsDefined(p) && p.ag4DeflectOwned && !p.ag4Success && hitEvent.attackData.WasDeflected() {
    p.ag4Success = true;
    p.ag4ParryCount += 1;
    PlayerStaminaHelpers.ModifyStamina(p, -MaxF(0.0, MinF(100.0, p.ag4Cost)));
    AGNativeTrace.Push(p, "AUTO native parry confirmed; original successfulDeflect preserved");
  };
}

// Separate counter switch; enabled mode follows the original return value.
@wrapMethod(MeleeDeflectDecisions)
protected final func ToMeleeDeflectAttack(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let result: Bool = wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) && p.ag4DeflectOwned && !p.ag4Counter { return false; };
  return result;
}

@wrapMethod(MeleeDeflectEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) {
    p.ag4CounterArmed = p.ag4DeflectOwned && p.ag4Success && p.ag4Counter;
    if p.ag4DeflectOwned && !p.ag4Success { AGNativeTrace.Push(p, "AUTO native window ended without parry"); };
  };
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { p.ag4DeflectOwned = false; };
}

@wrapMethod(MeleeDeflectAttackEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let owned: Bool = IsDefined(p) && p.ag4CounterArmed;
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) {
    p.ag4CounterArmed = false;
    p.ag4CounterActive = owned;
    if owned {
      p.ag4CounterWeapon = scriptInterface.owner as WeaponObject;
      p.ag4CounterCount += 1;
      AGNativeTrace.Push(p, "AUTO original counter entered");
    };
  };
}

@wrapMethod(MeleeDeflectAttackEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { p.ag4CounterActive = false; p.ag4CounterWeapon = null; };
}

@wrapMethod(MeleeAttackGenericEvents)
public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { p.ag4CounterActive = false; p.ag4CounterArmed = false; p.ag4CounterWeapon = null; };
}

@wrapMethod(DamageManager)
public final static func CalculateSourceModifiers(hitEvent: ref<gameHitEvent>) -> Void {
  let p: ref<PlayerPuppet> = hitEvent.attackData.GetInstigator() as PlayerPuppet;
  wrappedMethod(hitEvent);
  if IsDefined(p) && p.ag4CounterActive && IsDefined(p.ag4CounterWeapon)
    && p.ag4CounterWeapon == hitEvent.attackData.GetWeapon() && AttackData.IsMelee(hitEvent.attackData.GetAttackType()) {
    hitEvent.attackComputed.MultAttackValue(MaxF(0.0, MinF(5.0, p.ag4Damage)));
  };
}

@wrapMethod(MeleeEventsTransition)
public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) {
    p.ag4Prepared = false;
    p.ag4DeflectOwned = false;
    p.ag4CounterArmed = false;
    p.ag4CounterActive = false;
    p.ag4CounterWeapon = null;
  };
}

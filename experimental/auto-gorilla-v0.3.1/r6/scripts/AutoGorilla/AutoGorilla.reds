// Original experimental implementation. Game 2.5 script signatures checked.
public class AGConfig extends IScriptable {
  public static func Parry(p: ref<PlayerPuppet>) -> Bool { return p.agSettingsReady && p.agEnableParry; }
  public static func Counter(p: ref<PlayerPuppet>) -> Bool { return p.agSettingsReady && p.agEnableCounter; }
  public static func Cost(p: ref<PlayerPuppet>) -> Float { return MaxF(0.0, MinF(100.0, p.agCost)); }
  public static func Interval(p: ref<PlayerPuppet>) -> Float { return MaxF(0.3, MinF(10.0, p.agInterval)); }
  public static func Damage(p: ref<PlayerPuppet>) -> Float { return MaxF(0.0, MinF(5.0, p.agDamage)); }
  public static func Reason(hit: ref<gameHitEvent>, p: ref<PlayerPuppet>) -> String {
    let a: ref<AttackData> = hit.attackData;
    let weapon: ref<WeaponObject>;
    let npc: ref<NPCPuppet>;
    let record: ref<Attack_Melee_Record>;
    let stats: ref<StatsSystem>;
    let id: StatsObjectID;
    if !p.agSettingsReady { return "settings_not_ready"; };
    if !AGConfig.Parry(p) { return "parry_disabled"; };
    if !AttackData.IsMelee(a.GetAttackType()) { return "not_melee"; };
    if Equals(a.GetAttackType(), gamedataAttackType.QuickMelee) { return "quick_melee_excluded"; };
    if !AGConfig.Idle(p) { return "not_idle_or_dodging_or_menu"; };
    if p.agCounter { return "counter_in_progress"; };
    if GameObject.IsCooldownActive(p, n"AGParry") { return "cooldown"; };
    weapon = GameObject.GetActiveWeapon(p);
    if !IsDefined(weapon) { return "no_active_weapon"; };
    if !weapon.WeaponHasTag(n"StrongArms") { return "missing_StrongArms_tag"; };
    if GameObject.IsCooldownActive(weapon, n"Deflect") { return "native_deflect_cooldown"; };
    npc = a.GetInstigator() as NPCPuppet;
    if !IsDefined(npc) { return "attacker_not_NPC"; };
    if !IsDefined(a.GetAttackDefinition()) { return "no_attack_definition"; };
    record = a.GetAttackDefinition().GetRecord() as Attack_Melee_Record;
    if !IsDefined(record) { return "no_melee_record"; };
    if record.CanSkipBlock() { return "unblockable_record"; };
    if !DamageManager.IsValidDirectionToDefendMeleeAttack(npc.GetWorldForward(), p.GetWorldForward()) { return "outside_defend_angle"; };
    stats = GameInstance.GetStatsSystem(p.GetGame());
    id = Cast<StatsObjectID>(p.GetEntityID());
    if stats.GetStatValue(Cast<StatsObjectID>(weapon.GetEntityID()), gamedataStatType.CanWeaponDeflect) <= 0.0 { return "weapon_cannot_deflect"; };
    if stats.GetStatValue(id, gamedataStatType.IsDeflecting) != 0.0 { return "already_deflecting"; };
    if GameInstance.GetStatPoolsSystem(p.GetGame()).GetStatPoolValue(id, gamedataStatPoolType.Stamina, false) < AGConfig.Cost(p) { return "insufficient_stamina"; };
    return "eligible";
  }
  public static func WeaponDeflectStat(p: ref<PlayerPuppet>) -> Float {
    let weapon: ref<WeaponObject> = GameObject.GetActiveWeapon(p);
    if !IsDefined(weapon) { return -1.0; };
    return GameInstance.GetStatsSystem(p.GetGame()).GetStatValue(Cast<StatsObjectID>(weapon.GetEntityID()), gamedataStatType.CanWeaponDeflect);
  }
  public static func Stamina(p: ref<PlayerPuppet>) -> Float {
    return GameInstance.GetStatPoolsSystem(p.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(p.GetEntityID()), gamedataStatPoolType.Stamina, false);
  }
  public static func Now(p: ref<PlayerPuppet>) -> Float {
    return EngineTime.ToFloat(GameInstance.GetSimTime(p.GetGame()));
  }
  public static func Idle(p: ref<PlayerPuppet>) -> Bool {
    let bb: ref<IBlackboard> = p.GetPlayerStateMachineBlackboard();
    let d: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.LocomotionDetailed);
    return bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon) == 2
      && d != EnumInt(gamePSMDetailedLocomotionStates.Dodge)
      && d != EnumInt(gamePSMDetailedLocomotionStates.DodgeAir)
      && !GameInstance.GetBlackboardSystem(p.GetGame()).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.IsInMenu);
  }
  public static func Fresh(p: ref<PlayerPuppet>) -> Bool {
    let age: Float = AGConfig.Now(p) - p.agStamp;
    return age >= 0.0 && age < 0.8 && IsDefined(p.agWeapon)
      && p.agWeapon == GameObject.GetActiveWeapon(p);
  }
  public static func Pending(p: ref<PlayerPuppet>) -> Bool {
    let age: Float = AGConfig.Now(p) - p.agStamp;
    return AGConfig.Parry(p) && p.agPending && age >= 0.0 && age < 0.5
      && IsDefined(p.agWeapon) && p.agWeapon == GameObject.GetActiveWeapon(p);
  }
}
@addField(PlayerPuppet) public let agSettingsReady: Bool;
@addField(PlayerPuppet) public let agEnableParry: Bool;
@addField(PlayerPuppet) public let agEnableCounter: Bool;
@addField(PlayerPuppet) public let agCost: Float;
@addField(PlayerPuppet) public let agInterval: Float;
@addField(PlayerPuppet) public let agDamage: Float;
@addField(PlayerPuppet) public let agSeenHits: Int32;
@addField(PlayerPuppet) public let agReason: String;
@addField(PlayerPuppet) public let agEffects: Int32;
@addField(PlayerPuppet) public let agStaminaBefore: Float;
@addField(PlayerPuppet) public let agStaminaAfter: Float;
@addField(PlayerPuppet) public let agDeferSuccess: Bool;
@addField(PlayerPuppet) public let agAutoDeflect: Bool;
@addField(PlayerPuppet) public let agCounterArmed: Bool;
@addField(PlayerPuppet) public let agCounterWeapon: wref<WeaponObject>;
@addField(PlayerPuppet) public let agDeflects: Int32;
@addField(PlayerPuppet) public let agEffectAttempts: Int32;
@addField(PlayerPuppet) public let agOutgoing: Int32;
@addField(PlayerPuppet) public let agRoute: String;
@addField(PlayerPuppet) public let agCounterChecks: Int32;
@addField(PlayerPuppet) public let agPending: Bool;
@addField(PlayerPuppet) public let agCounter: Bool;
@addField(PlayerPuppet) public let agStamp: Float;
@addField(PlayerPuppet) public let agWeapon: wref<WeaponObject>;
@addField(PlayerPuppet) public let agParries: Int32;
@addField(PlayerPuppet) public let agCounters: Int32;
@addField(PlayerPuppet) public let agHits: Int32;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  this.agRoute = "idle";
  this.agCounterChecks = 0;
  this.agDeferSuccess = false;
  this.agAutoDeflect = false;
  this.agCounterArmed = false;
  this.agCounterWeapon = null;
  this.agDeflects = 0;
  this.agEffectAttempts = 0;
  this.agOutgoing = 0;
  this.agEffects = 0;
  this.agSeenHits = 0;
  this.agReason = "no_defensive_hit_seen";
  this.agSettingsReady = false;
  this.agPending = false;
  this.agCounter = false;
  this.agWeapon = null;
  this.agParries = 0;
  this.agCounters = 0;
  this.agHits = 0;
  return wrappedMethod();
}

@wrapMethod(DamageManager)
private final static func ProcessDefensiveState(hitEvent: ref<gameHitEvent>) -> Void {
  let p: ref<PlayerPuppet> = hitEvent.target as PlayerPuppet;
  let a: ref<AttackData> = hitEvent.attackData;
  let stats: ref<StatsSystem>;
  let id: StatsObjectID;
  let weapon: ref<WeaponObject>;
  let modifier: ref<gameStatModifierData>;
  if !IsDefined(p) { wrappedMethod(hitEvent); return; };
  p.agSeenHits += 1;
  p.agReason = AGConfig.Reason(hitEvent, p);
  if NotEquals(p.agReason, "eligible") { wrappedMethod(hitEvent); return; };
  weapon = GameObject.GetActiveWeapon(p);
  stats = GameInstance.GetStatsSystem(p.GetGame());
  id = Cast<StatsObjectID>(p.GetEntityID());
  // Scoped modifier: never left on the player between hits/frames.
  modifier = RPGManager.CreateStatModifier(gamedataStatType.IsDeflecting, gameStatModifierType.Additive, 1.0);
  stats.AddModifier(id, modifier);
  p.agDeferSuccess = true;
  wrappedMethod(hitEvent);
  p.agDeferSuccess = false;
  stats.RemoveModifier(id, modifier);
  p.agReason = a.WasDeflected() ? "parry_confirmed" : "native_did_not_deflect";
  if a.WasDeflected() {
    p.agWeapon = weapon;
    p.agStamp = AGConfig.Now(p);
    p.agPending = true;
    p.agParries += 1;
    p.agStaminaBefore = AGConfig.Stamina(p);
    PlayerStaminaHelpers.ModifyStamina(p, -MaxF(0.0, AGConfig.Cost(p)));
    p.agStaminaAfter = AGConfig.Stamina(p);
    GameObject.StartCooldown(p, n"AGParry", MaxF(0.3, AGConfig.Interval(p)), true);
  };
}

@wrapMethod(MeleeDeflectDecisions)
protected final const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) && AGConfig.Pending(p) && AGConfig.Idle(p) && this.CanWeaponDeflect(stateContext, scriptInterface)
    && !this.HasMeleeTargeting(stateContext, scriptInterface) && !this.GetStaticBoolParameterDefault("disabled", false)
    && !GameObject.IsCooldownActive(scriptInterface.owner, n"Deflect") { return true; };
  return wrappedMethod(stateContext, scriptInterface);
}

// Keep the successful hit's event from racing the requested Deflect entry.
// Manual/native parries outside our scoped defensive calculation remain untouched.
@wrapMethod(DamageManager)
protected final static func SendNameEventToPSM(eventName: CName, hitEvent: ref<gameHitEvent>) -> Void {
  let p: ref<PlayerPuppet> = hitEvent.target as PlayerPuppet;
  if IsDefined(p) && p.agDeferSuccess && Equals(eventName, n"successfulDeflect") { return; };
  wrappedMethod(eventName, hitEvent);
}

@wrapMethod(MeleeDeflectEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let auto: Bool = IsDefined(p) && AGConfig.Pending(p);
  wrappedMethod(stateContext, scriptInterface);
  if auto {
    p.agPending = false;
    p.agAutoDeflect = true;
    p.agCounterArmed = AGConfig.Counter(p);
    p.agDeflects += 1;
    p.agRoute = "deflect_entered";
  };
}

// Guard the actual outgoing state-machine edges rather than only its helper.
@wrapMethod(MeleeDeflectDecisions)
protected final const func ExitCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) && p.agAutoDeflect && p.agCounterArmed && AGConfig.Counter(p) && AGConfig.Fresh(p) {
    if this.ShouldInterruptHoldStates(stateContext, scriptInterface) {
      p.agRoute = "native_interrupt";
      return wrappedMethod(stateContext, scriptInterface);
    };
    p.agRoute = this.GetInStateTime() >= 0.12 ? "counter_ready" : "deflect_wait";
    return this.GetInStateTime() >= 0.12;
  };
  return wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(MeleeDeflectDecisions)
public final func ToMeleeBlock(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) && p.agAutoDeflect && p.agCounterArmed && AGConfig.Counter(p) && AGConfig.Fresh(p)
    && !this.ShouldInterruptHoldStates(stateContext, scriptInterface) { return false; };
  return wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(MeleeDeflectDecisions)
protected final func ToMeleeDeflectAttack(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) && p.agAutoDeflect && p.agCounterArmed && AGConfig.Counter(p) && AGConfig.Fresh(p)
    && !this.ShouldInterruptHoldStates(stateContext, scriptInterface) {
    return this.GetInStateTime() >= 0.12;
  };
  return wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(MeleeDeflectAttackDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let allowed: Bool = wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) && p.agAutoDeflect && p.agCounterArmed {
    p.agCounterChecks += 1;
    if !allowed { p.agCounterArmed = false; p.agRoute = "no_counter_attack_record"; };
  };
  return allowed;
}

@wrapMethod(MeleeDeflectEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { p.agAutoDeflect = false; };
}

@wrapMethod(MeleeDeflectAttackEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let owned: Bool = IsDefined(p) && p.agCounterArmed && AGConfig.Counter(p) && AGConfig.Fresh(p);
  wrappedMethod(stateContext, scriptInterface);
  if owned {
    p.agCounterArmed = false;
    p.agCounter = true;
    p.agCounterWeapon = scriptInterface.owner as WeaponObject;
    p.agCounters += 1;
    p.agRoute = "counter_entered";
  };
}

@wrapMethod(MeleeDeflectAttackEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { p.agCounter = false; p.agCounterWeapon = null; };
}

@wrapMethod(MeleeAttackGenericEvents)
public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { p.agCounter = false; p.agPending = false; p.agAutoDeflect = false; p.agCounterArmed = false; p.agCounterWeapon = null; };
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(DamageManager)
public final static func CalculateSourceModifiers(hitEvent: ref<gameHitEvent>) -> Void {
  let p: ref<PlayerPuppet> = hitEvent.attackData.GetInstigator() as PlayerPuppet;
  wrappedMethod(hitEvent);
  if IsDefined(p) && p.agCounter && AttackData.IsMelee(hitEvent.attackData.GetAttackType()) {
    p.agOutgoing += 1;
  };
  if IsDefined(p) && p.agCounter && IsDefined(p.agCounterWeapon) && p.agCounterWeapon == hitEvent.attackData.GetWeapon()
    && AttackData.IsMelee(hitEvent.attackData.GetAttackType()) {
    hitEvent.attackComputed.MultAttackValue(MaxF(0.0, AGConfig.Damage(p)));
    p.agHits += 1;
  };
}

// Measures the real game's attack start independently of final damage handling.
@wrapMethod(MeleeAttackGenericEvents)
protected final func SpawnAttackGameEffect(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, startPosition: Vector4, middlePosition: Vector4, endPosition: Vector4, time: Float, colliderBox: Vector4, attackData: ref<MeleeAttackData>) -> Bool {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let started: Bool = wrappedMethod(stateContext, scriptInterface, startPosition, middlePosition, endPosition, time, colliderBox, attackData);
  if IsDefined(p) && p.agCounter && p.agCounterWeapon == (scriptInterface.owner as WeaponObject) {
    p.agEffectAttempts += 1;
    if started { p.agEffects += 1; };
  };
  return started;
}

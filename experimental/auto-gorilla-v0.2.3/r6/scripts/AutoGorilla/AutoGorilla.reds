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
  public static func Pending(p: ref<PlayerPuppet>) -> Bool {
    let age: Float = AGConfig.Now(p) - p.agStamp;
    return AGConfig.Counter(p) && p.agPending && age >= 0.0 && age < 0.5
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
@addField(PlayerPuppet) public let agPending: Bool;
@addField(PlayerPuppet) public let agCounter: Bool;
@addField(PlayerPuppet) public let agStamp: Float;
@addField(PlayerPuppet) public let agWeapon: wref<WeaponObject>;
@addField(PlayerPuppet) public let agParries: Int32;
@addField(PlayerPuppet) public let agCounters: Int32;
@addField(PlayerPuppet) public let agHits: Int32;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
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
  wrappedMethod(hitEvent);
  stats.RemoveModifier(id, modifier);
  p.agReason = a.WasDeflected() ? "parry_confirmed" : "native_did_not_deflect";
  if a.WasDeflected() {
    p.agWeapon = weapon;
    p.agStamp = AGConfig.Now(p);
    p.agPending = AGConfig.Counter(p);
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

@wrapMethod(MeleeDeflectEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let auto: Bool = IsDefined(p) && AGConfig.Pending(p);
  wrappedMethod(stateContext, scriptInterface);
  if auto {
    p.agPending = false;
    p.agCounter = true;
    stateContext.SetTemporaryBoolParameter(n"successfulDeflect", true, true);
  };
}

@wrapMethod(MeleeDeflectAttackEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) && p.agCounter { p.agCounters += 1; };
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(MeleeDeflectAttackEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { p.agCounter = false; };
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(MeleeAttackGenericEvents)
public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { p.agCounter = false; p.agPending = false; };
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(DamageManager)
public final static func CalculateSourceModifiers(hitEvent: ref<gameHitEvent>) -> Void {
  let p: ref<PlayerPuppet> = hitEvent.attackData.GetInstigator() as PlayerPuppet;
  wrappedMethod(hitEvent);
  if IsDefined(p) && p.agCounter && p.agWeapon == hitEvent.attackData.GetWeapon()
    && AttackData.IsMelee(hitEvent.attackData.GetAttackType())
    && p.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon) == 20 {
    hitEvent.attackComputed.MultAttackValue(MaxF(0.0, AGConfig.Damage(p)));
    p.agHits += 1;
  };
}

// Measures the real game's attack start independently of final damage handling.
@wrapMethod(MeleeAttackGenericEvents)
protected final func SpawnAttackGameEffect(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, startPosition: Vector4, middlePosition: Vector4, endPosition: Vector4, time: Float, colliderBox: Vector4, attackData: ref<MeleeAttackData>) -> Bool {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let started: Bool = wrappedMethod(stateContext, scriptInterface, startPosition, middlePosition, endPosition, time, colliderBox, attackData);
  if started && IsDefined(p) && p.agCounter && p.agWeapon == (scriptInterface.owner as WeaponObject) {
    p.agEffects += 1;
  };
  return started;
}

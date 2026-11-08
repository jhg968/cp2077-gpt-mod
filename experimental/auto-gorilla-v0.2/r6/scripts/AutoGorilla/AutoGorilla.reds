// Original experimental implementation. Game 2.5 script signatures checked.
public class AGConfig extends IScriptable {
  public static func Parry(p: ref<PlayerPuppet>) -> Bool { return p.agSettingsReady && p.agEnableParry; }
  public static func Counter(p: ref<PlayerPuppet>) -> Bool { return p.agSettingsReady && p.agEnableCounter; }
  public static func Cost(p: ref<PlayerPuppet>) -> Float { return MaxF(0.0, MinF(100.0, p.agCost)); }
  public static func Interval(p: ref<PlayerPuppet>) -> Float { return MaxF(0.3, MinF(10.0, p.agInterval)); }
  public static func Damage(p: ref<PlayerPuppet>) -> Float { return MaxF(0.0, MinF(5.0, p.agDamage)); }
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
    return AGConfig.Counter(p) && p.agPending && age >= 0.0 && age < 0.2
      && IsDefined(p.agWeapon) && p.agWeapon == GameObject.GetActiveWeapon(p) && AGConfig.Idle(p);
  }
}
@addField(PlayerPuppet) public let agSettingsReady: Bool;
@addField(PlayerPuppet) public let agEnableParry: Bool;
@addField(PlayerPuppet) public let agEnableCounter: Bool;
@addField(PlayerPuppet) public let agCost: Float;
@addField(PlayerPuppet) public let agInterval: Float;
@addField(PlayerPuppet) public let agDamage: Float;
@addField(PlayerPuppet) public let agPending: Bool;
@addField(PlayerPuppet) public let agCounter: Bool;
@addField(PlayerPuppet) public let agStamp: Float;
@addField(PlayerPuppet) public let agWeapon: wref<WeaponObject>;
@addField(PlayerPuppet) public let agParries: Int32;
@addField(PlayerPuppet) public let agCounters: Int32;
@addField(PlayerPuppet) public let agHits: Int32;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
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
  let npc: ref<NPCPuppet>;
  let weapon: ref<WeaponObject>;
  let record: ref<Attack_Melee_Record>;
  let stats: ref<StatsSystem>;
  let id: StatsObjectID;
  let modifier: ref<gameStatModifierData>;
  let eligible: Bool = false;
  if IsDefined(p) && AGConfig.Parry(p) && AGConfig.Idle(p) && !p.agCounter && !GameObject.IsCooldownActive(p, n"AGParry") {
    weapon = GameObject.GetActiveWeapon(p);
    npc = a.GetInstigator() as NPCPuppet;
    record = a.GetAttackDefinition().GetRecord() as Attack_Melee_Record;
    if IsDefined(weapon) && weapon.WeaponHasTag(n"StrongArms") && IsDefined(npc) && IsDefined(record) {
      stats = GameInstance.GetStatsSystem(p.GetGame());
      id = Cast<StatsObjectID>(p.GetEntityID());
      eligible = AttackData.IsMelee(a.GetAttackType()) && NotEquals(a.GetAttackType(), gamedataAttackType.QuickMelee)
        && Equals(GameObject.GetAttitudeTowards(npc, p), EAIAttitude.AIA_Hostile)
        && !record.CanSkipBlock() && NotEquals(npc.GetNPCRarity(), gamedataNPCRarity.Boss)
        && NotEquals(npc.GetNPCRarity(), gamedataNPCRarity.MaxTac)
        && DamageManager.IsValidDirectionToDefendMeleeAttack(npc.GetWorldForward(), p.GetWorldForward())
        && stats.GetStatValue(Cast<StatsObjectID>(weapon.GetEntityID()), gamedataStatType.CanWeaponDeflect) > 0.0
        && stats.GetStatValue(id, gamedataStatType.IsDeflecting) == 0.0
        && GameInstance.GetStatPoolsSystem(p.GetGame()).GetStatPoolValue(id, gamedataStatPoolType.Stamina, false) >= MaxF(0.0, AGConfig.Cost(p));
    };
  };
  if !eligible { wrappedMethod(hitEvent); return; };
  // Scoped modifier: never left on the player between hits/frames.
  modifier = RPGManager.CreateStatModifier(gamedataStatType.IsDeflecting, gameStatModifierType.Additive, 1.0);
  stats.AddModifier(id, modifier);
  wrappedMethod(hitEvent);
  stats.RemoveModifier(id, modifier);
  if a.WasDeflected() {
    p.agWeapon = weapon;
    p.agStamp = AGConfig.Now(p);
    p.agPending = AGConfig.Counter(p);
    p.agParries += 1;
    PlayerStaminaHelpers.ModifyStamina(p, -MaxF(0.0, AGConfig.Cost(p)));
    GameObject.StartCooldown(p, n"AGParry", MaxF(0.3, AGConfig.Interval(p)), true);
  };
}

@wrapMethod(MeleeDeflectDecisions)
protected final const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) && AGConfig.Pending(p) && this.CanWeaponDeflect(stateContext, scriptInterface)
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

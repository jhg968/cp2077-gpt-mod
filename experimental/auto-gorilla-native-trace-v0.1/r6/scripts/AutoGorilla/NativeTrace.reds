// Native-only trace: no stat modifiers, hit flags, input injection or transition overrides.
public class AGNativeTrace extends IScriptable {
  public static func B(value: Bool) -> String { return value ? "1" : "0"; }
  public static func Snapshot(p: ref<PlayerPuppet>) -> String {
    let bb: ref<IBlackboard> = p.GetPlayerStateMachineBlackboard();
    let stats: ref<StatsSystem> = GameInstance.GetStatsSystem(p.GetGame());
    let id: StatsObjectID = Cast<StatsObjectID>(p.GetEntityID());
    return " upper=" + IntToString(bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody))
      + " melee=" + IntToString(bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon))
      + " deflectStat=" + FloatToString(stats.GetStatValue(id, gamedataStatType.IsDeflecting))
      + " blockStat=" + FloatToString(stats.GetStatValue(id, gamedataStatType.IsBlocking))
      + " stamina=" + FloatToString(GameInstance.GetStatPoolsSystem(p.GetGame()).GetStatPoolValue(id, gamedataStatPoolType.Stamina, false));
  }
  public static func Detail(context: ref<StateContext>, si: ref<StateGameScriptInterface>) -> String {
    let success: StateResultBool = context.GetTemporaryBoolParameter(n"successfulDeflect");
    let interrupt: StateResultBool = context.GetPermanentBoolParameter(n"InterruptMelee");
    return " press=" + AGNativeTrace.B(si.IsActionJustPressed(n"MeleeBlock"))
      + " value=" + FloatToString(si.GetActionValue(n"MeleeBlock"))
      + " successValid=" + AGNativeTrace.B(success.valid)
      + " successValue=" + AGNativeTrace.B(success.value)
      + " interrupt=" + AGNativeTrace.B(interrupt.valid && interrupt.value);
  }
  public static func Push(p: ref<PlayerPuppet>, message: String) -> Void {
    if !IsDefined(p) || !p.agNEnabled { return; };
    if ArraySize(p.agNLines) >= 512 { p.agNDropped += 1; return; };
    ArrayPush(p.agNLines, "t=" + FloatToString(EngineTime.ToFloat(GameInstance.GetSimTime(p.GetGame()))) + " " + message + AGNativeTrace.Snapshot(p));
  }
  public static func Drain(p: ref<PlayerPuppet>) -> array<String> {
    let lines: array<String> = p.agNLines;
    ArrayClear(p.agNLines);
    return lines;
  }
}
@addField(PlayerPuppet) public let agNEnabled: Bool;
@addField(PlayerPuppet) public let agNLines: array<String>;
@addField(PlayerPuppet) public let agNDropped: Int32;
@addField(PlayerPuppet) public let agNDecision0: String;
@addField(PlayerPuppet) public let agNDecision1: String;
@addField(PlayerPuppet) public let agNDecision2: String;
@addField(PlayerPuppet) public let agNDecision3: String;
@addField(PlayerPuppet) public let agNDecision4: String;
@addField(PlayerPuppet) public let agNDecision5: String;
@addField(PlayerPuppet) public let agNDecision6: String;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  this.agNEnabled = false;
  ArrayClear(this.agNLines);
  this.agNDropped = 0;
  this.agNDecision0 = "";
  this.agNDecision1 = "";
  this.agNDecision2 = "";
  this.agNDecision3 = "";
  this.agNDecision4 = "";
  this.agNDecision5 = "";
  this.agNDecision6 = "";
  return wrappedMethod();
}

@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let name: CName = ListenerAction.GetName(action);
  if Equals(name, n"MeleeBlock") || Equals(name, n"MeleeLightAttack") || Equals(name, n"MeleeStrongAttack") {
    AGNativeTrace.Push(this, "input " + NameToString(name) + " type=" + IntToString(EnumInt(ListenerAction.GetType(action))));
  };
  return wrappedMethod(action, consumer);
}
@wrapMethod(PlayerPuppet)
protected cb func OnMeleeWeaponStateChange(newState: Int32) -> Bool {
  AGNativeTrace.Push(this, "state_change to=" + IntToString(newState));
  return wrappedMethod(newState);
}

@wrapMethod(MeleeDeflectDecisions)
protected final const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let result: Bool = wrappedMethod(stateContext, scriptInterface);
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let line: String;
  if IsDefined(p) && p.agNEnabled {
    line = "MeleeDeflectDecisions.EnterCondition result=" + AGNativeTrace.B(result) + AGNativeTrace.Detail(stateContext, scriptInterface)
      + " upper=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody))
      + " melee=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));
    if NotEquals(line, p.agNDecision0) { p.agNDecision0 = line; AGNativeTrace.Push(p, line); };
  };
  return result;
}

@wrapMethod(MeleeDeflectDecisions)
protected final const func ExitCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let result: Bool = wrappedMethod(stateContext, scriptInterface);
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let line: String;
  if IsDefined(p) && p.agNEnabled {
    line = "MeleeDeflectDecisions.ExitCondition result=" + AGNativeTrace.B(result) + AGNativeTrace.Detail(stateContext, scriptInterface)
      + " upper=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody))
      + " melee=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));
    if NotEquals(line, p.agNDecision1) { p.agNDecision1 = line; AGNativeTrace.Push(p, line); };
  };
  return result;
}

@wrapMethod(MeleeDeflectDecisions)
public final func ToMeleeBlock(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let result: Bool = wrappedMethod(stateContext, scriptInterface);
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let line: String;
  if IsDefined(p) && p.agNEnabled {
    line = "MeleeDeflectDecisions.ToMeleeBlock result=" + AGNativeTrace.B(result) + AGNativeTrace.Detail(stateContext, scriptInterface)
      + " upper=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody))
      + " melee=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));
    if NotEquals(line, p.agNDecision2) { p.agNDecision2 = line; AGNativeTrace.Push(p, line); };
  };
  return result;
}

@wrapMethod(MeleeDeflectDecisions)
protected final func ToMeleeDeflectAttack(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let result: Bool = wrappedMethod(stateContext, scriptInterface);
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let line: String;
  if IsDefined(p) && p.agNEnabled {
    line = "MeleeDeflectDecisions.ToMeleeDeflectAttack result=" + AGNativeTrace.B(result) + AGNativeTrace.Detail(stateContext, scriptInterface)
      + " upper=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody))
      + " melee=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));
    if NotEquals(line, p.agNDecision3) { p.agNDecision3 = line; AGNativeTrace.Push(p, line); };
  };
  return result;
}

@wrapMethod(MeleeDeflectDecisions)
protected final const func IsDeflectSuccessful(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let result: Bool = wrappedMethod(stateContext, scriptInterface);
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let line: String;
  if IsDefined(p) && p.agNEnabled {
    line = "MeleeDeflectDecisions.IsDeflectSuccessful result=" + AGNativeTrace.B(result) + AGNativeTrace.Detail(stateContext, scriptInterface)
      + " upper=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody))
      + " melee=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));
    if NotEquals(line, p.agNDecision4) { p.agNDecision4 = line; AGNativeTrace.Push(p, line); };
  };
  return result;
}

@wrapMethod(MeleeDeflectAttackDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let result: Bool = wrappedMethod(stateContext, scriptInterface);
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let line: String;
  if IsDefined(p) && p.agNEnabled {
    line = "MeleeDeflectAttackDecisions.EnterCondition result=" + AGNativeTrace.B(result) + AGNativeTrace.Detail(stateContext, scriptInterface)
      + " upper=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody))
      + " melee=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));
    if NotEquals(line, p.agNDecision5) { p.agNDecision5 = line; AGNativeTrace.Push(p, line); };
  };
  return result;
}

@wrapMethod(MeleeBlockAttackDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let result: Bool = wrappedMethod(stateContext, scriptInterface);
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let line: String;
  if IsDefined(p) && p.agNEnabled {
    line = "MeleeBlockAttackDecisions.EnterCondition result=" + AGNativeTrace.B(result) + AGNativeTrace.Detail(stateContext, scriptInterface)
      + " upper=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody))
      + " melee=" + IntToString(scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));
    if NotEquals(line, p.agNDecision6) { p.agNDecision6 = line; AGNativeTrace.Push(p, line); };
  };
  return result;
}

@wrapMethod(MeleeDeflectEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeDeflectEvents.OnEnter BEFORE" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeDeflectEvents.OnEnter AFTER" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
}

@wrapMethod(MeleeDeflectEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeDeflectEvents.OnExit BEFORE" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeDeflectEvents.OnExit AFTER" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
}

@wrapMethod(MeleeDeflectAttackEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeDeflectAttackEvents.OnEnter BEFORE" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeDeflectAttackEvents.OnEnter AFTER" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
}

@wrapMethod(MeleeDeflectAttackEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeDeflectAttackEvents.OnExit BEFORE" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeDeflectAttackEvents.OnExit AFTER" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
}

@wrapMethod(MeleeBlockEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeBlockEvents.OnEnter BEFORE" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeBlockEvents.OnEnter AFTER" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
}

@wrapMethod(MeleeBlockEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeBlockEvents.OnExit BEFORE" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeBlockEvents.OnExit AFTER" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
}

@wrapMethod(MeleeBlockAttackEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeBlockAttackEvents.OnEnter BEFORE" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeBlockAttackEvents.OnEnter AFTER" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
}

@wrapMethod(MeleeBlockAttackEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeBlockAttackEvents.OnExit BEFORE" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeBlockAttackEvents.OnExit AFTER" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
}

@wrapMethod(MeleeAttackGenericEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeAttackGenericEvents.OnEnter BEFORE" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeAttackGenericEvents.OnEnter AFTER" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
}

@wrapMethod(MeleeAttackGenericEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeAttackGenericEvents.OnExit BEFORE" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(p) { AGNativeTrace.Push(p, "MeleeAttackGenericEvents.OnExit AFTER" + AGNativeTrace.Detail(stateContext, scriptInterface)); };
}

@wrapMethod(MeleeAttackGenericEvents)
public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  AGNativeTrace.Push(scriptInterface.executionOwner as PlayerPuppet, "MeleeAttackGenericEvents.OnForcedExit" + AGNativeTrace.Detail(stateContext, scriptInterface));
  wrappedMethod(stateContext, scriptInterface);
}
@wrapMethod(MeleeTransition)
protected final const func GetAttackDataFromCurrentState(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, attackNumber: Int32, out outgoingStruct: ref<MeleeAttackData>) -> Bool {
  let result: Bool = wrappedMethod(stateContext, scriptInterface, attackNumber, outgoingStruct);
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let line: String = "attack_data state=" + this.m_stateNameString + " number=" + IntToString(attackNumber) + " found=" + AGNativeTrace.B(result);
  if result && IsDefined(outgoingStruct) {
    line += " effectDelay=" + FloatToString(outgoingStruct.attackEffectDelay) + " effectDuration=" + FloatToString(outgoingStruct.attackEffectDuration)
      + " staminaCost=" + FloatToString(outgoingStruct.staminaCost);
  };
  AGNativeTrace.Push(p, line);
  return result;
}
@wrapMethod(MeleeAttackGenericEvents)
protected final func SpawnAttackGameEffect(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, startPosition: Vector4, middlePosition: Vector4, endPosition: Vector4, time: Float, colliderBox: Vector4, attackData: ref<MeleeAttackData>) -> Bool {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let started: Bool;
  let same: Bool = IsDefined(p) && GameObject.GetActiveWeapon(p) == (scriptInterface.owner as WeaponObject);
  AGNativeTrace.Push(p, "SpawnAttackGameEffect BEFORE ownerEqualsActive=" + AGNativeTrace.B(same));
  started = wrappedMethod(stateContext, scriptInterface, startPosition, middlePosition, endPosition, time, colliderBox, attackData);
  AGNativeTrace.Push(p, "SpawnAttackGameEffect AFTER started=" + AGNativeTrace.B(started));
  return started;
}
@wrapMethod(DamageManager)
private final static func ProcessDefensiveState(hitEvent: ref<gameHitEvent>) -> Void {
  let p: ref<PlayerPuppet> = hitEvent.target as PlayerPuppet;
  AGNativeTrace.Push(p, "defensive BEFORE attackType=" + IntToString(EnumInt(hitEvent.attackData.GetAttackType())));
  wrappedMethod(hitEvent);
  AGNativeTrace.Push(p, "defensive AFTER parried=" + AGNativeTrace.B(hitEvent.attackData.WasDeflected()) + " blocked=" + AGNativeTrace.B(hitEvent.attackData.WasBlocked()));
}
@wrapMethod(DamageManager)
protected final static func SendNameEventToPSM(eventName: CName, hitEvent: ref<gameHitEvent>) -> Void {
  AGNativeTrace.Push(hitEvent.target as PlayerPuppet, "SendNameEventToPSM " + NameToString(eventName));
  wrappedMethod(eventName, hitEvent);
}
@wrapMethod(DamageSystem)
private final func DealDamages(hitEvent: ref<gameHitEvent>) -> Void {
  let p: ref<PlayerPuppet> = hitEvent.attackData.GetInstigator() as PlayerPuppet;
  let before: Float;
  let after: Float;
  let stats: ref<StatPoolsSystem>;
  let id: StatsObjectID;
  let trace: Bool = IsDefined(p) && p.agNEnabled && IsDefined(hitEvent.target as ScriptedPuppet) && AttackData.IsMelee(hitEvent.attackData.GetAttackType());
  if trace {
    stats = GameInstance.GetStatPoolsSystem(p.GetGame());
    id = Cast<StatsObjectID>(hitEvent.target.GetEntityID());
    before = stats.GetStatPoolValue(id, gamedataStatPoolType.Health, false);
    AGNativeTrace.Push(p, "DealDamages BEFORE computedHealthDamage=" + FloatToString(hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health)));
  };
  wrappedMethod(hitEvent);
  if trace {
    after = stats.GetStatPoolValue(id, gamedataStatPoolType.Health, false);
    AGNativeTrace.Push(p, "DealDamages AFTER targetHealth=" + FloatToString(before) + "->" + FloatToString(after));
  };
}

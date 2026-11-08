@addField(NPCPuppet) public let ag47Valid: Bool;
@addField(NPCPuppet) public let ag47Seq: Int32;
@addField(NPCPuppet) public let ag47At: Float;
@addField(NPCPuppet) public let ag47Remaining: Float;
@addField(NPCPuppet) public let ag47AttackTime: Float;
@addField(NPCPuppet) public let ag47Duration: Float;
@addField(NPCPuppet) public let ag47Record: TweakDBID;
@addField(NPCPuppet) public let ag47Logged: Int32;
@addField(PlayerPuppet) public let ag47Precise: Bool;
public class AG47 extends IScriptable {
  public static func Observe(context: ScriptExecutionContext, record: wref<AISubActionAttackWithWeapon_Record>, duration: Float, fire: Bool) -> Void {
    let npc: ref<NPCPuppet> = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
    let weapon: wref<WeaponObject>;
    let attackRecord: wref<Attack_Record>;
    if !IsDefined(npc) { return; };
    if !AISubActionAttackWithWeapon_Record_Implementation.GetWeapon(context, record, weapon) { return; };
    if !IsDefined(weapon) || !weapon.IsMelee() { return; };
    attackRecord = record.Attack();
    if !IsDefined(attackRecord) && IsDefined(weapon.GetCurrentAttack()) { attackRecord = weapon.GetCurrentAttack().GetRecord(); };
    if !IsDefined(attackRecord) || !AttackData.IsMelee(attackRecord.AttackType().Type()) { return; };
    npc.ag47Valid = true;
    npc.ag47At = EngineTime.ToFloat(GameInstance.GetSimTime(npc.GetGame()));
    npc.ag47AttackTime = record.AttackTime();
    npc.ag47Duration = duration;
    npc.ag47Record = attackRecord.GetID();
    npc.ag47Remaining = fire ? 0.0 : record.AttackTime() - duration;
  }
  public static func Remaining(npc: ref<NPCPuppet>, p: ref<PlayerPuppet>) -> Float {
    return npc.ag47Remaining - (AG4.Now(p) - npc.ag47At);
  }
  public static func Note(npc: ref<NPCPuppet>, p: ref<PlayerPuppet>, contact: Bool) -> Void {
    if !IsDefined(npc) || !IsDefined(p) || !p.agNEnabled { return; };
    if !npc.ag47Valid {
      if contact { AGNativeTrace.Push(p, "SWING contact no_valid_attack_schedule npc=" + EntityID.ToDebugString(npc.GetEntityID())); };
      return;
    };
    if !contact && npc.ag47Logged == npc.ag47Seq { return; };
    npc.ag47Logged = npc.ag47Seq;
    AGNativeTrace.Push(p, "SWING npc=" + EntityID.ToDebugString(npc.GetEntityID()) + " seq=" + IntToString(npc.ag47Seq)
      + " contact=" + AGNativeTrace.B(contact) + " remaining=" + FloatToString(AG47.Remaining(npc,p))
      + " attackTime=" + FloatToString(npc.ag47AttackTime) + " duration=" + FloatToString(npc.ag47Duration)
      + " record=" + TDBID.ToStringDEBUG(npc.ag47Record));
  }
}
@wrapMethod(AISubActionAttackWithWeapon_Record_Implementation)
public final static func Activate(context: ScriptExecutionContext, record: wref<AISubActionAttackWithWeapon_Record>) -> Void {
  let npc: ref<NPCPuppet> = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
  if IsDefined(npc) { npc.ag47Seq += 1; npc.ag47Valid = false; };
  AG47.Observe(context, record, 0.0, record.AttackTime() == 0.0);
  wrappedMethod(context, record);
}
@wrapMethod(AISubActionAttackWithWeapon_Record_Implementation)
public final static func Update(context: ScriptExecutionContext, record: wref<AISubActionAttackWithWeapon_Record>, const duration: Float) -> AIbehaviorUpdateOutcome {
  if record.AttackTime() > 0.0 { AG47.Observe(context, record, duration, false); };
  return wrappedMethod(context, record, duration);
}
@wrapMethod(AISubActionAttackWithWeapon_Record_Implementation)
public final static func AttackWithWeapon(context: ScriptExecutionContext, record: wref<AISubActionAttackWithWeapon_Record>) -> AIbehaviorUpdateOutcome {
  let result: AIbehaviorUpdateOutcome;
  let npc: ref<NPCPuppet> = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
  AG47.Observe(context, record, record.AttackTime(), true);
  result = wrappedMethod(context, record);
  if IsDefined(npc) && Equals(result, AIbehaviorUpdateOutcome.FAILURE) { npc.ag47Valid = false; };
  return result;
}
@wrapMethod(AISubActionAttackWithWeapon_Record_Implementation)
public final static func Deactivate(context: ScriptExecutionContext, record: wref<AISubActionAttackWithWeapon_Record>, const duration: Float, interrupted: Bool) -> Void {
  let npc: ref<NPCPuppet> = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
  wrappedMethod(context, record, duration, interrupted);
  if interrupted && IsDefined(npc) { npc.ag47Valid = false; };
}
@wrapMethod(DamageManager)
private final static func ProcessDefensiveState(hitEvent: ref<gameHitEvent>) -> Void {
  let p: ref<PlayerPuppet> = hitEvent.target as PlayerPuppet;
  if IsDefined(p) { AG47.Note(hitEvent.attackData.GetInstigator() as NPCPuppet, p, true); };
  wrappedMethod(hitEvent);
}

// Actual game AI attempt metadata. No input, hit flags or success events are synthesized.
@addField(NPCPuppet) public let ag46Seen: Bool;
@addField(NPCPuppet) public let ag46WindUp: Bool;
@addField(NPCPuppet) public let ag46AttemptAt: Float;
@addField(NPCPuppet) public let ag46AttemptSeq: Int32;
@addField(NPCPuppet) public let ag46Record: TweakDBID;
@addField(NPCPuppet) public let ag46LoggedSeq: Int32;
@addField(NPCPuppet) public let ag46Target: EntityID;
@addField(PlayerPuppet) public let ag46FilterWindUp: Bool;

@wrapMethod(AISubActionMeleeAttackAttemptEvent_Record_Implementation)
public final static func Update(context: ScriptExecutionContext, record: wref<AISubActionMeleeAttackAttemptEvent_Record>, const duration: Float) -> AIbehaviorUpdateOutcome {
  let npc: ref<NPCPuppet> = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
  let target: wref<GameObject>;
  let p: ref<PlayerPuppet>;
  let result: AIbehaviorUpdateOutcome;
  if IsDefined(npc) && AIActionTarget.GetObject(context, record.Target(), target) {
    p = target as PlayerPuppet;
    if IsDefined(p) {
      npc.ag46Seen = true;
      npc.ag46WindUp = record.IsWindUp();
      npc.ag46AttemptAt = AG4.Now(p);
      npc.ag46AttemptSeq += 1;
      npc.ag46Target = p.GetEntityID();
      npc.ag46Record = record.GetID();
    };
  };
  result = wrappedMethod(context, record, duration);
  return result;
}

public class AG46 extends IScriptable {
  public static func Note(npc: ref<NPCPuppet>, p: ref<PlayerPuppet>, stage: String) -> Void {
    if !IsDefined(npc) || !IsDefined(p) || !p.agNEnabled { return; };
    if !npc.ag46Seen {
      if Equals(stage, "contact") { AGNativeTrace.Push(p, "ATTEMPT status=no_event stage=contact npc=" + EntityID.ToDebugString(npc.GetEntityID())); };
      return;
    };
    if Equals(stage, "candidate") && npc.ag46LoggedSeq == npc.ag46AttemptSeq { return; };
    npc.ag46LoggedSeq = npc.ag46AttemptSeq;
    AGNativeTrace.Push(p, "ATTEMPT stage=" + stage + " npc=" + EntityID.ToDebugString(npc.GetEntityID())
      + " seq=" + IntToString(npc.ag46AttemptSeq) + " isWindUp=" + AGNativeTrace.B(npc.ag46WindUp)
      + " age=" + FloatToString(AG4.Now(p) - npc.ag46AttemptAt) + " record=" + TDBID.ToStringDEBUG(npc.ag46Record));
  }
}
@wrapMethod(DamageManager)
private final static func ProcessDefensiveState(hitEvent: ref<gameHitEvent>) -> Void {
  let p: ref<PlayerPuppet> = hitEvent.target as PlayerPuppet;
  if IsDefined(p) { AG46.Note(hitEvent.attackData.GetInstigator() as NPCPuppet, p, "contact"); };
  wrappedMethod(hitEvent);
}

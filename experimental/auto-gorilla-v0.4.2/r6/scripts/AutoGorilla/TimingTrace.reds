// Measurement only. Does not alter the native-first automatic behavior.
public class AG41 extends IScriptable {
  public static func ID(npc: ref<NPCPuppet>) -> String {
    return IsDefined(npc) ? EntityID.ToDebugString(npc.GetEntityID()) : "none";
  }
  public static func Observe(npc: ref<NPCPuppet>, p: ref<PlayerPuppet>, source: String) -> Void {
    let phase: gamedataNPCUpperBodyState;
    let attack: Bool;
    let previousAttack: Bool;
    let first: Bool;
    if !IsDefined(npc) || !IsDefined(p) { return; };
    if Vector4.Distance(npc.GetWorldPosition(), p.GetWorldPosition()) > 5.0 { return; };
    phase = npc.GetUpperBodyStateFromBlackboard();
    if npc.ag41Seen && Equals(phase, npc.ag41Phase) { return; };
    first = !npc.ag41Seen;
    attack = Equals(phase, gamedataNPCUpperBodyState.Attack) || Equals(phase, gamedataNPCUpperBodyState.ChargedAttack);
    previousAttack = npc.ag41Seen && (Equals(npc.ag41Phase, gamedataNPCUpperBodyState.Attack) || Equals(npc.ag41Phase, gamedataNPCUpperBodyState.ChargedAttack));
    if attack && !previousAttack {
      npc.ag41Cycle += 1;
      npc.ag41Begin = AG4.Now(p);
      npc.ag41BeginFirstObservation = first && NotEquals(source, "state_change");
    };
    npc.ag41Seen = true;
    npc.ag41Phase = phase;
    AGNativeTrace.Push(p, "TIMING phase npc=" + AG41.ID(npc) + " cycle=" + IntToString(npc.ag41Cycle)
      + " phase=" + IntToString(EnumInt(phase)) + " attack=" + AGNativeTrace.B(attack)
      + " source=" + source + " firstObservation=" + AGNativeTrace.B(first));
  }
  public static func Tag(npc: ref<NPCPuppet>, p: ref<PlayerPuppet>) -> String {
    let age: Float = -1.0;
    if !IsDefined(npc) { return "npc=none"; };
    if npc.ag41Seen && npc.ag41Cycle > 0 { age = AG4.Now(p) - npc.ag41Begin; };
    return "npc=" + AG41.ID(npc) + " cycle=" + IntToString(npc.ag41Cycle)
      + " phaseAge=" + FloatToString(age) + " beginFirstObserved=" + AGNativeTrace.B(npc.ag41BeginFirstObservation);
  }
}
@addField(NPCPuppet) public let ag41Seen: Bool;
@addField(NPCPuppet) public let ag41Phase: gamedataNPCUpperBodyState;
@addField(NPCPuppet) public let ag41Cycle: Int32;
@addField(NPCPuppet) public let ag41Begin: Float;
@addField(NPCPuppet) public let ag41BeginFirstObservation: Bool;
@addField(NPCPuppet) public let ag41Contacts: Int32;
@addField(PlayerPuppet) public let ag41Candidate: wref<NPCPuppet>;

@wrapMethod(NPCStatesComponent)
private final func ChangeUpperBodyState(newState: gamedataNPCUpperBodyState) -> Void {
  let npc: ref<NPCPuppet> = this.GetOwner() as NPCPuppet;
  let p: ref<PlayerPuppet>;
  let previous: gamedataNPCUpperBodyState = this.GetCurrentUpperBodyState();
  wrappedMethod(newState);
  if IsDefined(npc) {
    p = GetPlayer(npc.GetGame());
    AG41.Observe(npc, p, NotEquals(previous, this.GetCurrentUpperBodyState()) ? "state_change" : "state_request");
    if NotEquals(previous, this.GetCurrentUpperBodyState()) { AG4.NoteNPC(npc, p); };
  };
}

@wrapMethod(MeleeDeflectEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let p: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(p) { AGNativeTrace.Push(p, "TIMING deflect_enter candidate_" + AG41.Tag(p.ag41Candidate, p)); };
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(DamageManager)
private final static func ProcessDefensiveState(hitEvent: ref<gameHitEvent>) -> Void {
  let p: ref<PlayerPuppet> = hitEvent.target as PlayerPuppet;
  let npc: ref<NPCPuppet> = hitEvent.attackData.GetInstigator() as NPCPuppet;
  let record: String = "unknown";
  let tag: String;
  if IsDefined(p) && p.agNEnabled && IsDefined(npc) {
    AG41.Observe(npc, p, "contact_observation");
    npc.ag41Contacts += 1;
    if IsDefined(hitEvent.attackData.GetAttackDefinition()) && IsDefined(hitEvent.attackData.GetAttackDefinition().GetRecord()) {
      record = TDBID.ToStringDEBUG(hitEvent.attackData.GetAttackDefinition().GetRecord().GetID());
    };
    tag = AG41.Tag(npc, p) + " contact=" + IntToString(npc.ag41Contacts) + " record=" + record
      + " attackType=" + IntToString(EnumInt(hitEvent.attackData.GetAttackType()));
    AGNativeTrace.Push(p, "TIMING contact BEFORE " + tag);
  };
  wrappedMethod(hitEvent);
  if IsDefined(p) && p.agNEnabled && IsDefined(npc) {
    AGNativeTrace.Push(p, "TIMING contact AFTER " + tag + " parried=" + AGNativeTrace.B(hitEvent.attackData.WasDeflected()) + " blocked=" + AGNativeTrace.B(hitEvent.attackData.WasBlocked()));
  };
}

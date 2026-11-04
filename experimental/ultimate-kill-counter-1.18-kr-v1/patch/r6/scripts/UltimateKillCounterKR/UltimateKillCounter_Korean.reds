module UltimateKillCounterKR

// Translation extension for Ultimate Kill Counter 1.18.
// Wrap only the display helper; original counters, events and save data stay upstream.
// Match both inputs because the upstream mod reuses several localization tags.
@wrapMethod(DataTrackingSystem)
public final func LocalizeTag(Tag: String, Default: String) -> String {
    switch Default {
        case "Kills":
            if Equals(Tag, "Mod-KillCounter-UI-KilledEnemies") {
                return "처치한 적";
            };
            break;
        case "Killed Enemies":
            if Equals(Tag, "Mod-KillCounter-UI-KilledEnemies") {
                return "치명적으로 처치한 적";
            };
            break;
        case "Finished Enemies":
            if Equals(Tag, "Mod-KillCounter-UI-FinishedEnemies") {
                return "무력화된 적 처치";
            };
            break;
        case "Defeated Enemies":
            if Equals(Tag, "Mod-KillCounter-UI-DefeatedEnemies") {
                return "비치명적 피해로 제압한 적";
            };
            break;
        case "Incapacitated Enemies":
            if Equals(Tag, "Mod-KillCounter-UI-IncapacitatedEnemies") {
                return "무력화시킨 적";
            };
            break;
        case "Downed Enemies":
            if Equals(Tag, "Mod-KillCounter-UI-DownedEnemies") {
                return "쓰러뜨린 적";
            };
            break;
        case "Downed With Melee":
            if Equals(Tag, "Mod-KillCounter-UI-DownedWithMelee") {
                return "근접 공격으로 쓰러뜨린 적";
            };
            break;
        case "Downed With Ranged":
            if Equals(Tag, "Mod-KillCounter-UI-DownedWithRanged") {
                return "원거리 공격으로 쓰러뜨린 적";
            };
            break;
        case "Downed With Quickhacks":
            if Equals(Tag, "Mod-KillCounter-UI-DownedWithRanged") {
                return "퀵핵으로 쓰러뜨린 적";
            };
            break;
        case "Downed With Takedowns":
            if Equals(Tag, "Mod-KillCounter-UI-DownedWithRanged") {
                return "테이크다운으로 쓰러뜨린 적";
            };
            break;
        case "Downed With Non-Lethal Takedowns":
            if Equals(Tag, "Mod-KillCounter-UI-DownedWithRanged") {
                return "은신 제압으로 쓰러뜨린 적";
            };
            break;
        case "Downed With Other":
            if Equals(Tag, "Mod-KillCounter-UI-DownedWithRanged") {
                return "기타의 방법으로 쓰러뜨린 적";
            };
            break;
    };
    // Preserve upstream behavior for any unknown label or another caller.
    return wrappedMethod(Tag, Default);
}

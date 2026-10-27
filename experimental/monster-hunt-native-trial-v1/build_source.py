"""Generate an original, minimal ArchiveXL quest injection, not a game archive."""
import copy
import json
from pathlib import Path

OUT = Path(__file__).parent / 'package'
DEPOT = r'jhg968\quest_trials\monster_hunt_native_v1.questphase'
PREFIX = 'jhg968_mh_native_v1_'
next_handle = 0

def handle(data):
    global next_handle
    identifier = str(next_handle)
    next_handle += 1
    return {'HandleId': identifier, 'Data': data}

def value(kind, name):
    return {'$type': kind, '$storage': 'string', '$value': name}

def socket(name, kind):
    return handle({'$type': 'questSocketDefinition', 'connections': [],
                   'name': value('CName', name), 'type': kind})

def node(identifier, kind, **fields):
    return handle({'$type': kind, 'id': identifier,
                   'sockets': [socket('In', 'Input'), socket('Out', 'Output')], **fields})

def fact(identifier, name):
    return node(identifier, 'questFactsDBManagerNodeDefinition', type=handle({
        '$type': 'questSetVar_NodeType', 'factName': name, 'setExactValue': 1, 'value': 1}))

def connect(source, destination):
    src = source['Data']['sockets'][1]
    dst = destination['Data']['sockets'][0]
    edge = handle({'$type': 'graphGraphConnectionDefinition',
                   'source': {'HandleRefId': src['HandleId']},
                   'destination': {'HandleRefId': dst['HandleId']}})
    src['Data']['connections'].append(edge)
    dst['Data']['connections'].append({'HandleRefId': edge['HandleId']})

# Graph runs once: ready -> explicit user request -> kill one named NPC -> dispatched.
# The kill node does not grant rewards, set vanilla facts or journal states.
start = node(0, 'questInputNodeDefinition', socketName=value('CName', 'In1'))
ready = fact(1, PREFIX + 'ready')
wait = node(2, 'questPauseConditionNodeDefinition', condition=handle({
    '$type': 'questFactsDBCondition', 'type': handle({
        '$type': 'questVarComparison_ConditionType', 'comparisonType': 'Greater',
        'factName': PREFIX + 'request', 'value': 0})}))
puppet = {
    '$type': 'gameEntityReference', 'type': 'EntityRef',
    'reference': value('NodeRef', '#kab_07_com_enemies'),
    'names': [value('CName', 'Jotaro')],
    'slotName': value('CName', 'None'),
    'sceneActorContextName': value('CName', 'None'),
    'dynamicEntityUniqueName': value('CName', 'None'),
}
kill = node(3, 'questCharacterManagerNodeDefinition', type=handle({
    '$type': 'questCharacterManagerCombat_NodeType', 'subtype': handle({
        '$type': 'questCharacterManagerCombat_Kill', 'puppetRef': puppet,
        'isPlayer': 0, 'noAnimation': 0, 'noRagdoll': 0,
        'skipDefeatedState': 1, 'doDismemberment': 0,
        'bodyPart': 0, 'woundType': 0, 'dismembermentStrenght': 0.0})}))
dispatched = fact(4, PREFIX + 'dispatched')
end = node(5, 'questOutputNodeDefinition', socketName=value('CName', 'Out1'), type='Terminating')
nodes = [start, ready, wait, kill, dispatched, end]
for src, dst in zip(nodes, nodes[1:]):
    connect(src, dst)
graph = handle({'$type': 'questGraphDefinition', 'nodes': nodes})
doc = {
    'Header': {'WolvenKitVersion': '10.0.0-beta.2-nightly.2026-10-25',
               'WKitJsonVersion': '0.0.9', 'GameVersion': 2500,
               'ExportedDateTime': '2026-10-27T00:00:00Z',
               'DataType': 'CR2W', 'ArchiveFileName': DEPOT},
    'Data': {'Version': 195, 'BuildVersion': 0,
             'RootChunk': {'$type': 'questQuestPhaseResource', 'cookingPlatform': 'PLATFORM_PC',
                           'graph': graph, 'inplacePhases': [], 'phasePrefabs': []},
             'EmbeddedFiles': []}}
# Preserve format versions from the supplied 2.50 export, not game content.
original = json.loads(Path('/workspace/attachments/e3ca3b24-b74e-400b-9aad-9b751239c42c/sts_wat_kabuki.questphase.json').read_text())
for key in ('Version', 'BuildVersion'):
    doc['Data'][key] = original['Data'][key]
target = OUT / 'WolvenKit' / 'source' / 'raw' / Path(DEPOT.replace('\\', '/') + '.json')
target.parent.mkdir(parents=True, exist_ok=True)
target.write_text(json.dumps(doc, indent=2) + '\n')
install = OUT / 'install'
xl = install / 'archive/pc/mod/MonsterHuntNativeTrial.archive.xl'
xl.parent.mkdir(parents=True, exist_ok=True)
xl.write_text('quest:\n  phases:\n    - path: ' + DEPOT + '\n      parent: cyberpunk2077_main.quest\n')
print(target)

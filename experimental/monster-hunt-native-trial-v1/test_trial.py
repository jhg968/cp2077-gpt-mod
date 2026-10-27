import json
from pathlib import Path
from lupa.luajit21 import LuaRuntime

BASE = Path(__file__).parent
source = (BASE / 'controller.lua').read_text()

def mock(**values):
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute('''
events={}; values={jhg968_mh_native_v1_ready=1, kab_07_start=1}; writes=0; logs={}
function registerForEvent(n,f) events[n]=f end
function print(s) logs[#logs+1]=s end
local quests={
GetFactStr=function(self,n) return values[n] or 0 end,
SetFactStr=function(self,n,v) assert(n=="jhg968_mh_native_v1_request"); assert(v==1); writes=writes+1; values[n]=v end}
Game={GetPlayer=function() return {} end,GetQuestsSystem=function() return quests end}
io={open=function() return {write=function(self,s) output=s;return self end,close=function() return true end} end}
button=""
ImGui={Begin=function() return true end,End=function() end,TextWrapped=function() end,Button=function(n) return n==button end}
''')
    for key, value in values.items():
        lua.globals()['values'][key] = value
    lua.execute(source)
    lua.execute('events.onInit(); events.onOverlayOpen()')
    return lua

def press(lua):
    lua.execute('button="Run lethal-path trial (one attempt)"; events.onDraw();button=""')

lua = mock()
lua.execute('events.onUpdate(1000)')
assert lua.globals().writes == 0  # no automatic mutation
press(lua)
press(lua)
assert lua.globals().writes == 1
lua.execute('events.onUpdate(1);events.onUpdate(120)')
assert lua.globals().writes == 1
for field in ('jhg968_mh_native_v1_ready', 'kab_07_start'):
    lua = mock(**{field: 0})
    press(lua)
    assert lua.globals().writes == 0
for field in ('jhg968_mh_native_v1_request', 'jhg968_mh_native_v1_dispatched',
              'kab_07_failed', 'kab_07_done', 'kab_07_finished',
              'kab_07_jotaro_killed', 'kab_07_no_kill'):
    lua = mock(**{field: 1})
    press(lua)
    assert lua.globals().writes == 0
lua = mock()
lua.execute('Game.GetPlayer=function() return nil end')
press(lua)
assert lua.globals().writes == 0

doc = json.loads(next((BASE / 'package/WolvenKit/source/raw').rglob('*.json')).read_text())
handles, refs, fact_writes, kinds = {}, [], [], []

def walk(obj):
    if isinstance(obj, dict):
        if 'HandleId' in obj:
            assert obj['HandleId'] not in handles
            handles[obj['HandleId']] = obj['Data']
        if 'HandleRefId' in obj:
            refs.append(obj['HandleRefId'])
        if obj.get('$type') == 'questSetVar_NodeType':
            fact_writes.append(obj['factName'])
        if '$type' in obj:
            kinds.append(obj['$type'])
        for value in obj.values():
            walk(value)
    elif isinstance(obj, list):
        for value in obj:
            walk(value)

walk(doc)
assert all(ref in handles for ref in refs)
assert sorted(fact_writes) == ['jhg968_mh_native_v1_dispatched', 'jhg968_mh_native_v1_ready']
assert 'questRewardManagerNodeDefinition' not in kinds
assert 'questJournalNodeDefinition' not in kinds
nodes = doc['Data']['RootChunk']['graph']['Data']['nodes']
assert len(nodes) == 6
assert nodes[3]['Data']['type']['Data']['subtype']['Data']['puppetRef']['names'][0]['$value'] == 'Jotaro'
assert nodes[3]['Data']['type']['Data']['subtype']['Data']['isPlayer'] == 0
print('PASS: no automatic writes; single request; all state guards; no-player guard; JSON handles; only custom facts; no reward/journal writes.')

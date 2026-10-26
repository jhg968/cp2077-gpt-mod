from pathlib import Path
from lupa.luajit21 import LuaRuntime
SOURCE=Path(__file__).resolve().with_name('init.lua').read_text()
MOCK=r'''
logs, jobs, targets, loads = {}, {}, {}, {}
local onInit, eventProxy
sourceRequests, sourceComplete, prematureTargets = 0, 0, 0
local function option(n, marker)
 return {name=n, definitions={marker=marker}, link=marker, randomizeCategory=marker}
end
local female='h_strong_arms_colors_cyberware01_fpp'
local male='u_strong_arms_colors_cyberware01_fpp'
if cfg.overlap then male=female end
local function resource(path, isSource)
 if isSource then
  if path:find('female_cco',1,true) then return {armsCustomizationOptions={option(female,'female')}} end
  return {armsCustomizationOptions={option(male,'male')}}
 end
 local r={armsCustomizationOptions={option(female,'original'),option(male,'original'),option('unrelated','untouched')}}
 if cfg.emptyTarget then r.armsCustomizationOptions={option('unrelated','untouched')} end
 return r
end
function print(s) table.insert(logs,s) end
function NameToString(s) return s end
function registerForEvent(name, fn) onInit=fn end
function NewProxy(t)
 function t:Target() return self end
 function t:Function(n) return n end
 return t
end
CName={new=function(x)return x end}
ResourceTarget={Path=function(x)return x end}
CallbackRunMode={Forever=1}
local listener={}
function listener:AddTarget(x)return self end
function listener:SetRunMode(x)return self end
local callbacks={}
function callbacks:RegisterCallback(n,p,f)eventProxy=p;return listener end
local depot={}
function depot:LoadResource(path)
 local isSource=path:find('2bt',1,true)==1
 table.insert(loads,path)
 if isSource then sourceRequests=sourceRequests+1
 elseif sourceRequests~=2 or sourceComplete~=(2-(cfg.failAllSources and 2 or cfg.failFemale and 1 or 0)) then prematureTargets=prematureTargets+1 end
 local failed=isSource and (cfg.failAllSources or (cfg.failFemale and path:find('female_cco',1,true))) or (not isSource and cfg.failTarget and path:find('ep1',1,true)==1)
 local r=resource(path,isSource)
 if not isSource and not failed then table.insert(targets,r) end
 local token={r=r,hash=1000000+#loads}
 function token:IsFailed()return not not failed end
 function token:GetHash()
  if cfg.cdataHashes then
   local ffi=require('ffi')
   -- A fresh cdata object on every call, with an exact value above 2^53.
   return ffi.new('uint64_t', 0x35268f7dc8da3af0ULL + self.hash)
  end
  return self.hash
 end
 function token:GetResource()if isSource and cfg.nilSources then return nil end;return self.r end
 function token:RegisterCallback(proxy,fn)
  local function job()
   if isSource then sourceComplete=sourceComplete+1 end
   proxy[fn].callback(self)
  end
  if cfg.sync then job() else table.insert(jobs,job) end
 end
 return token
end
Game={GetResourceDepot=function()return depot end,GetCallbackSystem=function()return callbacks end}
function start()onInit()end
function early()
 local r=resource('target',false)
 eventProxy.OnResourceLoad.callback({GetResource=function()return r end})
 earlyResult=r
end
function finish()
 while #jobs>0 do
  local i=1
  if cfg.reverse then i=#jobs end
  table.remove(jobs,i)()
 end
end
'''
configs=[{}, {'sync':True}, {'reverse':True}, {'early':True}, {'failFemale':True}, {'failAllSources':True}, {'failTarget':True}, {'emptyTarget':True}, {'nilSources':True}, {'overlap':True}]
# Reproduce the v1 defect using the same boxed-uint64 semantics as the log.
v1 = SOURCE.replace('tostring(token:GetHash())', 'token:GetHash()')
lua = LuaRuntime(unpack_returned_tuples=True)
lua.globals().cfg=lua.table_from({'cdataHashes':True})
lua.execute(MOCK); lua.execute(v1); lua.globals().start(); lua.globals().finish()
assert len(lua.globals().targets)==0
assert sum('duplicate/untracked source callback' in x for x in lua.globals().logs.values())==2
print('PASS: reproduced v1 stalled initialization with fresh uint64 objects')
configs = configs + [dict(c, cdataHashes=True) for c in configs]
for cfg in configs:
 lua=LuaRuntime(unpack_returned_tuples=True);lua.globals().cfg=lua.table_from(cfg);lua.execute(MOCK);lua.execute(SOURCE)
 lua.globals().start()
 if cfg.get('early'):lua.globals().early()
 lua.globals().finish()
 g=lua.globals();logs=list(g.logs.values())
 assert g.prematureTargets==0,(cfg,logs)
 assert all(not any(ord(c)<32 for c in p) for p in g.loads.values())
 assert not any('ERROR callback=' in s for s in logs),(cfg,logs)
 if cfg.get('failAllSources') or cfg.get('nilSources'):
  assert len(g.targets)==0
  assert any('target patching skipped' in x for x in logs)
 else:
  expected=2 if cfg.get('failTarget') else 4
  assert len(g.targets)==expected
  for t in g.targets.values():
   opts=t.armsCustomizationOptions
   if cfg.get('emptyTarget'):
    assert opts[1].definitions.marker=='untouched'
   elif not cfg.get('overlap'):
    assert opts[1].definitions.marker==('original' if cfg.get('failFemale') else 'female')
    assert opts[2].definitions.marker=='male'
    assert opts[3].definitions.marker=='untouched'
  if cfg.get('early'):
   assert g.earlyResult.armsCustomizationOptions[1].definitions.marker=='female'
 if cfg.get('overlap'):assert any('source option overlap=' in s for s in logs)
 print('PASS',cfg or 'asynchronous sources')
print('20 simulated LuaJIT 2.1 cases passed plus v1 regression reproduction; actual CET/Codeware runtime not tested.')

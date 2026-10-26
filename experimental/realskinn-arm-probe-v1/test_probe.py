from pathlib import Path
from lupa.luajit21 import LuaRuntime
SOURCE=Path(__file__).resolve().with_name('init.lua').read_text()
MOCK=r'''
local ffi=require('ffi')
logs, events, jobs = {}, {}, {}
loadCount, componentReads, hotkey = 0, 0, nil
playerAvailable=true
function readonly(t)
 return setmetatable({}, {__index=t,__newindex=function()error('unexpected game state write')end})
end
function print(s)table.insert(logs,s)end
function registerForEvent(n,f)events[n]=f end
function registerHotkey(n,desc,f)hotkey=f end
function NameToString(x)if type(x)~='string' then error('not a CName')end;return x end
function NewProxy(t)
 function t:Target()return self end
 function t:Function(n)return n end
 return t
end
ResourceAsyncRef={GetPath=function(v)if type(v)~='table' or not v.path then error('no ref')end;return v.path end}
ResRef={ToString=function(v)if type(v)~='string' then error('no path')end;return v end}
TweakDBID={new=function(v)return v end}
local strong=readonly({name='a0_005_wa__strongarms_l',isEnabled=false,chunkMask=0ULL,meshAppearance='default',mesh=readonly({path='test/gorilla.mesh'}),appearanceName='skin',appearancePath='test/gorilla.app',renderSceneLayerMask=0})
local normal=readonly({name='left_arm',isEnabled=true,chunkMask=0xffffffffffffffffULL,meshAppearance='normal',mesh=readonly({path='test/normal.mesh'})})
local player=readonly({GetComponents=function()componentReads=componentReads+1;return {strong,normal,readonly({name='unrelated'})} end})
local item=readonly({GetComponents=function()return {strong}end})
local tx=readonly({GetItemInSlot=function(self,p,slot)if slot=='AttachmentSlots.WeaponRight' then return item end end})
local depot={}
function depot:LoadResource(path)
 loadCount=loadCount+1
 local data=readonly({armsCustomizationOptions={readonly({name='h_strong_arms_colors_cyberware01_fpp',link='skin',resource=readonly({path='test/gorilla.app'}),definitions={readonly({index=0,name='default'})}})}})
 local id=loadCount
 local token=readonly({
 IsFailed=function()return cfg.failResources end,
 GetHash=function()return ffi.new('uint64_t',0x35268f7dc8da3af0ULL+id)end,
 GetResource=function()return data end,
 RegisterCallback=function(self,p,f)
  local function cb()p[f].callback(self)end
  if cfg.sync then cb()else table.insert(jobs,cb)end
 end})
 return token
end
Game={GetPlayer=function()if playerAvailable then return player end end,GetTransactionSystem=function()return tx end,GetResourceDepot=function()return depot end}
function drain()while #jobs>0 do table.remove(jobs,1)()end end
'''
for cfg in [{},{'sync':True},{'failResources':True}]:
 l=LuaRuntime(unpack_returned_tuples=True);g=l.globals();g.cfg=l.table_from(cfg);l.execute(MOCK);l.execute(SOURCE)
 g.events.onInit();g.playerAvailable=False;g.events.onUpdate(30)
 assert g.loadCount==0 and g.componentReads==0
 g.playerAvailable=True
 for dt in [3,7,10,100]:g.events.onUpdate(dt);g.drain()
 assert g.loadCount==3 and g.componentReads==3
 logs=list(g.logs.values())
 assert not any('unexpected game state write' in x or 'ERROR snapshot' in x or 'ERROR resource callback' in x for x in logs)
 assert any('enabled=false chunkMask=0ULL' in x and 'gorilla.mesh' in x for x in logs)
 assert any('enabled=true chunkMask=18446744073709551615ULL' in x for x in logs)
 if not cfg.get('failResources'):assert sum('DEFINITION COUNT' in x for x in logs)==3
 g.hotkey();assert g.componentReads==4
 print('PASS',cfg or 'async boxed-uint64 callbacks')
print('Read-only probe: 3 mocked LuaJIT cases passed; no game runtime verification.')

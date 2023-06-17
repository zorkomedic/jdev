CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(250) end
	while ESX.GetPlayerData().job == nil do Wait(250) end
	PlayerData = ESX.GetPlayerData()
	Wait(1000)
end)
local registrujem = RegisterNetEvent 
local handlujem = AddEventHandler 
local zovemserver = TriggerServerEvent 
local zovemklijent = TriggerEvent 
local budzenje = {}
local  isHandcuffed = false, false, false
local  dragStatus = {}
local GetPlayerServerId = GetPlayerServerId
dragStatus.isDragged = false
local Utils = {}
local currentTask = {}


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

CreateThread(function()
        exports.qtarget:AddBoxZone("vadjenjevozila", Config.Policija["pedvadjenje"].kordinate, 1.2, 1.2, {
            name="vadjenjevozila",
            heading=0,
            debugPoly=false,
            minZ=Config.Policija["pedvadjenje"].kordinate.z -1,
            maxZ=Config.Policija["pedvadjenje"].kordinate.z +2,
            }, {
                options = {
                    {
                        event = "jdev:vozilameni",
                        icon = "fas fa-car",
                        label = "Garaza",
                        job = "police",
                    },
                    {
                        action = function()
                            vrativozilo()
                        end,
                        label = "Parkirajte vozilo",
                        icon = "fas fa-car",
                        job = "police",
                        canInteract = function()
                            return IsPedInAnyVehicle(PlayerPedId(), false)
                          end,
                    },
                },
                distance = 3.5
        })
        RequestModel(GetHashKey(Config.Policija["pedvadjenje"].hash))
        while not HasModelLoaded(GetHashKey(Config.Policija["pedvadjenje"].hash)) do
        Wait(1)
        end
        PostaviPeda111 = CreatePed(4, Config.Policija["pedvadjenje"].hash, Config.Policija["pedvadjenje"].kordinate, Config.Policija["pedvadjenje"].heading, false, true)
        FreezeEntityPosition(PostaviPeda111, true) 
        SetEntityInvincible(PostaviPeda111, true)
        SetBlockingOfNonTemporaryEvents(PostaviPeda111, true)
end)

CreateThread(function()
    for k, v in pairs(Config.Policija) do 
        exports.qtarget:AddBoxZone("vadjenjeheli", Config.Policija["pedheli"].kordinate, 1.2, 1.2, {
            name="vadjenjeheli",
            heading=0,
            debugPoly=false,
            minZ=Config.Policija["pedheli"].kordinate.z -1,
            maxZ=Config.Policija["pedheli"].kordinate.z +2,
            }, {
                options = {
                    {
                        event = "jdev:helimeni",
                        label = "Garaza",
                        icon = "fas fa-car",
                        job = "police",
                    },
                    {
                        action = function()
                            vrativozilo()
                        end,
                        label = "Parkirajte vozilo",
                        job = "police",
                        canInteract = function()
                            return IsPedInAnyVehicle(PlayerPedId(), false)
                          end,
                    },
                },
                distance = 3.5
        })
        RequestModel(GetHashKey(Config.Policija["pedheli"].hash))
        while not HasModelLoaded(GetHashKey(Config.Policija["pedheli"].hash)) do
        Wait(1)
        end
        PostaviPeda222 = CreatePed(4, Config.Policija["pedheli"].hash, Config.Policija["pedheli"].kordinate, Config.Policija["pedheli"].heading, false, true)
        FreezeEntityPosition(PostaviPeda222, true) 
        SetEntityInvincible(PostaviPeda222, true)
        SetBlockingOfNonTemporaryEvents(PostaviPeda222, true)
  end
end)

registrujem('jdev:vozilameni', function()
    lib.registerContext({
        id = 'policijavozila',
        title = 'Garaza policijske uprave',
        options = {
            {
                title = 'Audi Presretac',
                description = "Brzina : 350km/h ",
                event = 'jdev:presretac',
            },
            {
                title = 'Policijski motor',
                description = "Brzina : 250km/h ",
                event = 'jdev:motor',
            },
            {
                title = 'Taurus',
                description = "Brzina : 230km/h ",
                event = 'jdev:lexsus',
            },
            {
                title = 'Mercedes undercover',
                description = "Brzina : 230km/h ",
                event = 'jdev:undercover',
            },
            {
                title = 'Camaro inspektorski',
                description = "Brzina : 230km/h ",
                event = 'jdev:camaro',
            },
            {
                title = 'M8 COMPETION',
                description = "Brzina : 300km/h ",
                event = 'jdev:patrolno',
            },
            {
                title = 'Policija Dzip',
                description = "Brzina : 300km/h ",
                event = 'jdev:dzipce',
            },
            {
                title = 'MUSTANG',
                description = "Brzina : 350km/h ",
                event = 'jdev:mustang',
            },
            {
                title = 'G klasa 6x6',
                description = "Brzina : 350km/h ",
                event = 'jdev:gklasa',
            },
            {
                title = 'Nacelnik vozilo',
                description = "Brzina : 350km/h ",
                event = 'jdev:rs5',
            },
            {
                title = 'Lexsus patrola',
                description = "Brzina : 350km/h ",
                event = 'jdev:lexsus',
            },
        }
    })
    lib.showContext('policijavozila')
end)


registrujem('jdev:helimeni', function()
    lib.registerContext({
        id = 'policijaheli',
        title = 'Garaza policijske uprave',
        options = {
            {
                title = 'Policijski helikopter',
                description = "Brzina : 240km/h ",
                event = 'jdev:heli',
            },
        }
    })
    lib.showContext('policijaheli')
end)

registrujem('jdev:heli', function(model)
    if ESX.Game.IsSpawnPointClear(Config.Policija["spawnheli"].kordinate, 3.5) then 
        if ESX.PlayerData.job.grade_name == 'komandir' or ESX.PlayerData.job.grade_name == 'zamenik' or ESX.PlayerData.job.grade_name == 'boss' then 
	local ModelHash = "polmav" 
	if not IsModelInCdimage(ModelHash) then return end
		RequestModel(ModelHash) 
	while not HasModelLoaded(ModelHash) do 
		Citizen.Wait(10)
	end
	local MyPed = PlayerPedId()
	local Vehicle = CreateVehicle(ModelHash,Config.Policija["spawnheli"].kordinate,Config.Policija["spawnheli"].heading, true, false)
ESX.ShowNotification("Vozilo vas ceka na parking mestu.")
else
    ESX.ShowNotification("Vas rank vam ne dozvoljava da imate ovo vozilo.")
end
else 
    ESX.ShowNotification("Spawn point je blokiran,zamolite kolege da pomere vozilo.")
 end
end)

registrujem('jdev:lexsus', function(model)
    if ESX.Game.IsSpawnPointClear(Config.Policija["spawnvozila"].kordinate, 3.5) then     
        if ESX.PlayerData.job.grade_name == 'officer' or ESX.PlayerData.job.grade_name == 'recruit' or ESX.PlayerData.job.grade_name == 'sergeant' or ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'liuetenant'  or ESX.PlayerData.job.grade_name == 'interventna' or ESX.PlayerData.job.grade_name == 'vinterventna' or ESX.PlayerData.job.grade_name == 'komandir' or ESX.PlayerData.job.grade_name == 'zamenik' then
   local ModelHash = "poltaurus" 
   if not IsModelInCdimage(ModelHash) then return end
       RequestModel(ModelHash) 
   while not HasModelLoaded(ModelHash) do 
       Citizen.Wait(10)
   end
   local MyPed = PlayerPedId()
   local Vehicle = CreateVehicle(ModelHash,Config.Policija["spawnvozila"].kordinate,Config.Policija["spawnvozila"].heading, true, false)
   ESX.ShowNotification("Vozilo vas ceka na parking mestu.")
else
    ESX.ShowNotification("Vas rank vam ne dozvoljava da imate ovo vozilo.")
end
   else 
       ESX.ShowNotification("Spawn point je blokiran,zamolite kolege da pomere vozilo.")
    end
end)

registrujem('jdev:camaro', function(model)
    if ESX.Game.IsSpawnPointClear(Config.Policija["spawnvozila"].kordinate, 3.5) then    
        if ESX.PlayerData.job.grade_name == 'sergeant' or ESX.PlayerData.job.grade_name == 'lieutenant' or ESX.PlayerData.job.grade_name == 'komandir' or ESX.PlayerData.job.grade_name == 'zamenik' or ESX.PlayerData.job.grade_name == 'boss' then 
   local ModelHash = "camaroRB" 
   if not IsModelInCdimage(ModelHash) then return end
       RequestModel(ModelHash) 
   while not HasModelLoaded(ModelHash) do 
       Citizen.Wait(10)
   end
   local MyPed = PlayerPedId()
   local Vehicle = CreateVehicle(ModelHash,Config.Policija["spawnvozila"].kordinate,Config.Policija["spawnvozila"].heading, true, false)
   ESX.ShowNotification("Vozilo vas ceka na parking mestu.")
else
    ESX.ShowNotification("Vas rank vam ne dozvoljava da imate ovo vozilo.")
end
   else 
       ESX.ShowNotification("Spawn point je blokiran,zamolite kolege da pomere vozilo.")
    end
end)



registrujem('jdev:gklasa', function(model)
    if ESX.Game.IsSpawnPointClear(Config.Policija["spawnvozila"].kordinate, 3.5) then     
        if ESX.PlayerData.job.grade_name == 'interventna' or ESX.PlayerData.job.grade_name == 'vinterventna' or ESX.PlayerData.job.grade_name == 'zamenik' or ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'komandir' then
   local ModelHash = "g63amg6x6cop" 
   if not IsModelInCdimage(ModelHash) then return end
       RequestModel(ModelHash) 
   while not HasModelLoaded(ModelHash) do 
       Citizen.Wait(10)
   end
   local MyPed = PlayerPedId()
   local Vehicle = CreateVehicle(ModelHash,Config.Policija["spawnvozila"].kordinate,Config.Policija["spawnvozila"].heading, true, false)
   ESX.ShowNotification("Vozilo vas ceka na parking mestu.")
else
    ESX.ShowNotification("Vas rank vam ne dozvoljava da imate ovo vozilo.")
end
   else 
       ESX.ShowNotification("Spawn point je blokiran,zamolite kolege da pomere vozilo.")
    end
end)

registrujem('jdev:undercover', function(model)
    if ESX.Game.IsSpawnPointClear(Config.Policija["spawnvozila"].kordinate, 3.5) then   
        if ESX.PlayerData.job.grade_name == 'sergeant' or ESX.PlayerData.job.grade_name == 'lieutenant' or ESX.PlayerData.job.grade_name == 'komandir' or ESX.PlayerData.job.grade_name == 'zamenik'  or ESX.PlayerData.job.grade_name == 'boss' then    
   local ModelHash = "s680guard22" 
   if not IsModelInCdimage(ModelHash) then return end
       RequestModel(ModelHash) 
   while not HasModelLoaded(ModelHash) do 
       Citizen.Wait(10)
   end
   local MyPed = PlayerPedId()
   local Vehicle = CreateVehicle(ModelHash,Config.Policija["spawnvozila"].kordinate,Config.Policija["spawnvozila"].heading, true, false)
   ESX.ShowNotification("Vozilo vas ceka na parking mestu.")
else
    ESX.ShowNotification("Vas rank vam ne dozvoljava da imate ovo vozilo.")
end
   else 
       ESX.ShowNotification("Spawn point je blokiran,zamolite kolege da pomere vozilo.")
    end
end)


registrujem('jdev:patrolno', function(model)
 if ESX.Game.IsSpawnPointClear(Config.Policija["spawnvozila"].kordinate, 3.5) then  
    if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'zamenik' then    
local ModelHash = "hp_m8" 
if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash) 
while not HasModelLoaded(ModelHash) do 
    Citizen.Wait(10)
end
local MyPed = PlayerPedId()
local Vehicle = CreateVehicle(ModelHash,Config.Policija["spawnvozila"].kordinate,Config.Policija["spawnvozila"].heading, true, false)
ESX.ShowNotification("Vozilo vas ceka na parking mestu.")
else
    ESX.ShowNotification("Vas rank vam ne dozvoljava da imate ovo vozilo.")
end
else 
    ESX.ShowNotification("Spawn point je blokiran,zamolite kolege da pomere vozilo.")
 end
end)

registrujem('jdev:presretac', function(model)
    if ESX.Game.IsSpawnPointClear(Config.Policija["spawnvozila"].kordinate, 3.5) then 
        if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'zamenik' or ESX.PlayerData.job.grade_name == 'komandir' or ESX.PlayerData.job.grade_name == 'vinterventna' or ESX.PlayerData.job.grade_name == 'interventna' then
local ModelHash = "presretac" 
if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash) 
while not HasModelLoaded(ModelHash) do 
    Citizen.Wait(10)
end
local MyPed = PlayerPedId()
local Vehicle = CreateVehicle(ModelHash,Config.Policija["spawnvozila"].kordinate,Config.Policija["spawnvozila"].heading, true, false)
ESX.ShowNotification("Vozilo vas ceka na parking mestu.")
else
    ESX.ShowNotification("Vas rank vam ne dozvoljava da imate ovo vozilo.")
end
else 
    ESX.ShowNotification("Spawn point je blokiran,zamolite kolege da pomere vozilo.")
 end
end)

registrujem('jdev:mustang', function(model)
    if ESX.Game.IsSpawnPointClear(Config.Policija["spawnvozila"].kordinate, 3.5) then 
        if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'zamenik' or ESX.PlayerData.job.grade_name == 'komandir' then
local ModelHash = "hp_mustangwb" 
if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash) 
while not HasModelLoaded(ModelHash) do 
    Citizen.Wait(10)
end
local MyPed = PlayerPedId()
local Vehicle = CreateVehicle(ModelHash,Config.Policija["spawnvozila"].kordinate,Config.Policija["spawnvozila"].heading, true, false)
ESX.ShowNotification("Vozilo vas ceka na parking mestu.")
else
    ESX.ShowNotification("Vas rank vam ne dozvoljava da imate ovo vozilo.")
end
else 
    ESX.ShowNotification("Spawn point je blokiran,zamolite kolege da pomere vozilo.")
 end
end)

registrujem('jdev:dzipce', function(model)
    if ESX.Game.IsSpawnPointClear(Config.Policija["spawnvozila"].kordinate, 3.5) then 
      if ESX.PlayerData.job.grade_name == 'officer' or ESX.PlayerData.job.grade_name == 'recruit' or ESX.PlayerData.job.grade_name == 'sergeant' or ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'liuetenant'  or ESX.PlayerData.job.grade_name == 'interventna' or ESX.PlayerData.job.grade_name == 'vinterventna' or ESX.PlayerData.job.grade_name == 'komandir' or ESX.PlayerData.job.grade_name == 'zamenik' then
local ModelHash = "poltah" 
if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash) 
while not HasModelLoaded(ModelHash) do 
    Citizen.Wait(10)
end
local MyPed = PlayerPedId()
local Vehicle = CreateVehicle(ModelHash,Config.Policija["spawnvozila"].kordinate,Config.Policija["spawnvozila"].heading, true, false)
ESX.ShowNotification("Vozilo vas ceka na parking mestu.")
else
    ESX.ShowNotification("Vas rank vam ne dozvoljava da imate ovo vozilo.")
end
else 
    ESX.ShowNotification("Spawn point je blokiran,zamolite kolege da pomere vozilo.")
 end
end)



registrujem('jdev:motor', function(model)
    if ESX.Game.IsSpawnPointClear(Config.Policija["spawnvozila"].kordinate, 3.5) then 
     if ESX.PlayerData.job.grade_name == 'officer' or ESX.PlayerData.job.grade_name == 'sergeant' or ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'liuetenant'  or ESX.PlayerData.job.grade_name == 'interventna' or ESX.PlayerData.job.grade_name == 'vinterventna' or ESX.PlayerData.job.grade_name == 'komandir' or ESX.PlayerData.job.grade_name == 'zamenik' then
local ModelHash = "policeb" 
if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash) 
while not HasModelLoaded(ModelHash) do 
    Citizen.Wait(10)
end
local MyPed = PlayerPedId()
local Vehicle = CreateVehicle(ModelHash,Config.Policija["spawnvozila"].kordinate,Config.Policija["spawnvozila"].heading, true, false)
ESX.ShowNotification("Vozilo vas ceka na parking mestu.")
else
    ESX.ShowNotification("Vas rank vam ne dozvoljava da imate ovo vozilo.")
end
else 
    ESX.ShowNotification("Spawn point je blokiran,zamolite kolege da pomere vozilo.")
 end
end)

registrujem('jdev:rs5', function(model)
    if ESX.Game.IsSpawnPointClear(Config.Policija["spawnvozila"].kordinate, 3.5) then 
        if ESX.PlayerData.job.grade_name == 'boss' then
local ModelHash = "hp_rs5" 
if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash) 
while not HasModelLoaded(ModelHash) do 
    Citizen.Wait(10)
end
local MyPed = PlayerPedId()
local Vehicle = CreateVehicle(ModelHash,Config.Policija["spawnvozila"].kordinate,Config.Policija["spawnvozila"].heading, true, false)
ESX.ShowNotification("Vozilo vas ceka na parking mestu.")
else
    ESX.ShowNotification("Vas rank vam ne dozvoljava da imate ovo vozilo.")
end
else 
    ESX.ShowNotification("Spawn point je blokiran,zamolite kolege da pomere vozilo.")
 end
end)

function vrativozilo()
    local vrativozilo = GetLastDrivenVehicle(PlayerPedId())
    DeleteVehicle(vrativozilo)
    ESX.ShowNotification("Uspesno ste parirali vozilo u garazu")
end

CreateThread(function()
    local blipara = AddBlipForCoord(Config.Blipara["blip1"].kordinate)

	SetBlipSprite (blipara, Config.Blipara["blip1"].id)
	SetBlipDisplay(blipara, 4)
	SetBlipScale  (blipara, Config.Blipara["blip1"].velicina)
	SetBlipColour (blipara, Config.Blipara["blip1"].boja)
	SetBlipAsShortRange(blipara, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(Config.Blipara["blip1"].text)
	EndTextCommandSetBlipName(blipara)
end)

CreateThread(function()
    exports.qtarget:AddBoxZone("popravka", Config.Policija["pedpopravka"].kordinate, 1.2, 1.2, {
        name="popravka",
        heading=0,
        debugPoly=false,
        minZ=Config.Policija["pedpopravka"].kordinate.z -1,
        maxZ=Config.Policija["pedpopravka"].kordinate.z +2,
        }, {
            options = {
                {
                    action = function()
                        pdpopravka()
                    end,
                    label = "Popravka vozila",
                    icon = "fa fa-toolbox",
                    job = "police",
                },
            },
            distance = 3.5
    })
    RequestModel(GetHashKey(Config.Policija["pedpopravka"].hash))
    while not HasModelLoaded(GetHashKey(Config.Policija["pedpopravka"].hash)) do
    Wait(1)
    end
    PostaviPeda333 = CreatePed(4, Config.Policija["pedpopravka"].hash, Config.Policija["pedpopravka"].kordinate, Config.Policija["pedpopravka"].heading, false, true)
    TaskStartScenarioInPlace(PostaviPeda333, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, false)
    FreezeEntityPosition(PostaviPeda333, true) 
    SetEntityInvincible(PostaviPeda333, true)
    SetBlockingOfNonTemporaryEvents(PostaviPeda333, true)
    table.insert(budzenje, PostaviPeda333)
end)

function pokrenianimaciju(ped, dictionary, anim)
	Citizen.CreateThread(function()
	  RequestAnimDict(dictionary)
	  while not HasAnimDictLoaded(dictionary) do
		Citizen.Wait(0)
	  end
		TaskPlayAnim(ped, dictionary, anim ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end


function proverapopravka()

end


function pdpopravka()
    local coords = GetEntityCoords(PlayerPedId())
    local najblizevozilo = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    local uvozilu = IsPedInAnyVehicle(PlayerPedId())
    local cisto = ESX.Game.IsSpawnPointClear(vector3(440.56, -1026.2, 28.44), 3.5)
    if uvozilu and cisto then 
        ESX.ShowNotification("Postoji problem : ")
        ESX.ShowNotification("1.U vozilu ste")
        ESX.ShowNotification("2.Neko vec popravlja")
    else 
	for i = 1, #budzenje do
        ClearPedTasks(budzenje[i])
		SetEntityCoords(budzenje[i],  Config.Policija["pedpoceo"].kordinate)
		pokrenianimaciju(budzenje[i], 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer')
		SetEntityHeading(budzenje[i], 141.52)
		SetVehicleDoorOpen(najblizevozilo, 4, false, true)
		SetVehicleDoorsLocked(najblizevozilo,2)
        SetVehicleDoorsLockedForAllPlayers(najblizevozilo, true)
		SetEntityCoords(najblizevozilo, vector3(440.56, -1026.2, 28.44))
     end
     ESX.ShowNotification("Vase vozilo se popravlja")
     Wait(30000)
     SetVehicleEngineHealth(najblizevozilo, 1000)
     SetVehicleFixed(najblizevozilo)
     ESX.ShowNotification("Vozilo uspesno popravljeno")
     for i = 1, #budzenje do
        DeletePed(budzenje[i])
        SetVehicleDoorsLocked(najblizevozilo,1)
        SetVehicleDoorsLockedForAllPlayers(najblizevozilo, false)
        SetVehicleDoorShut(najblizevozilo, 4, false)
        ponovopokreni()
    end
  end
end

function ponovopokreni()
    RequestModel(GetHashKey(Config.Policija["pedpopravka"].hash))
    while not HasModelLoaded(GetHashKey(Config.Policija["pedpopravka"].hash)) do
    Wait(1)
    end
    PostaviPeda555 = CreatePed(4, Config.Policija["pedpopravka"].hash, Config.Policija["pedpopravka"].kordinate, Config.Policija["pedpopravka"].heading, false, true)
    TaskStartScenarioInPlace(PostaviPeda555, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, false)
    FreezeEntityPosition(PostaviPeda555, true) 
    SetEntityInvincible(PostaviPeda555, true)
    SetBlockingOfNonTemporaryEvents(PostaviPeda555, true)
end
CreateThread(function()
exports.qtarget:AddBoxZone("pdsvlaccionica", Config.Policija["svlacionica"].kordinate, 3.85, 0.55, {
	name="pdsvlaccionica",
	heading=91.0,
	debugPoly=false,
	minZ=Config.Policija["svlacionica"].kordinate.z -1,
	maxZ=Config.Policija["svlacionica"].kordinate.z +2,
	}, {
		options = {
			{
				event = "jan:pduniforma",
				icon = "fas fa-sign-in-alt",
				label = "Svlacionica",
				job = "police",
			},
		},
		distance = 2
})
end)

registrujem("jan:pduniforma", function()

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		if skin.sex == 1 then
			lib.registerContext({
				id = 'Svlacionica',
				title = 'Policiska uniforma',
				options = {
					{
						title = 'Civilna Odjeca',
						event = 'jan:civilnaodjeca',
						icon = 'fa-solid fa-users',
					},
					{
						title = 'Policisko odjelo',
						event = 'jan:uniformagrade1',
						icon = 'fa-solid fa-users',
					},
				}
			})
			lib.showContext('Svlacionica')
		else
			if skin.sex == 0 then
				lib.registerContext({
					id = 'Svlacionica',
					title = 'Policiska uniforma',
					options = {
						{
							title = 'Civilna Odjeca',
							event = 'jan:civilnaodjeca',
							icon = 'fa-solid fa-users',
						},
						{
							title = 'Policisko odjelo',
							event = 'jan:uniformagrade',
							icon = 'fa-solid fa-users',
						},
					}
				})
				lib.showContext('Svlacionica')
			end
		end
	
	end)	
    
end)

registrujem('jan:civilnaodjeca', function()




	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadSkin', skin)
		elseif skin.sex == 1 then
			TriggerEvent('skinchanger:loadSkin', skin)
		end

	end)
	

	

end)





registrujem('jan:uniformagrade', function()

	local grade = ESX.PlayerData.job.grade_name
	local playerPed = PlayerPedId()
	setUniform(grade, playerPed)

end)

function setUniform(uniform, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject

		if skin.sex == 0 then
			uniformObject = Config.Uniforme[uniform].male
		else
			uniformObject = Config.Uniforme[uniform].female
		end

		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)

			if uniform == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			ESX.ShowNotification("Ne postoji uniforma koja vam odgovara")
		end
	end)
end



--f6 menii




local function canOpenTarget(ped)
	return IsPedFatallyInjured(ped)
	or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
	or IsPedCuffed(ped)
	or IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
	or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
end



function Utils.GetClosestPlayer()
	local players = GetActivePlayers()
	local playerCoords = GetEntityCoords(cache.ped)
	local targetDistance, targetId, targetPed

	for i = 1, #players do
		local player = players[i]

		if player ~= cache.playerId then
			local ped = GetPlayerPed(player)
			local distance = #(playerCoords - GetEntityCoords(ped))

			if distance < (targetDistance or 2) then
				targetDistance = distance
				targetId = player
				targetPed = ped
			end
		end
	end

	return targetId, targetPed
end


RegisterNetEvent("jan:pretrazi", function()
    local targetId, targetPed = Utils.GetClosestPlayer()
        if  targetId and canOpenTarget(targetPed) then
            TriggerEvent("ox_inventory:pretrazivanje")            

        else
            ESX.ShowNotification("Igrac mora imati podignute ruke ")
        end

end)

lib.registerContext({
	id = 'policija_menu',
	title = 'Policija meni | 🎩',
	onExit = function()
		--print('Cao')
	end,
	options = {
        {
            title = 'Pretrazi',
            description = '',
            arrow = true,
            event = 'pretrazi',
            icon = "fa-solid fa-male",
          },
		{
		  title = 'Zavezi/Odvezi',
		  description = '',
		  arrow = true,
		  event = 'gg:handcuff',
          icon = "fa-solid fa-male",
		},
		{
		  title = 'Vuci',
		  description = '',
		  arrow = true,
		  event = 'gg:drag',
          icon = "fa-solid fa-male",
		},
		{
		  title = 'Ubaci u vozilo',
		  description = '',
		  arrow = true,
		  event = 'gg:put_in_vehicle',
          icon = "fa-solid fa-male",
		},
		{
		  title = 'Izbaci iz vozila',
		  description = '',
		  arrow = true,
		  event = 'gg:out_the_vehicle',
          icon = "fa-solid fa-male",
		},
        {
            title = 'Tablet',
            description = 'dosije,lista gradjana,vozila',
            arrow = true,
            event = 'tablet',
            icon = "fa-solid fa-male",
        },
        {
            title = 'Kazne',
            description = 'razlog,cena',
            arrow = true,
            event = 'dark-kazne:otvoridialog',
            icon = "fa-solid fa-male",
        },
        {
            title = 'Zatvor',
            description = 'zatvori gradjana',
            arrow = true,
            event = 'zatvor',
            icon = "fa fa-clipboard",
        },
        {
            title = 'Meni znacke',
            description = 'pokazi/pogledaj',
            arrow = true,
            event = 'jdev:pokaziznacku',
            icon = "fa fa-clipboard",
        },
        {
            title = 'Zapleni vozilo',
            description = 'vozilo salje na impound',
            arrow = true,
            event = 'zapleni',
            icon = "fa fa-clipboard",
        },
        {
            title = 'Policijski tablet',
            description = 'dosije,opcije,igrice,komentari,databza',
            arrow = true,
            event = 'tablet',
            icon = "fa fa-clipboard",
        },
	},
})


registrujem("pretrazi", function()
    ExecuteCommand("steal")
end)

registrujem("tablet", function()
    ExecuteCommand("mdt")
end)

registrujem("zatvor", function()
    ExecuteCommand("jailmenu")
end)

function zaplenivozilo(vehicle)
	ESX.Game.DeleteVehicle(vehicle)
	ESX.ShowNotification("Zaplena vozia uspesna")
	currentTask.busy = false
end

registrujem("zapleni", function()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()
    local coords  = GetEntityCoords(playerPed)
    if currentTask.busy then
        return
    end

    ESX.ShowHelpNotification("Pritisnite E da prekinete zaplenu")
    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

    currentTask.busy = true
    currentTask.task = ESX.SetTimeout(10000, function()
        ClearPedTasks(playerPed)
        zaplenivozilo(vehicle)
        Citizen.Wait(100) 
    end)


    Citizen.CreateThread(function()
        while currentTask.busy do
            Citizen.Wait(1000)

            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
            if not DoesEntityExist(vehicle) and currentTask.busy then
                ESX.ShowNotification("Zaplena vozila uspesno otkazana")
                ESX.ClearTimeout(currentTask.task)
                ClearPedTasks(playerPed)
                currentTask.busy = false
                break
         end
     end
 end)
end)




RegisterNetEvent('gg:odvezivanje')
 AddEventHandler('gg:odvezivanje', function()
    if isHandcuffed then
        isHandcuffed = false
        local playerPed = PlayerPedId()
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(true)
    end
end)


RegisterNetEvent('gg:handcuff')
AddEventHandler('gg:handcuff', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('gg:vezivanje', GetPlayerServerId(closestPlayer))
	else
		ESX.ShowNotification("Nema igraca u vasoj blizini")
	end
end)

RegisterNetEvent('gg:drag')
AddEventHandler('gg:drag', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('gg:vuci', GetPlayerServerId(closestPlayer))
	else
		ESX.ShowNotification("Nema igraca u vasoj blizini")
	end
end)

RegisterNetEvent('gg:vuci')
AddEventHandler('gg:vuci', function(copId)
    if not isHandcuffed then return end
    dragStatus.isDragged = not dragStatus.isDragged
    dragStatus.CopId = copId
end)

RegisterNetEvent('gg:put_in_vehicle')
AddEventHandler('gg:put_in_vehicle', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('gg:staviUVozilo', GetPlayerServerId(closestPlayer))
        print('asdasd')
	else
		ESX.ShowNotification("Nema igraca u vasoj blizini")
	end
end)

RegisterNetEvent('gg:staviUVozilo')
AddEventHandler('gg:staviUVozilo', function()
    print('asd')
    if isHandcuffed then
        local igrac = PlayerPedId()
        local vozilo, udaljenost = ESX.Game.GetClosestVehicle()

        if vozilo and udaljenost < 5 then
            local max, slobodno = GetVehicleMaxNumberOfPassengers(vozilo)

            for i = max - 1, 0, -1 do
                if IsVehicleSeatFree(vozilo, i) then
                    slobodno = i
                    break
                end
            end

            if slobodno then
                TaskWarpPedIntoVehicle(igrac, vozilo, slobodno)
                dragStatus.isDragged = false
            end
        end
    end
end)

RegisterNetEvent('gg:out_the_vehicle')
AddEventHandler('gg:out_the_vehicle', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('gg:staviVanVozila', GetPlayerServerId(closestPlayer))
	else
		ESX.ShowNotification("Nema igraca u vasoj blizini")
	end
end)
RegisterNetEvent('gg:staviVanVozila')
AddEventHandler('gg:staviVanVozila', function()
	local playerPed = PlayerPedId()
	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle, 16)
		--TriggerEvent('sm_mafije:odvezivanje')
	else
		ESX.ShowNotification('Osoba nije u vozilu i ne mozete je izvaditi van vozila!')
	end
end)

RegisterNetEvent('gg:vezivanjecl')
 AddEventHandler('gg:vezivanjecl', function()
    isHandcuffed = not isHandcuffed
    local playerPed = PlayerPedId()
    if isHandcuffed then
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do Wait(0) end
        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
        SetEnableHandcuffs(playerPed, true)
        DisablePlayerFiring(playerPed, true)
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) 
        SetPedCanPlayGestureAnims(playerPed, false)
      --  FreezeEntityPosition(playerPed, true)
        DisplayRadar(false)
    else
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(true)
    end
end)
CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()

		if isHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			--DisableControlAction(0, 32, true) -- W
			--DisableControlAction(0, 34, true) -- A
			--DisableControlAction(0, 31, true) -- S
			--DisableControlAction(0, 30, true) -- D
			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?
			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job
			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle
			DisableControlAction(2, 36, true) -- Disable going stealth
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Wait(2000)
		end
	end
end)

CreateThread(function()
    local wasDragged

    while 1 do
        local Sleep = 1500

        if isHandcuffed and dragStatus.isDragged then
            Sleep = 50
            local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

            if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                if not wasDragged then
                    AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                    wasDragged = true
                else
                    Sleep = 1000
                end
            else
                wasDragged = false
                dragStatus.isDragged = false
                DetachEntity(PlayerPedId(), true, false)
            end
        elseif wasDragged then
            wasDragged = false
            DetachEntity(PlayerPedId(), true, false)
        end
        Wait(Sleep)
    end
end)

function OtvoriPolicijaMeni()
        if isHandcuffed then 
            ESX.ShowNotification("Vezani ste,ne mozete upravljati ljudima!")
        else
        for k,v in pairs(Config.Posao) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == k then  
		lib.showContext('policija_menu')
         end
	end
end
end

RegisterKeyMapping('+polmeni', 'Policijski meni', 'keyboard', 'F6')
RegisterCommand('+polmeni', function()
     if not isDead then
         OtvoriPolicijaMeni()
     else
        ESX.ShowNotification("Mrtav si ne mozes otvori meni majmune!")
     end
end, false)



RegisterCommand('-polmeni', function()
	
end, false)

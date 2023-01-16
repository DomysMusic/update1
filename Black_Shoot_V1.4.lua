local sampev = require 'lib.samp.events'
local imgui = require('imgui')
local encoding = require('encoding')
local rkeys = require('rkeys')
local vk = require('vkeys')
local inicfg = require('inicfg')

--local mb = require('MoonBot')

local memory = require "memory"

speed_multiplers = 15.0

local pRapidSpeed = imgui.ImInt(0)

local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Arial', 10, font_flag.BOLD + font_flag.SHADOW)
local font = renderCreateFont('Century Gothic', 12, 9)

local text_password = imgui.ImBuffer(256)

local LogInStory = imgui.ImBuffer(256) --Story Life Log IN


local KeyOpenStoryLife = imgui.ImBuffer(256) --Story Life Log IN

imgui.HotKey = require('imgui_addons').HotKey

encoding.default = 'CP1251'
local u8 = encoding.UTF8

local LogMenu = imgui.ImBool(false)

local MenuStoryL = imgui.ImBool(false)

local StoryMenuLog = imgui.ImBool(false)

local menu = imgui.ImBool(false)
local lastMenu = menu.v

local tabSize = imgui.ImVec2(100, 20)

pAnimationWalk = {'WALK_PLAYER', 'GUNCROUCHFWD', 'GUNCROUCHBWD', 'GUNMOVE_BWD', 'GUNMOVE_FWD', 'GUNMOVE_L', 'GUNMOVE_R', 'RUN_GANG1', 'JOG_FEMALEA', 'JOG_MALEA', 'RUN_CIVI', 'RUN_CSAW', 'RUN_FAT', 'RUN_FATOLD', 'RUN_OLD', 'RUN_ROCKET', 'RUN_WUZI', 'SPRINT_WUZI', 'WALK_ARMED', 'WALK_CIVI', 'WALK_CSAW', 'WALK_DRUNK', 'WALK_FAT', 'WALK_FATOLD', 'WALK_GANG1', 'WALK_GANG2', 'WALK_OLD', 'WALK_SHUFFLE', 'WALK_START', 'WALK_START_ARMED', 'WALK_START_CSAW', 'WALK_START_ROCKET', 'WALK_WUZI', 'WOMAN_WALKBUSY', 'WOMAN_WALKFATOLD', 'WOMAN_WALKNORM', 'WOMAN_WALKOLD', 'WOMAN_RUNFATOLD', 'WOMAN_WALKPRO', 'WOMAN_WALKSEXY', 'WOMAN_WALKSHOP', 'RUN_1ARMED', 'RUN_ARMED', 'RUN_PLAYER', 'WALK_ROCKET', 'CLIMB_IDLE', 'MUSCLESPRINT', 'CLIMB_PULL', 'CLIMB_STAND', 'CLIMB_STAND_FINISH', 'SWIM_BREAST', 'SWIM_CRAWL', 'SWIM_DIVE_UNDER', 'SWIM_GLIDE', 'MUSCLERUN', 'WOMAN_RUN', 'WOMAN_RUNBUSY', 'WOMAN_RUNPANIC', 'WOMAN_RUNSEXY', 'SPRINT_CIVI', 'SPRINT_PANIC', 'SWAT_RUN', 'FATSPRINT'}
pAnimationDeagle = {'PYTHON_CROUCHFIRE', 'PYTHON_FIRE', 'PYTHON_FIRE_POOR'}
pOverdoseAnimations = {'CRCKIDLE4', 'CRCKIDLE2', 'CRCKDETH2'}
pGunsAnimations = {'PYTHON_CROUCHFIRE', 'PYTHON_FIRE', 'PYTHON_FIRE_POOR', 'PYTHON_CROCUCHRELOAD', 'RIFLE_CROUCHFIRE', 'RIFLE_CROUCHLOAD', 'RIFLE_FIRE', 'RIFLE_FIRE_POOR', 'RIFLE_LOAD', 'SHOTGUN_CROUCHFIRE', 'SHOTGUN_FIRE', 'SHOTGUN_FIRE_POOR', 'SILENCED_CROUCH_RELOAD', 'SILENCED_CROUCH_FIRE', 'SILENCED_FIRE', 'SILENCED_RELOAD', 'TEC_crouchfire', 'TEC_crouchreload', 'TEC_fire', 'TEC_reload', 'UZI_crouchfire', 'UZI_crouchreload', 'UZI_fire', 'UZI_fire_poor', 'UZI_reload', 'idle_rocket', 'Rocket_Fire', 'run_rocket', 'walk_rocket', 'WALK_start_rocket', 'WEAPON_sniper'}

local adminlog = false

local StoryActivate = false

local keyopens = VK_Z

local OpenKey1 = VK_Z

local OpenKey12 = imgui.ImBuffer(5)

local HideShowMenu = imgui.ImBuffer(5)

local ToggleButtons = {
	{"GM"},
	{"InfinityAmmo"},
	{"InfinityRun"},
	{"NoSpread"},
	{"NoFall"},
	{"FastWalk"},
	{"Rapid"},
	{"FastDeagle"},
	{"Invisible"},
	{"Surfer"},
	{"AirBreak"},
	{"MegaJump"},
	{"AntiStun"},
	{"160HP"},
	{"PCollision"},
	{"ObjectCollision"},
	{"ReconnectBan"},
	{"DrawMyInfo"},
	{"GMCar"},
	{"EasyDrive"},
	{"repair"},
	{"CarShot"},
	{"BreakDance"},
	{"SpeedHack"},
	{"SaveLoadPort"},
	{"CarJump"},
	{"IdVeh"},
	{"NameStatus"},
	{"FullSkills"},
	{"FastFire"},
	{"DoorStatus2"},
	{"OpenStoryWithKey"},
--KeyBinds
	{"KeyBindAGorivo"},
	{"KeyBindNoviIgraci"},
	{"KeyBindMaskirani"},
	{"KeyBindAfkeri"},
	{"KeyBindCc"},
	{"KeyBindCc2"}
	
}

local text_console = imgui.ImBuffer(6000)

for k, v in pairs(ToggleButtons) do
    _G['HH_'..v[1]] = imgui.ImBool(false)
end

function getConfigListNames()
    local configListNames = {}
    for k, config in pairs(configs) do
        table.insert(configListNames, config.name)
    end
    return configListNames
end


function onBotRPC(bot, rpcId, bs)
    sampAddChatMessage(string.format('{00ba1f}[BS 1.4]: Bot %s got RPC: %d', bot.name, rpcId), -1)
	if rpcId == 68 then
        for k, lBot in pairs(botData) do
            if lBot.index == bot.index and not lBot.logined then
                lBot.logined = true
                bot:sendRequestSpawn()
                bot:sendSpawn()
                sampAddChatMessage(string.format('{00ba1f}[BS 1.4]: %s [%d] sent request spawn', bot.name, bot.index), -1)
            end
        end
    end
	if rpcId == 12 then
        local x, y, z = bs:readFloat(), bs:readFloat(), bs:readFloat()
        for k, botData in pairs(bots) do
            if botData.index == bot.index then
                botData.position = {x = x, y = y, z = z}
                pcall(sampAddChatMessage, string.format('{00ba1f}[BS 1.4]: Position: %f, %f, %f', botData.position.x, botData.position.y, botData.position.z), -1)
            end
        end
    end
	
end

function getDistanceToPlayer(playerId)
    local _, ped = sampGetCharHandleBySampPlayerId(playerId)
    if _ then
        local mx, my, mz = getCharCoordinates(PLAYER_PED)
        local x, y, z = getCharCoordinates(ped)
        return getDistanceBetweenCoords3d(x, y, z, mx, my, mz)
    else
        return 9999
    end
end

function loadSettings()
    local date = os.date('*t')
    local dir = getWorkingDirectory() .. '/config/Black Shoot V1.4/'
    local ini = inicfg.load(nil, dir .. 'settings.ini')
    selectedConfig.v = ini.settings.selectedConfig
    disableSnowForeverV = ini.settings.disableThisShitSnowfall
    snowEnabled = not disableSnowForeverV and ((date.month == 12 and date.day >= 24) or (date.month == 1 and date.day <= 7))
    preConfig = selectedConfig.v
    if selectedConfig.v > table.getn(configs) - 1 then
        selectedConfig.v = 0
    end
    setConfig(getConfigByIndex(selectedConfig.v).name)
end

function loadConfigs()
    local dir = getWorkingDirectory() .. '/config/Black Shoot V1.4'
    dir = getWorkingDirectory() .. '/config/Black Shoot V1.4/configs'
    local handle, name = findFirstFile(dir .. '/*.json')
    while name do
        if handle then
            if not name then
                findClose(name)
            else
                loadConfig(name)
                name = findNextFile(handle)
            end
        end
    end
    if table.getn(configs) == 0 then
        local config = createConfig('Default')
        saveConfig(config)
    end
end

function updateConfig(name)
    local config = getConfig(name)
    if config ~= nil then
        config.settings.codes.HideShowMenu = settingsShowMenuCode.v
    end
end

function setConfig(name)
    local config = getConfig(name)
    if config ~= nil then
        settingsShowMenuCode.v = config.settings.codes.HideShowMenu
		
        setTheme(settingsSelectedTheme.v)
        needsInit = 1
    end
end

function imgui.ToggleButton(str_id, bool)

	local rBool = false
 
	if LastActiveTime == nil then
	   LastActiveTime = {}
	end
	if LastActive == nil then
	   LastActive = {}
	end
 
	local function ImSaturate(f)
	   return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
	end
  
	local p = imgui.GetCursorScreenPos()
	local draw_list = imgui.GetWindowDrawList()
 
	local height = imgui.GetTextLineHeightWithSpacing() + (imgui.GetStyle().FramePadding.y / 2)
	local width = height * 1.55
	local radius = height * 0.50
	local ANIM_SPEED = 0.15
 
	if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
	   bool.v = not bool.v
	   rBool = true
	   LastActiveTime[tostring(str_id)] = os.clock()
	   LastActive[str_id] = true
	end
 
	local t = bool.v and 1.0 or 0.0
 
	if LastActive[str_id] then
	   local time = os.clock() - LastActiveTime[tostring(str_id)]
	   if time <= ANIM_SPEED then
		  local t_anim = ImSaturate(time / ANIM_SPEED)
		  t = bool.v and t_anim or 1.0 - t_anim
	   else
		  LastActive[str_id] = false
	   end
	end
 
	local col_bg
	if imgui.IsItemHovered() then
	   col_bg = imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
	else
	   col_bg = imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.FrameBg])
	end
 
	draw_list:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), col_bg, height * 0.5)
	draw_list:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 1.5, imgui.GetColorU32(bool.v and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.GetStyle().Colors[imgui.Col.Button]))
 
	return rBool
end

function imgui.BeforeDrawFrame()
    if fontsize == nil then
        fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 25.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) -- вместо 30 любой нужный размер
    end
end

function main()
    repeat wait(0) until isSampAvailable()
   -- sampRegisterChatCommand('MenuV1', function() 
	
	
  --  sampRegisterChatCommand('MenuV1Open', MenuOpenLogin) 
	
    sampRegisterChatCommand('BlackShoot', MenuOpen)
	
   -- sampRegisterChatCommand('StoryLifeKey', KeyOpenStoryLifeCMD)9C9D9D
	
    sampRegisterChatCommand('StoryLife', StoryLifeOpen)
	
	
	
    --[[sampRegisterChatCommand('MenuV1', function() 
        LogMenu.v = not LogMenu.v
	elseif
		str2 = true
		menu.v = not menu.v
    end)
	
	--]]
    while true do
        wait(0)
        imgui.Process = LogMenu.v or menu.v or MenuStoryL.v or StoryMenuLog.v
		
		
	--PLAYER CHEATS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	pPlayerPosX, pPlayerPosY, pPlayerPosZ = getCharCoordinates(PLAYER_PED)
    	pPlayerCurrWeapon = getCurrentCharWeapon(PLAYER_PED)
    	if isCharInAnyCar(PLAYER_PED) then
    		pCarHandle = storeCarCharIsInNoSave(PLAYER_PED)
    	end
	
	
	
	if HH_GM.v then
    		setCharProofs(PLAYER_PED, true, true, true, true, true)
    		if isCharInAnyCar(PLAYER_PED) then
    			setCarProofs(pCarHandle, true, true, true, true, true)
    		end
    	elseif not HH_GM.v then
    		setCharProofs(PLAYER_PED, false, false, false, false, false)
    		if isCharInAnyCar(PLAYER_PED) then
    			setCarProofs(pCarHandle, false, false, false, false, false)
    		end
    end
	
	if HH_NoFall.v then
		if isCharPlayingAnim(PLAYER_PED, 'KO_SKID_BACK') or isCharPlayingAnim(playerPed, 'FALL_COLLAPSE') then
            clearCharTasksImmediately(PLAYER_PED)
        end
    end
	
	if HH_InfinityRun.v then
    	setPlayerNeverGetsTired(PLAYER_PED, 0)
    elseif not HH_InfinityRun.v then
    	setPlayerNeverGetsTired(PLAYER_PED, 0)
    end
	
	
	if HH_FastWalk.v then
		for k,v in pairs(pAnimationWalk) do
       setCharAnimSpeed(PLAYER_PED, v, 15.0) -- 5 standart of 1.5
        setPlayerNeverGetsTired(PLAYER_PED, 0)
        end
   	elseif not HH_FastWalk.v then
    	for k,v in pairs(pAnimationWalk) do
    		setCharAnimSpeed(PLAYER_PED, v, 1.0)
    		setPlayerNeverGetsTired(PLAYER_PED, 1)
    	end
    end
	
	if HH_Invisible.v then
		function sampev.onSendPlayerSync(data)
            local xi, yi, zi = getCharCoordinates(PLAYER_PED) -- invis
            data.position.x = xi
            data.position.y = yi
            data.position.z = zi-5
		end
		
		function sampev.onSendVehicleSync(data)
			local xi, yi, zi = getCharCoordinates(PLAYER_PED) -- invis
            data.position.x = xi
            data.position.y = yi
            data.position.z = zi-5
		end
	end
	
		if HH_Surfer.v then
			if wasKeyPressed(VK_X) then
            surfp = not surfp
			renderFontDrawText(my_font, 'Surf: Deactivate', 5, 625, 0xFFFF0000)
			end
			if surfp then
			renderFontDrawText(my_font, 'Surf: Activated', 5, 625, 0xFF00FF00)
				local CPed = getCharPointer(PLAYER_PED)
					setCharProofs(PLAYER_PED, false, false, false, true, false)
					local camX, camY, camZ = getActiveCameraCoordinates()
					local actCamX, actCamY, actCamZ = getActiveCameraPointAt()

					actCamX = actCamX - camX
					actCamY = actCamY - camY

					local zAngle = getHeadingFromVector2d(actCamX, actCamY)
					setCharHeading(PLAYER_PED, zAngle)

					local vecX, vecY, vecZ = getCharVelocity(PLAYER_PED)
					vecX = vecX * 1.001
					vecY = vecY * 1.001
					
					local speedMultX = memory.getfloat(CPed + 0x550)
					local speedMultY = memory.getfloat(CPed + 0x554)

					speedMultX = speedMultX * speed_multiplers
					speedMultY = speedMultY * speed_multiplers
					
					
					
					
					vecX = vecX + speedMultX
					vecY = vecY + speedMultY
					setCharVelocity(PLAYER_PED, vecX, vecY, vecZ)

					if not isCharPlayingAnim(PLAYER_PED, "KO_skid_back") then
						memory.setuint8(CPed + 0x46C, 0, true)
					end
				if not surfp then
					renderFontDrawText(my_font, 'Surf: Deactivate', 5, 625, 0xFFFF0000)
				end
			end
			
		end
		
		if HH_AirBreak.v then
			if wasKeyPressed(VK_RSHIFT) then
            airbreak = not airbreak
			renderFontDrawText(my_font, 'AirBreak: Deactivate', 5, 605, 0xFFFF0000)
        end
        if airbreak then
			renderFontDrawText(my_font, 'AirBreak: Activate', 5, 605, 0xFF00FF00)
            local charCoordinates = {getCharCoordinates(PLAYER_PED)}
            local ViewHeading = getCharHeading(PLAYER_PED)
            Coords = {charCoordinates[1], charCoordinates[2], charCoordinates[3], 0.0, 0.0, ViewHeading}
            local MainHeading = getCharHeading(PLAYER_PED)
            local Camera = {getActiveCameraCoordinates()}
            local Target = {getActiveCameraPointAt()}
            local RotateHeading = getHeadingFromVector2d(Target[1] - Camera[1], Target[2] - Camera[2])
            if isKeyDown(VK_W) then
                Coords[1] = Coords[1] + 0.25 * math.sin(-math.rad(RotateHeading))
                Coords[2] = Coords[2] + 0.25 * math.cos(-math.rad(RotateHeading))
                setCharHeading(PLAYER_PED, RotateHeading)
            elseif isKeyDown(VK_S) then
                Coords[1] = Coords[1] - 0.25 * math.sin(-math.rad(MainHeading))
                Coords[2] = Coords[2] - 0.25 * math.cos(-math.rad(MainHeading))
            end
            if isKeyDown(VK_A) then
                Coords[1] = Coords[1] - 0.25 * math.sin(-math.rad(MainHeading - 90))
                Coords[2] = Coords[2] - 0.25 * math.cos(-math.rad(MainHeading - 90))
            elseif isKeyDown(VK_D) then
                Coords[1] = Coords[1] - 0.25 * math.sin(-math.rad(MainHeading + 90))
                Coords[2] = Coords[2] - 0.25 * math.cos(-math.rad(MainHeading + 90))
            end
            if isKeyDown(VK_SPACE) then Coords[3] = Coords[3] + 0.25 / 1.5 end
            if isKeyDown(VK_LSHIFT) and Coords[3] > -95.0 then Coords[3] = Coords[3] - 0.25 / 1.5 end
            setCharCoordinates(PLAYER_PED, Coords[1], Coords[2], Coords[3] - 1)
        end
		if not airbreak then
			renderFontDrawText(my_font, 'AirBreak: Deactivate', 5, 605, 0xFFFF0000)
		end
		end
		
		if HH_MegaJump.v then
    		memory.setint8(0x96916C, 1)
    	elseif not HH_MegaJump.v then
    		memory.setint8(0x96916C, 0)
    	end
		
		if HH_160HP.v then
            memory.setfloat(0xB793E0, 910.4) -- 910.4
        elseif not HH_160HP.v then
            memory.setfloat(0xB793E0, 569.0)
        end
		
		if HH_PCollision.v then
    	_, ped, car = storeClosestEntities(PLAYER_PED)
		if ped ~= -1 then
			setCharCollision(ped, false)
		end
    	end
		
		--VEHICLE CHEATS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		
		if HH_GMCar.v then
    		if isCharInAnyCar(PLAYER_PED) then
    			setCarProofs(pCarHandle, true, true, true, true, true)
    		end
    	elseif not HH_GMCar.v then
    		if isCharInAnyCar(PLAYER_PED) then
    			setCarProofs(pCarHandle, false, false, false, false, false)
    		end
    	end
		
		if HH_EasyDrive.v then
    		memory.setint8(0x96914C, 1)
    	elseif not HH_EasyDrive.v then
    		memory.setint8(0x96914C, 0)
    	end
		
		--REPAIR MODIFICATION START >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		
		if HH_repair.v and isCharInAnyCar(PLAYER_PED) then
			if isKeyJustPressed(0x35) and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then
				local veh = storeCarCharIsInNoSave(PLAYER_PED)
				local _, id = sampGetVehicleIdByCarHandle(veh)
				local data = samp_create_sync_data('vehicle', true)
				if _ then
					data.vehicleId = id
					data.position.x, data.position.y, data.position.z = getCarCoordinates(veh)
					data.vehicleHealth = 1000
					data.send()
					setCarHealth(veh, 1000)
					fixCar(veh)
				else
					if bNotf then
                        notf.addNotification("First, enter to vehicle", 3, 3)
                    end
				end
			end
		end
		
		function fpsCorrection() --Speedhack
			return representIntAsFloat(readMemory(0xB7CB5C, 4, false))
		end

		
		function samp_create_sync_data(sync_type, copy_from_player)
			local ffi = require 'ffi'
			local sampfuncs = require 'sampfuncs'
			-- from SAMP.Lua
			local raknet = require 'samp.raknet'
			require 'samp.synchronization'

			copy_from_player = copy_from_player or true
			local sync_traits = {
				player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
				vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
				passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
				aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
				trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
				unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
				bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
				spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
			}
			local sync_info = sync_traits[sync_type]
			local data_type = 'struct ' .. sync_info[1]
			local data = ffi.new(data_type, {})
			local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))
			-- copy player's sync data to the allocated memory
			if copy_from_player then
				local copy_func = sync_info[3]
				if copy_func then
					local _, player_id
					if copy_from_player == true then
						_, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
					else
						player_id = tonumber(copy_from_player)
					end
					copy_func(player_id, raw_data_ptr)
				end
			end
			-- function to send packet
			local func_send = function()
				local bs = raknetNewBitStream()
				raknetBitStreamWriteInt8(bs, sync_info[2])
				raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
				raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
				raknetDeleteBitStream(bs)
			end
			-- metatable to access sync data and 'send' function
			local mt = {
				__index = function(t, index)
					return data[index]
				end,
				__newindex = function(t, index, value)
					data[index] = value
				end
			}
			return setmetatable({send = func_send}, mt)
		end
		
		--REPAIR MODIFICATION STOP >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		
		if HH_CarShot.v then
    		if isCharInAnyCar(PLAYER_PED) then
    			local pCamCoordX, pCamCoordY, pCamCoordZ = getActiveCameraCoordinates()
    			local pTargetCamX, pTargetCamY, pTargetCamZ = getActiveCameraPointAt()
    			setCarHeading(pCarHandle, getHeadingFromVector2d(pTargetCamX - pCamCoordX, pTargetCamY - pCamCoordY))
    			if isKeyDown(VK_W) then
    				setCarForwardSpeed(pCarHandle, 200.0)
    			elseif isKeyDown(VK_S) then
    				setCarForwardSpeed(pCarHandle, 0.0)
    			elseif isKeyDown(VK_SPACE) then
    				applyForceToCar(pCarHandle, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0)
    			end
    		end
		end
		
		if HH_BreakDance.v then
		local brc = true
			if brc and isCharInAnyCar(playerPed) and not sampIsDialogActive() and not sampIsChatInputActive() then local car = storeCarCharIsInNoSave(playerPed)
					if isKeyDown(VK_K) 	then addToCarRotationVelocity(car, 0.25, 0, 0)
					end
					if isKeyDown(VK_I) 	then addToCarRotationVelocity(car, -0.25, 0, 0) --.
					end
					if isKeyDown(VK_U)	then addToCarRotationVelocity(car, 0, -0.25, 0) --.
					end
					if isKeyDown(VK_O)	then addToCarRotationVelocity(car, 0, 0.25, 0) --
					end
					if isKeyDown(VK_L)		then addToCarRotationVelocity(car, 0, 0, -0.25) --.
					end
					if isKeyDown(VK_J)		then addToCarRotationVelocity(car, 0, 0, 0.25) --.
					end
			end
		end
		
		if HH_SpeedHack.v then
			if isCharInAnyCar(PLAYER_PED) then
				if isKeyDown(VK_LMENU) then
					local vecx, vecy, vecz = getCarSpeedVector(storeCarCharIsInNoSave(PLAYER_PED))
					local heading = getCarHeading(storeCarCharIsInNoSave(PLAYER_PED))
					local turbo = fpsCorrection() / 42
					local xforce, yforce, zforce = turbo, turbo, turbo
					local Sin, Cos = math.sin(-math.rad(heading)), math.cos(-math.rad(heading))
					if vecx > -0.01 and vecx < 0.01 then xforce = 0.0 end
					if vecy > -0.01 and vecy < 0.01 then yforce = 0.0 end
					if vecz < 0 then zforce = -zforce end
					if vecz > -2 and vecz < 15 then zforce = 0.0 end
					if Sin > 0 and vecx < 0 then xforce = -xforce end
					if Sin < 0 and vecx > 0 then xforce = -xforce end
					if Cos > 0 and vecy < 0 then yforce = -yforce end
					if Cos < 0 and vecy > 0 then yforce = -yforce end
					applyForceToCar(storeCarCharIsInNoSave(PLAYER_PED), xforce * Sin, yforce * Cos, zforce / 2, 0.0, 0.0, 0.0)
				end
			end
		end
		
		if HH_CarJump.v then
			if isCharInAnyCar(PLAYER_PED) then
				if isKeyDown(VK_B) then
				applyForceToCar(pCarHandle, 0.0, 0.0, 0.02, 0.0, 0.0, 0.0)
				end
			end
		end
		
		if HH_IdVeh.v then
			local veh = getAllVehicles()
			for i = 0, #veh do
				local _, vid = sampGetVehicleIdByCarHandle(veh[i])
				if _ then
					if isCarOnScreen(veh[i]) then
						local x, y, z = getCarCoordinates(veh[i])
						local xw, yw
						if HH_DoorStatus2.v and not HH_NameStatus.v then
							xw, yw = convert3DCoordsToScreen(x, y, z + 0.8)
						elseif not HH_DoorStatus2.v and HH_NameStatus.v then
							xw, yw = convert3DCoordsToScreen(x, y, z + 0.8)
						elseif HH_DoorStatus2.v and HH_NameStatus.v then
							xw, yw = convert3DCoordsToScreen(x, y, z + 1.6)
						elseif not HH_DoorStatus2.v and not HH_NameStatus.v then
							xw, yw = convert3DCoordsToScreen(x, y, z)
						end
						renderFontDrawText(font, '{FFFFFF}ID: {2CB6DD}'..vid, xw, yw, -1)
					end
				end
			end
		end
		
		if HH_OpenStoryWithKey.v then
			if testCheat(HideShowMenu.v) then
				MenuStoryL.v = not MenuStoryL.v
			end
		end
		
		
		if HH_KeyBindAGorivo.v then
			if isKeyJustPressed(VK_NUMPAD1) then
				sampSendChat("/agorivo")
			end
		end
		
		if HH_KeyBindAfkeri.v then
			if isKeyJustPressed(VK_NUMPAD2) then
				sampSendChat("/afkeri")
			end
		end
		
		if HH_KeyBindMaskirani.v then
			if isKeyJustPressed(VK_NUMPAD3) then
				sampSendChat("/maskirani")
			end
		end
		
		
		if HH_KeyBindNoviIgraci.v then
			if isKeyJustPressed(VK_NUMPAD4) then
				sampSendChat("/noviigraci")
			end
		end
		if HH_KeyBindCc.v then
			if isKeyJustPressed(VK_NUMPAD8) then
				sampSendChat("/cc")
			end
		end
		if HH_KeyBindCc2.v then
			if isKeyJustPressed(VK_NUMPAD9) then
				sampSendChat("/cc2")
			end
		end
		
		--TELEPORT >> SAVE / LOAD POSITION
		
		if HH_SaveLoadPort.v then
			if isKeyJustPressed(VK_DIVIDE) then
				if sampDestroy3dText(1000) then
				labelPosition = nil
		else
			
			local posX, posY, posZ = getCharCoordinates(playerPed)
			labelPosition = {posX, posY, posZ}
			sampCreate3dTextEx(1000, 'Load Position', 0xFFFFFFFF, labelPosition[1], labelPosition[2], labelPosition[3], 200.0, true, -1, -1)
		end
	elseif isKeyJustPressed(VK_MULTIPLY) and labelPosition ~= nil then
			if isCharInAnyCar(playerPed) then difference = 0.79 else difference = 1.0 end
			setCharCoordinates(playerPed, labelPosition[1], labelPosition[2], labelPosition[3] - difference)
		end	
	end
		
		if HH_DoorStatus2.v then
			local veh = getAllVehicles()
			for i = 0, #veh do
				local _, vid = sampGetVehicleIdByCarHandle(veh[i])
				if _ then
					if isCarOnScreen(veh[i]) then
						local status
						local door = getCarDoorLockStatus(veh[i])
						if door == 0 then
							status = '{00FF00}Opened'
						else
							status = '{FF0000}Closed'
						end
						local x, y, z = getCarCoordinates(veh[i])
						local xw, yw = convert3DCoordsToScreen(x, y, z)
						renderFontDrawText(font, status, xw, yw, -1)
					end
				end
			end
		end
		
		if HH_NameStatus.v then
			local veh = getAllVehicles()
			for i = 0, #veh do
				local _, vid = sampGetVehicleIdByCarHandle(veh[i])
				if _ then
					if isCarOnScreen(veh[i]) then
						local x, y, z = getCarCoordinates(veh[i])
						local xw, yw
						local model = getCarModel(veh[i])
						model = getNameOfVehicleModel(model)
						if model:find('COACH') then
							model = 'BUS'
						end
						if HH_DoorStatus2.v then
							xw, yw = convert3DCoordsToScreen(x, y, z + 0.8)
						else
							xw, yw = convert3DCoordsToScreen(x, y, z)
						end
						renderFontDrawText(font, '{FFFFFF}Model: {2CB6DD}'..model, xw, yw, -1)
					end
				end
			end
		end
		
		--WEAPONS CHEATS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		
		if HH_AntiStun.v then
    		setCharUsesUpperbodyDamageAnimsOnly(PLAYER_PED, 1)
    	elseif not HH_AntiStun.v then
    		setCharUsesUpperbodyDamageAnimsOnly(PLAYER_PED, 0)
    	end
		
		if HH_FastFire.v then
			for k,v in pairs(pGunsAnimations) do
                setCharAnimSpeed(PLAYER_PED, v, 3.0)
            end
		elseif not HH_FastFire.v then
			for k,v in pairs(pGunsAnimations) do
                setCharAnimSpeed(PLAYER_PED, v, 1.0)
			end
		end
		
		
	if HH_Rapid.v then
			for k,v in pairs(pGunsAnimations) do
                setCharAnimSpeed(PLAYER_PED, v, pRapidSpeed.v)
            end
		elseif not HH_Rapid.v then
			for k,v in pairs(pGunsAnimations) do
                setCharAnimSpeed(PLAYER_PED, v, 1.0)
            end
		end
	
	if HH_FullSkills.v then
			for i = 70, 79 do
                registerIntStat(i, 1000.0)
            end
		elseif not HH_FullSkills.v then
			for i = 70, 79 do
                registerIntStat(i, 0.0)
            end
		end
		
	if HH_InfinityAmmo.v then
    	memory.write(0x969178, 1, 1, true)
    elseif not HH_InfinityAmmo.v then
    	memory.write(0x969178, 0, 1, true)
    end
	
	if HH_NoSpread.v then
    	memory.setfloat(0x8D2E64, 0)
    elseif not HH_NoSpread.v then
    	memory.setfloat(0x8D2E64, pSpreadValue)
    end
	
	if HH_FastDeagle.v then
    	for k,v in pairs(pAnimationDeagle) do
            setCharAnimSpeed(PLAYER_PED, v, 3.0)
       end
    elseif not HH_FastDeagle.v then
		for k,v in pairs(pAnimationDeagle) do
            setCharAnimSpeed(PLAYER_PED, v, 1.0)
        end
    end
		
		
    end
end

function imgui.OnDrawFrame()
	if LogMenu.v then
		local iScreenWidth, iScreenHeight = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(200, 130), imgui.Cond.FirstUseEver)
		imgui.Begin("Admin Menu Log In", _, imgui.WindowFlags.MenuBar)
		
		imgui.InputText("Password", text_password)
		if imgui.Button("Logged In") then
			str2 = text_password.v
			if str2:find("RemiAdmin") then
				adminlog = true
				sampAddChatMessage("{00ba1f}[BS 1.4]: Sucessfull login in the project")
				LogMenu.v = false
				menu.v = true
			end
		end
		
		imgui.End()	
	end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	if StoryMenuLog.v then
		local iScreenWidth, iScreenHeight = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(200, 130), imgui.Cond.FirstUseEver)
		imgui.Begin("Story Life Log In", _, imgui.WindowFlags.MenuBar)
		
		imgui.InputText("Password", LogInStory)
		if imgui.Button("Logged In") then
			str2 = LogInStory.v
			if str2:find("StoryLifeHelper") then
				StoryActivate = true
				sampAddChatMessage("{00ba1f}[BS 1.4]: Sucessfull login in the Story Life Helper")
				StoryMenuLog.v = false
				MenuStoryL.v = true
			end
		end
		
		imgui.End()	
	end
	
	if MenuStoryL.v then
		local iScreenWidth, iScreenHeight = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
		imgui.Begin("Story Life Menu", _, imgui.WindowFlags.MenuBar)
		
		imgui.Text(u8(" Open Menu With Key")); imgui.SameLine(); imgui.ToggleButton("Open Menu With Key", HH_OpenStoryWithKey)	imgui.SameLine();	imgui.Text(u8(" Enter Key"));	imgui.SameLine();	imgui.InputText('##settingsHideCursor', HideShowMenu)
		
		imgui.Text(u8(" /Agorivo KeyBind (NUM1)")); imgui.SameLine(); imgui.ToggleButton("/Agorivo KeyBind (NUM1)", HH_KeyBindAGorivo) 
		imgui.Text(u8(" /Afkeri KeyBind (NUM2)")); imgui.SameLine(); imgui.ToggleButton("/Afkeri KeyBind (NUM2)", HH_KeyBindAfkeri) 
		imgui.Text(u8(" /Maskirani KeyBind (NUM3)")); imgui.SameLine(); imgui.ToggleButton("/Maskirani KeyBind (NUM3)", HH_KeyBindMaskirani) 
		imgui.Text(u8(" /Igraci KeyBind (NUM4)")); imgui.SameLine(); imgui.ToggleButton("/Igraci KeyBind (NUM4)", HH_KeyBindNoviIgraci) 
		imgui.Text(u8(" /cc KeyBind (NUM4)")); imgui.SameLine(); imgui.ToggleButton("/cc KeyBind (NUM4)", HH_KeyBindCc) 
		imgui.Text(u8(" /cc2 KeyBind (NUM4)")); imgui.SameLine(); imgui.ToggleButton("/cc2 KeyBind (NUM4)", HH_KeyBindCc2) 
		
	
		
		
		imgui.End()	
	end
	
    if menu.v then
        local xw, yw = getScreenResolution()
        imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(xw / 2, yw / 2), imgui.Cond.FirstUseEver)
        imgui.Begin('Black Shoot V1.1', menu, imgui.WindowFlags.NoResize)
        imgui.BeginChild('##tabs', imgui.ImVec2(-1, 20))
        if imgui.ButtonActivated(selectedTab == 1, u8'Player Cheat', tabSize) then
            selectedTab = 1
        end
        imgui.SameLine()
        if imgui.ButtonActivated(selectedTab == 2, u8'Vehicle Cheat', tabSize) then
            selectedTab = 2
        end
        imgui.SameLine()
        if imgui.ButtonActivated(selectedTab == 3, u8'Weapon Cheat', tabSize) then
            selectedTab = 3
        end
		imgui.SameLine()
        if imgui.ButtonActivated(selectedTab == 4, u8'About me', tabSize) then
            selectedTab = 4
        end
		--imgui.SameLine()
        --if imgui.ButtonActivated(selectedTab == 4, u8'Console', tabSize) then
        --    selectedTab = 5
        --end
        imgui.EndChild()
        imgui.Separator()
        imgui.BeginChild('##options', imgui.ImVec2(-1, -1))
        if selectedTab == 1 then
			imgui.Text("-----------------------------------------------Player Cheat------------------------------------------------")
			 imgui.Text(u8(" GM")); imgui.SameLine(); imgui.ToggleButton("GM", HH_GM)
			 imgui.Text(u8(" Infinity Run")); imgui.SameLine(); imgui.ToggleButton("Infinity Run", HH_InfinityRun)
			 imgui.Text(u8(" No Fall")); imgui.SameLine(); imgui.ToggleButton("No Fall", HH_NoFall)
			  
			  
			  imgui.Text(u8(" Save Teleport&Load Teleport")); imgui.SameLine(); imgui.ToggleButton("Save Teleport&Load Teleport", HH_SaveLoadPort)
			  imgui.Text(u8(" Fast Walk")); imgui.SameLine(); imgui.ToggleButton("Fast Walk", HH_FastWalk)
			  imgui.Text(u8(" Invisible")); imgui.SameLine(); imgui.ToggleButton("Invisible", HH_Invisible)
			  imgui.Text(u8(" Surf Player")); imgui.SameLine(); imgui.ToggleButton("Surf Player", HH_Surfer)			  
			  imgui.Text(u8(" AirBreak")); imgui.SameLine(); imgui.ToggleButton("AirBreak", HH_AirBreak)
			  imgui.Text(u8(" Mega Jump")); imgui.SameLine(); imgui.ToggleButton("Mega Jump", HH_MegaJump)
			  imgui.Text(u8(" 160 HP")); imgui.SameLine(); imgui.ToggleButton("160 HP", HH_160HP)
			 
			 if imgui.Button('JetPack') then
			 lua_thread.create(function()
			 jp = 0
			 jp = jp + 5
			if jp < 8 then
				sampSetSpecialAction(2)
				sampAddChatMessage("{00ba1f}[BS 1.4]: Sucessfull get JetPack!")
				else sampSetSpecialAction(0); jp = 0
			end
			 
			 end)
			 end
			 
			 imgui.Text(u8(" Ghost Mode")); imgui.SameLine(); imgui.ToggleButton("Ghost Mode", HH_PCollision)
			  --imgui.Button('Vehicle Collision')
			  
			 imgui.Text(u8(" Object Collision")); imgui.SameLine(); imgui.ToggleButton("Object Collision", HH_ObjectCollision)
			 
			 -- imgui.ToggleButton("Fast Deagle", HH_FastDeagle)
			  --imgui.Button('Infinite Oxygen')
			  --imgui.Button('Respawn')
			  imgui.Text(u8(" Auto Reconnect (Only Banned)")); imgui.SameLine(); imgui.ToggleButton("Auto Reconnect(ONLY BANNED)", HH_ReconnectBan)
			  
			  
			 if imgui.Button('Clear Chat') then
			 
		          sampAddChatMessage('', -1)
		          sampAddChatMessage('', -1)
		          sampAddChatMessage('', -1)
		          sampAddChatMessage('', -1)
		          sampAddChatMessage('', -1)
		          sampAddChatMessage('', -1)
		          sampAddChatMessage('', -1)
		          sampAddChatMessage('', -1)
		          sampAddChatMessage('', -1)
		          sampAddChatMessage('', -1)
		          sampAddChatMessage('', -1)
		          sampAddChatMessage('', -1)
				  
			  end
			  
			  if imgui.Button('UnLoad Script') then
				sampToggleCursor(false)
				showCursor(false)
				thisScript():unload()
				sampAddChatMessage("{00ba1f}[BS 1.4]: Sucessfull UnLoad script")
			  end
        end 
        if selectedTab == 2 then
			imgui.Text("-----------------------------------------------Vehicle Cheat-----------------------------------------------")
			  imgui.Text(u8(" GM Car")); imgui.SameLine(); imgui.ToggleButton("GM Car", HH_GMCar)
			  imgui.Text(u8(" Easy Drive")); imgui.SameLine(); imgui.ToggleButton("Easy Drive", HH_EasyDrive)
			  imgui.Text(u8(" RepairCar [5]")); imgui.SameLine(); imgui.ToggleButton('RepairCar [5]', HH_repair)
			  imgui.Text(u8(" CarShot")); imgui.SameLine(); imgui.ToggleButton("CarShot", HH_CarShot)
			  imgui.Text(u8(" Break Dance")); imgui.SameLine(); imgui.ToggleButton("Break Dance", HH_BreakDance)
			  --imgui.Button('Fast Exit [N]')
			  imgui.Text(u8(" Speed Hack [ALT]")); imgui.SameLine(); imgui.ToggleButton("Speed Hack [ALT]", HH_SpeedHack)
			  imgui.Text(u8(" Break Dance")); imgui.SameLine(); imgui.ToggleButton("Car Jump [B]", HH_CarJump)
			  imgui.Text(u8(" Car Jump [B]")); imgui.SameLine(); imgui.ToggleButton('Vehicle Name Status', HH_NameStatus)
			  imgui.Text(u8(" Door Status")); imgui.SameLine(); imgui.ToggleButton('Door Status', HH_DoorStatus2)
			  imgui.Text(u8(" Vehicle ID Status")); imgui.SameLine(); imgui.ToggleButton('Vehicle ID Status', HH_IdVeh)
        end
        if selectedTab == 3 then
			imgui.Text("-----------------------------------------------Weapon Cheat------------------------------------------------")
			imgui.Text(u8(" Infinity Ammo")); imgui.SameLine(); imgui.ToggleButton("Infinity Ammo", HH_InfinityAmmo)
			imgui.Text(u8(" No Spread")); imgui.SameLine(); imgui.ToggleButton("No Spread", HH_NoSpread)
			imgui.Text(u8(" Fast Deagle")); imgui.SameLine(); imgui.ToggleButton("Fast Deagle", HH_FastDeagle)
			imgui.Text(u8(" Full Skills")); imgui.SameLine(); imgui.ToggleButton("Full Skills", HH_FullSkills)
			imgui.Text(u8(" Fast Fire")); imgui.SameLine(); imgui.ToggleButton("Fast Fire", HH_FastFire)
			imgui.Text(u8(" Rapid Fire")); imgui.SameLine(); imgui.ToggleButton("Rapid Fire", HH_Rapid)
			imgui.Text(u8(" Rapid Speed")); imgui.SameLine(); imgui.SliderInt('Rapid Speed', pRapidSpeed, 0, 50)
        end
		if selectedTab == 4 then
			imgui.Text("-----------------------------------------------About Me----------------------------------------------------")
			imgui.Text("\n\n")
			imgui.TextColoredRGB('{00B34C} Credits: REMI')
			imgui.Text("\n")
			imgui.TextColoredRGB('{00B34C} Discord: MultiFun#0732')
		end
		if selectedTab == 5 then
		end
        imgui.EndChild()
        imgui.End()
    end
end

function samp_create_sync_data(sync_type, copy_from_player)
    local ffi = require 'ffi'
    local sampfuncs = require 'sampfuncs'
    -- from SAMP.Lua
    local raknet = require 'samp.raknet'
    --require 'samp.synchronization'

    copy_from_player = copy_from_player or true
    local sync_traits = {
        player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
        vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
        passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
        aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
        trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
        unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
        bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
        spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
    }
    local sync_info = sync_traits[sync_type]
    local data_type = 'struct ' .. sync_info[1]
    local data = ffi.new(data_type, {})
    local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))
    -- copy player's sync data to the allocated memory
    if copy_from_player then
        local copy_func = sync_info[3]
        if copy_func then
            local _, player_id
            if copy_from_player == true then
                _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            else
                player_id = tonumber(copy_from_player)
            end
            copy_func(player_id, raw_data_ptr)
        end
    end
    -- function to send packet
    local func_send = function()
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, sync_info[2])
        raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
        raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
        raknetDeleteBitStream(bs)
    end
    -- metatable to access sync data and 'send' function
    local mt = {
        __index = function(t, index)
            return data[index]
        end,
        __newindex = function(t, index, value)
            data[index] = value
        end
    }
    return setmetatable({send = func_send}, mt)
end

function darkgreentheme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    style.WindowPadding = imgui.ImVec2(8, 8)
    style.WindowRounding = 6
    style.ChildWindowRounding = 5
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 3.0
    style.ItemSpacing = imgui.ImVec2(5, 4)
    style.ItemInnerSpacing = imgui.ImVec2(4, 4)
    style.IndentSpacing = 21
    style.ScrollbarSize = 10.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 8
    style.GrabRounding = 1
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    colors[clr.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.60, 0.60, 0.60, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.08, 0.08, 0.08, 1.00)
    colors[clr.ChildWindowBg]          = ImVec4(0.10, 0.10, 0.10, 1.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 1.00)
    colors[clr.Border]                 = ImVec4(0.70, 0.70, 0.70, 0.40)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]                = ImVec4(0.15, 0.15, 0.15, 1.00)
    colors[clr.FrameBgHovered]         = ImVec4(0.19, 0.19, 0.19, 0.71)
    colors[clr.FrameBgActive]          = ImVec4(0.34, 0.34, 0.34, 0.79)
    colors[clr.TitleBg]                = ImVec4(0.00, 0.69, 0.33, 0.80)
    colors[clr.TitleBgActive]          = ImVec4(0.00, 0.74, 0.36, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.69, 0.33, 0.50)
    colors[clr.MenuBarBg]              = ImVec4(0.00, 0.80, 0.38, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.16, 0.16, 0.16, 1.00)
    colors[clr.ScrollbarGrab]          = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.00, 0.82, 0.39, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.00, 1.00, 0.48, 1.00)
    colors[clr.ComboBg]                = ImVec4(0.20, 0.20, 0.20, 0.99)
    colors[clr.CheckMark]              = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.00, 0.77, 0.37, 1.00)
    colors[clr.Button]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.ButtonHovered]          = ImVec4(0.00, 0.82, 0.39, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.00, 0.87, 0.42, 1.00)
    colors[clr.Header]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.HeaderHovered]          = ImVec4(0.00, 0.76, 0.37, 0.57)
    colors[clr.HeaderActive]           = ImVec4(0.00, 0.88, 0.42, 0.89)
    colors[clr.Separator]              = ImVec4(1.00, 1.00, 1.00, 0.40)
    colors[clr.SeparatorHovered]       = ImVec4(1.00, 1.00, 1.00, 0.60)
    colors[clr.SeparatorActive]        = ImVec4(1.00, 1.00, 1.00, 0.80)
    colors[clr.ResizeGrip]             = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.ResizeGripHovered]      = ImVec4(0.00, 0.76, 0.37, 1.00)
    colors[clr.ResizeGripActive]       = ImVec4(0.00, 0.86, 0.41, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.00, 0.82, 0.39, 1.00)
    colors[clr.CloseButtonHovered]     = ImVec4(0.00, 0.88, 0.42, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.00, 1.00, 0.48, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(0.00, 0.74, 0.36, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(0.00, 0.80, 0.38, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.00, 0.69, 0.33, 0.72)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.17, 0.17, 0.17, 0.48)
end
darkgreentheme()

--Addons For Project
function imgui.TextColoredRGB(string, max_float)

	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local u8 = require 'encoding'.UTF8

	local function color_imvec4(color)
		if color:upper():sub(1, 6) == 'SSSSSS' then return imgui.ImVec4(colors[clr.Text].x, colors[clr.Text].y, colors[clr.Text].z, tonumber(color:sub(7, 8), 16) and tonumber(color:sub(7, 8), 16)/255 or colors[clr.Text].w) end
		local color = type(color) == 'number' and ('%X'):format(color):upper() or color:upper()
		local rgb = {}
		for i = 1, #color/2 do rgb[#rgb+1] = tonumber(color:sub(2*i-1, 2*i), 16) end
		return imgui.ImVec4(rgb[1]/255, rgb[2]/255, rgb[3]/255, rgb[4] and rgb[4]/255 or colors[clr.Text].w)
	end

	local function render_text(string)
		for w in string:gmatch('[^\r\n]+') do
			local text, color = {}, {}
			local render_text = 1
			local m = 1
			if w:sub(1, 8) == '[center]' then
				render_text = 2
				w = w:sub(9)
			elseif w:sub(1, 7) == '[right]' then
				render_text = 3
				w = w:sub(8)
			end
			w = w:gsub('{(......)}', '{%1FF}')
			while w:find('{........}') do
				local n, k = w:find('{........}')
				if tonumber(w:sub(n+1, k-1), 16) or (w:sub(n+1, k-3):upper() == 'SSSSSS' and tonumber(w:sub(k-2, k-1), 16) or w:sub(k-2, k-1):upper() == 'SS') then
					text[#text], text[#text+1] = w:sub(m, n-1), w:sub(k+1, #w)
					color[#color+1] = color_imvec4(w:sub(n+1, k-1))
					w = w:sub(1, n-1)..w:sub(k+1, #w)
					m = n
				else w = w:sub(1, n-1)..w:sub(n, k-3)..'}'..w:sub(k+1, #w) end
			end
			local length = imgui.CalcTextSize(u8(w))
			if render_text == 2 then
				imgui.NewLine()
				imgui.SameLine(max_float / 2 - ( length.x / 2 ))
			elseif render_text == 3 then
				imgui.NewLine()
				imgui.SameLine(max_float - length.x - 5 )
			end
			if text[0] then
				for i, k in pairs(text) do
					imgui.TextColored(color[i] or colors[clr.Text], u8(k))
					imgui.SameLine(nil, 0)
				end
				imgui.NewLine()
			else imgui.Text(u8(w)) end
		end
	end

	render_text(string)
end

function imgui.ButtonActivated(activated, ...)
    if activated then
        imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.CheckMark])

            imgui.Button(...)

        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()

    else
        return imgui.Button(...)
    end
end


-----OPEN MENU

function MenuOpen()
	if adminlog == false then
		LogMenu.v = not LogMenu.v
	elseif	adminlog == true then
		menu.v = not menu.v
	end
end





function StoryLifeOpen()
	if StoryActivate == false then
		StoryMenuLog.v = not StoryMenuLog.v
	elseif StoryActivate == true then
		MenuStoryL.v = not MenuStoryL.v
	end

end
 
--[[
 
function MenuOpenLogin()
	if adminlog == true then
		menu.v = not menu.v
	end
end

--]]

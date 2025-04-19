--TODO :
--      move the head then move the tail to the postion the head moved from.
--      if atefood then move a new segment from the stack to behind the head and don't remove the tail. 

-- cfguration
local cfg = {
    
    -- GUI IDs
    mainMenuId = 31450,
    gameOverId = 31451,
    
    --seconds between snake updates (travel speed)
    updateInterval = .3,
    initialSnakeLength = 3,
    
    stagingLocation = {
        x = 120.0,
        y = 120.0,
        z = -50
    },
    
    --scales 
    headScale = 1,
    bodyScale = .6,
    foodScale = 1.5,
    wallScale = -2000, --negative to invert the rectnagular stone block so we see the texture on the inside
    borderScale = 2,
    floorScale = 10,
    
    --sounds
    eatFoodSound = "Swallow",
    moveSound = "corpDRAG",
    
    --cell used
    roomCell = "Vor Lair, Interior",
    --location in cell
    roomPosition = {x = 0, y = 0, z = 0},
    wallPosition = {x = 120, y = 120, z = 0},
    --size of the game grid
    roomSize = 16,
    
    objects = {
        snakeHead = "b_n_imperial_m_head_01",
        snakeBody = "ingred_6th_corprusmeat_07",
        food = {
                    "rotating_skooma",
                    "rotating_skooma_pipe",
                    "rotating_moonsugar"
                },
        wall = "potion_skooma_01",
        floor = "in_lava_1024",
        border = "misc_dwrv_ark_cube00"
        -- border = "light_de_lantern_14"
    },
    --bring the skooma bottle up to floor level
    rotating_skooma_height_offset = 14,
    
    -- Specific rotations for the head
    headRotations = {
        raise = { rotX = 0, rotY = 0, rotZ = 180 },
        up = { rotX = 0, rotY = 0, rotZ = 180 },
        down = { rotX = 0, rotY = 0, rotZ = 0 },
        lower = { rotX = 0, rotY = 0, rotZ = 0 },
        left = { rotX = 0, rotY = 0, rotZ = 90 },
        right = { rotX = 0, rotY = 0, rotZ = 270 }
    },
    -- Player platform position
    platformPosition = {
        x = 120,
        y = -4,
        z = 0
    },
    commands = {
        start = "snake",
        stop = "stop",
        up = "raise",
        down = "lower",
        left = "left",
        right = "right"
    },
    
    foodCollision = true,
    initFood = true,
    initializing = false,
    
    --  "vo\\w\\m\\atk_wm002.mp3" fetcher bosmer
    --  "vo\\w\\m\\hit_wm005.mp3" stupid bosmer
    --  "vo\\o\\m\\hit_om009.mp3" orc fetcher
    
    -- Food-specific voice lines
    foodVoiceLines = {
        ["rotating_skooma"] = {
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "vo\\d\\m\\tidl_dm015.mp3", -- dunmer burp
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "vo\\k\\m\\idl_km001.mp3", -- sweet skooma
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "vo\\n\\m\\hit_nm005.mp3", -- nord groan
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "Vo\\o\\m\\Idl_OM005.mp3",   -- orc sniff
            -- "Vo\\o\\m\\hit_om007.mp3", -- orc noise
            -- "Vo\\o\\m\\hit_om006.mp3", -- orcnoise
        },
        ["rotating_skooma_pipe"] = {
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "vo\\d\\m\\idl_dm001.mp3", -- dunmer
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "vo\\h\\m\\idl_hm008.mp3", -- altmer clear throat
            "vo\\h\\m\\idl_hm007.mp3", -- altmer hummmmm
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "Vo\\i\\m\\Idl_IM004.mp3",  --imperial clear throat
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "Vo\\i\\m\\Idl_IM009.mp3",  --imperial clear throat
            "vo\\k\\m\\idl_km001.mp3", -- sweet skooma
            "vo\\n\\m\\idl_nm002.mp3", -- nord cough
            "vo\\n\\m\\idl_nm004.mp3", -- nord cough
            "vo\\n\\m\\idl_nm007.mp3", -- nord cough
            "vo\\r\\m\\idl_rm009.mp3", -- redguard cough
            "vo\\w\\m\\idl_wm002.mp3", -- bosmer cough
            "Vo\\o\\m\\idl_om006.mp3", -- orc cough
            "Vo\\o\\m\\idl_om007.mp3", -- orc clear throat
            -- "Vo\\o\\m\\hit_om007.mp3", -- orc noise
            -- "Vo\\o\\m\\hit_om006.mp3", -- orcnoise
        },
        ["rotating_moonsugar"] = {
            "Vo\\o\\m\\Idl_OM005.mp3",   -- orc sniff
            "Vo\\i\\m\\Idl_IM001.mp3",  --imperial sniff
            "Vo\\i\\m\\Idl_IM002.mp3",
            "Vo\\o\\m\\Idl_OM005.mp3",   -- orc sniff
            "vo\\d\\m\\idl_dm002.mp3", --dunmer
            "Vo\\o\\m\\Idl_OM005.mp3",   -- orc sniff
            "vo\\a\\m\\hlo_am056.mp3", -- argonian
            "Vo\\o\\m\\Idl_OM005.mp3",   -- orc sniff
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "vo\\b\\m\\idl_bm009.mp3", --breton
            "vo\\h\\m\\idl_hm009.mp3", -- altmer sniff
            "vo\\k\\m\\idl_km004.mp3", -- khajiit sniff
            "vo\\k\\m\\hlo_km133.mp3", -- our sugar is yours friend
            "vo\\k\\m\\hlo_km120.mp3", -- welcome friend, share some sugar?
            "vo\\n\\m\\sweetshare03.mp3", -- when the sugar is warmed by the pale hearth light, the happiness spreads throughout the night!
            "vo\\k\\m\\idl_km009.mp3", -- sweet moon sugar.
            "vo\\k\\m\\hlo_km091.mp3", -- some sugar for you, friend?
            "vo\\n\\m\\idl_nm003.mp3", -- nord sniff
            "vo\\n\\m\\sweetshare03.mp3", -- when the sugar is warmed by the pale hearth light, the happiness spreads throughout the night!
            "vo\\r\\m\\idl_rm008.mp3", -- redguard sniff
            "vo\\w\\m\\idl_wm001.mp3", -- bosmer sniff
        },
    }
    
}

-- Global state
SnakeGame = {
    activePlayers = {},
    gameObjects = {},
    timers = {}
}

local SNAKEGAMEJSONPATH = "custom/snakeGameCellData.json"

-- Helper function to convert degrees to radians
local function degToRad(degrees)
    return degrees * math.pi / 180
end

local function setScale(pid, cellDescription, uniqueIndex, refId, scale)

    tes3mp.ClearObjectList()
    tes3mp.SetObjectListPid(pid)
    tes3mp.SetObjectListCell(cfg.roomCell)
    local splitIndex = uniqueIndex:split("-")
    tes3mp.SetObjectRefNum(splitIndex[1])
    tes3mp.SetObjectMpNum(splitIndex[2])
    tes3mp.SetObjectRefId(refId)
    tes3mp.SetObjectScale(scale)
    tes3mp.AddObject()
    tes3mp.SendObjectScale(true, false)
    
end

local function DeleteObject(pid, cellDescription, uniqueIndex, forEveryone)
    tes3mp.ClearObjectList()
    tes3mp.SetObjectListPid(pid)
    tes3mp.SetObjectListCell(cellDescription)
    local splitIndex = uniqueIndex:split("-")
    tes3mp.SetObjectRefNum(splitIndex[1])
    tes3mp.SetObjectMpNum(splitIndex[2])
    tes3mp.AddObject()
    tes3mp.SendObjectDelete(forEveryone)
end

local function ResendPlace(pid, uniqueIndex, cellDescription, forEveryone)
    
    tes3mp.ClearObjectList()
    tes3mp.SetObjectListPid(pid)
    tes3mp.SetObjectListCell(cellDescription)
    
    local object = LoadedCells[cellDescription].data.objectData[uniqueIndex]
    if not object then 
        tes3mp.LogMessage(enumerations.log.ERROR, "[SnakeGame] ResendPlace: Object " .. uniqueIndex .. " not found in cell " .. cellDescription)
        return 
    end
    
    if object and object.location and object.refId then
        local splitIndex = uniqueIndex:split("-")
        tes3mp.SetObjectRefNum(splitIndex[1])
        tes3mp.SetObjectMpNum(splitIndex[2])
        tes3mp.SetObjectRefId(object.refId)
        
        -- Set the position and rotation
        tes3mp.SetObjectPosition(object.location.posX, object.location.posY, object.location.posZ)
        tes3mp.SetObjectRotation(object.location.rotX, object.location.rotY, object.location.rotZ)
        
        -- Set scale if present
        if object.scale then
            tes3mp.SetObjectScale(object.scale)
        else
            tes3mp.SetObjectScale(1.0)
        end
        
        tes3mp.AddObject()
        
        -- Send ObjectMove instead of ObjectPlace to avoid recreating the object
        tes3mp.SendObjectMove(forEveryone, false)
        tes3mp.SendObjectRotate(forEveryone, false)
        
        if object.scale and object.scale ~= 1 then
            tes3mp.SendObjectScale(forEveryone, false)
        end
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] ResendPlace: Moved object " .. uniqueIndex .. " (" .. object.refId .. ") to position " .. 
            object.location.posX .. ", " .. object.location.posY .. ", " .. object.location.posZ)
    else
        tes3mp.LogMessage(enumerations.log.ERROR, "[SnakeGame] ResendPlace: Invalid object data for " .. uniqueIndex)
    end
end

local function createObjects(cellDescription, objectsToCreate, packetType, temp_object_uniqueIndex)
    -- local uniqueIndexes = {}
    local generatedRecordIdsPerType = {}
    local unloadCellAtEnd = false
    local shouldSendPacket = false
    local uniqueIndex
    local isValid

    -- If the desired cell is not loaded, load it temporarily
    if LoadedCells[cellDescription] == nil then
        logicHandler.LoadCell(cellDescription)
        unloadCellAtEnd = true
    end

    local cell = LoadedCells[cellDescription]

    -- Only send a packet if there are players on the server to send it to
    -- if tableHelper.getCount(Players) > 0 then
        shouldSendPacket = true
        tes3mp.ClearObjectList()
    -- end

    for _, object in pairs(objectsToCreate) do

        local refId = object.refId
        local count = object.count
        local charge = object.charge
        local enchantmentCharge = object.enchantmentCharge
        local soul = object.soul
        local location = object.location
        -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "object.refId: " .. tostring(object.refId))
        -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "object.scale: " .. tostring(object.scale))
        if object.scale == nil then object.scale = 1 end
        local scale = object.scale
        
        local mpNum
        
-----------------------------------------------------------------------------------------------------------------------------------------------------
        -- set the uniqueIndex to the one we passed in.
        -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "temp_object_uniqueIndex: " .. temp_object_uniqueIndex)
        -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "cfg.initializing: " .. tostring(cfg.initializing))
        if cfg.initializing then 
            mpNum = WorldInstance:GetCurrentMpNum() + 1
            uniqueIndex =  0 .. "-" .. mpNum
            isValid = true
        else
            tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "WHO THE FUCK SHIT MY PANTS.")
            local splitIndex = temp_object_uniqueIndex:split("-")

            mpNum = splitIndex[2]
            uniqueIndex =  0 .. "-" .. mpNum
            isValid = true
        end
-----------------------------------------------------------------------------------------------------------------------------------------------------

        -- Is this object based on a a generated record? If so, it needs special
        -- handling here and further below
        if logicHandler.IsGeneratedRecord(refId) then

            local recordType = logicHandler.GetRecordTypeByRecordId(refId)

            if RecordStores[recordType] ~= nil then

                -- Add a link to this generated record in the cell it is being placed in
                cell:AddLinkToRecord(recordType, refId, uniqueIndex)

                if generatedRecordIdsPerType[recordType] == nil then
                    generatedRecordIdsPerType[recordType] = {}
                end

                if shouldSendPacket and not tableHelper.containsValue(generatedRecordIdsPerType[recordType], refId) then
                    table.insert(generatedRecordIdsPerType[recordType], refId)
                end
            else
                isValid = false
                tes3mp.LogMessage(enumerations.log.ERROR, "Attempt at creating object " .. refId ..
                    " based on non-existent generated record")
            end
        end

        if isValid then

            -- table.insert(uniqueIndexes, uniqueIndex)
            WorldInstance:SetCurrentMpNum(mpNum)
            tes3mp.SetCurrentMpNum(mpNum)

            cell:InitializeObjectData(uniqueIndex, refId)
            cell.data.objectData[uniqueIndex].location = location
            cell.data.objectData[uniqueIndex].scale = scale

            if packetType == "place" then
                table.insert(cell.data.packets.place, uniqueIndex)
            elseif packetType == "spawn" then
                table.insert(cell.data.packets.spawn, uniqueIndex)
                table.insert(cell.data.packets.actorList, uniqueIndex)
                -- if periodicCellResets.actor_spawn_tracker[cellDescription] == nil then
                --     periodicCellResets.actor_spawn_tracker[cellDescription] = {}
                --     table.insert(periodicCellResets.actor_spawn_tracker[cellDescription], uniqueIndex)
                --     tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. tostring(uniqueIndex) .. "was added to periodically.actor_spawn_tracker from modified_create_objects. \n")
                -- else
                --     table.insert(periodicCellResets.actor_spawn_tracker[cellDescription], uniqueIndex)
                --     tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. tostring(uniqueIndex) .. "was added to periodically.actor_spawn_tracker from modified_create_objects. \n")
                -- end
            end

            -- Are there any players on the server? If so, initialize the object
            -- list for the first one we find and just send the corresponding packet
            -- to everyone
            if shouldSendPacket then

                -- local pid = tableHelper.getAnyValue(Players).pid
                -- tes3mp.SetObjectListPid(pid)
                tes3mp.SetObjectListCell(cellDescription)
                tes3mp.SetObjectRefId(refId)
                tes3mp.SetObjectRefNum(0)
                tes3mp.SetObjectMpNum(mpNum)

                if packetType == "place" then
                    tes3mp.SetObjectCount(count)
                    tes3mp.SetObjectCharge(charge)
                    tes3mp.SetObjectEnchantmentCharge(enchantmentCharge)
                    tes3mp.SetObjectSoul(soul)
                end

                tes3mp.SetObjectPosition(location.posX, location.posY, location.posZ)
                tes3mp.SetObjectRotation(location.rotX, location.rotY, location.rotZ)
                -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "scale: " .. tostring(scale))
                tes3mp.SetObjectScale(scale)
                tes3mp.AddObject()
                
                if scale ~= 1 then
              		  tableHelper.insertValueIfMissing(LoadedCells[cellDescription].data.packets.scale, uniqueIndex)
              	end
            end
        end
    end

    if shouldSendPacket then

        -- Ensure the visitors to this cell have the records they need for the
        -- objects we've created
        for priorityLevel, recordStoreTypes in ipairs(config.recordStoreLoadOrder) do
            for _, recordType in ipairs(recordStoreTypes) do
                if generatedRecordIdsPerType[recordType] ~= nil then

                    local recordStore = RecordStores[recordType]

                    if recordStore ~= nil then

                        local idArray = generatedRecordIdsPerType[recordType]

                        for _, visitorPid in pairs(cell.visitors) do
                            recordStore:LoadGeneratedRecords(visitorPid, recordStore.data.generatedRecords, idArray)
                        end
                    end
                end
            end
        end

        if packetType == "place" then
            tes3mp.SendObjectPlace(true, false)
            -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "scale: " .. tostring(scale))
            tes3mp.SendObjectRotate(true, false)
            tes3mp.SendObjectScale(true, false)
        elseif packetType == "spawn" then
            tes3mp.SendObjectSpawn(true)
        end
    end

    -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "LoadedCells[cellDescription].data.packets.scale: " .. tostring(LoadedCells[cellDescription].data.packets.scale))
    -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "uniqueIndex: " .. tostring(temp_object_uniqueIndex))
    -- tableHelper.print(LoadedCells[cellDescription].data.packets.scale)
    -- tableHelper.print(LoadedCells[cellDescription].data.objectData[temp_object_uniqueIndex])

    cell:Save() --TODO re enable this if thigs aren't saving ( or use QuicksaveToDrive )
    -- cell:QuicksaveToDrive()

    if unloadCellAtEnd then
        logicHandler.UnloadCell(cellDescription)
    end
    

    return uniqueIndex
end

-- Stop game and clean up
local function stopGame(pid)
    local playerName = tes3mp.GetName(pid)
    
    if SnakeGame.timers[playerName] then
        tes3mp.StopTimer(SnakeGame.timers[playerName])
        SnakeGame.timers[playerName] = nil
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Stopped timer for " .. playerName)
    end
    
    if SnakeGame.gameObjects[playerName] then
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Moving " .. #SnakeGame.gameObjects[playerName] .. " objects back to staging area for " .. playerName)
        
        -- Set up a single common staging location far away from the game area
        local stagingLocation = cfg.stagingLocation
        
        for i = #SnakeGame.gameObjects[playerName], 1, -1 do
            local object = SnakeGame.gameObjects[playerName][i]
            if object and object.uniqueIndex and logicHandler.IsCellLoaded(object.cell) then
                -- Move the object back to staging area
                if LoadedCells[object.cell].data.objectData[object.uniqueIndex] then
                    LoadedCells[object.cell].data.objectData[object.uniqueIndex].location = {
                        posX = stagingLocation.x,
                        posY = stagingLocation.y,
                        posZ = stagingLocation.z,
                        rotX = 0,
                        rotY = 0,
                        rotZ = 0
                    }
                    if LoadedCells[object.cell].data.objectData[object.uniqueIndex].refId == cfg.objects.snakeHead then
                        -- move head back to starting position
                        LoadedCells[object.cell].data.objectData[object.uniqueIndex].location = {
                            posX = stagingLocation.x,
                            posY = stagingLocation.y,
                            posZ = cfg.roomPosition.z + 9.5,
                            rotX = math.rad(cfg.headRotations.right.rotX),
                            rotY = math.rad(cfg.headRotations.right.rotY),
                            rotZ = math.rad(cfg.headRotations.right.rotZ)
                        }
                    end
                    
                    ResendPlace(pid, object.uniqueIndex, object.cell, true)
                    
                    tes3mp.LogMessage(enumerations.log.INFO, 
                        "[SnakeGame] Moved " .. object.type .. " back to staging area")
                else
                    tes3mp.LogMessage(enumerations.log.WARN, 
                        "[SnakeGame] Could not find object " .. object.uniqueIndex .. " in cell " .. object.cell)
                end
            end
        end
        
        SnakeGame.gameObjects[playerName] = nil
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Cleared all tracked objects for " .. playerName)
    end
    
    SnakeGame.activePlayers[playerName] = nil
    
    logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerControls", false)
    logicHandler.RunConsoleCommandOnPlayer(pid, "EnableVanityMode", false)
    logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerViewSwitch", false)
    
    tes3mp.MessageBox(pid, -1, "Snake Game ended.")
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Game stopped for " .. playerName)
end

local function OnPlayerDisconnectHandler(eventStatus, pid)
    stopGame(pid)
end

-- Handle game over
local function gameOver(pid, reason)
    local playerName = string.lower(Players[pid].accountName)
    local gameState = SnakeGame.activePlayers[playerName]
    
    if gameState then
        gameState.gameOver = true
        -- tes3mp.MessageBox(pid, -1, message .. " Score: " .. gameState.score)
        --  -- Show game over message
        local message = reason .. "\nFinal Score: " .. gameState.score
        tes3mp.CustomMessageBox(pid, cfg.gameOverId, "Game Over\n" .. color.Red .. message,
                                color.Green .. "Play Again;" ..
                                color.Yellow .. "Quit")
        -- stopGame(pid)
    end
end

-- Place food at a random position
local function placeFood(pid)
    local playerName = string.lower(Players[pid].accountName)
    local gameState = SnakeGame.activePlayers[playerName]
    
    local foodPos = {x = math.random(0, cfg.roomSize - 1), y = math.random(0, cfg.roomSize - 1)}
    
    for _, segment in ipairs(gameState.snake) do
        if foodPos.x == segment.x and foodPos.y == segment.y then
            placeFood(pid) -- Recursive call if food spawns on snake
            return
        end
    end
    
    gameState.food = foodPos
end

-- Start game timer
local function startGameTimer(pid)
    local playerName = string.lower(Players[pid].accountName)
    
    if SnakeGame.timers[playerName] then
        tes3mp.StopTimer(SnakeGame.timers[playerName])
    end
    
    SnakeGame.timers[playerName] = tes3mp.CreateTimerEx("UpdateGame", 
                                                        math.floor(cfg.updateInterval * 1000), 
                                                        "i", 
                                                        pid)
    
    tes3mp.StartTimer(SnakeGame.timers[playerName])
end

-- Build the game room with walls
local function buildGameRoom(pid)
    local playerName = string.lower(Players[pid].accountName)
    local cellDescription = cfg.roomCell
    
    SnakeGame.gameObjects[playerName] = SnakeGame.gameObjects[playerName] or {}
    

    local wallLocation = {
        posX = cfg.wallPosition.x,
        posY = cfg.wallPosition.y,
        posZ = cfg.wallPosition.z,
        rotX = degToRad(-180),
        rotY = 0,
        rotZ = 0
    }
    
    local wallObject = {
        refId = cfg.objects.wall,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = ""
    }
    
    local wallIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                         wallLocation, 
                                                         wallObject, 
                                                         "place")
    
    
    setScale(pid, cellDescription, wallIndex,wallObject.refId, cfg.wallScale)
    
    table.insert(SnakeGame.gameObjects[playerName], {
        uniqueIndex = wallIndex,
        cell = cellDescription,
        type = "wall"
    })
    
    tes3mp.LogMessage(enumerations.log.INFO, 
                    "[SnakeGame] Placed wall at (" .. cfg.roomPosition.x .. "," .. cfg.roomPosition.y .. ",0)")
    
    local floorLocation = {
        posX = cfg.roomPosition.x,
        posY = cfg.roomPosition.y, 
        posZ = cfg.roomPosition.z - 23, -- Slightly below ground
        rotX = 0,
        rotY = 0,
        rotZ = 0
    }
        
    local floorObject = {
        refId = cfg.objects.floor, -- A flat object for the floor
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = "",
        scale = 1
    }
    
    local floorIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                               floorLocation, 
                                               floorObject, 
                                               "place")
    
    table.insert(SnakeGame.gameObjects[playerName], {
        uniqueIndex = floorIndex,
        cell = cellDescription,
        type = "floor"
    })
    
    -- Place markers along the full square border instead of just corners
    local size = cfg.roomSize
    local step = 1  -- step size in grid units
    
    local markerObject = {
        refId = cfg.objects.border,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = "",
    }
    
    for x = -1, size, step do
        for y = -1, size, step do
            -- Check if the current point is on the border
            if x == -1 or x == size or y == -1 or y == size then
                local markerLocation = {
                    posX = cfg.roomPosition.x + (x * 16),
                    posY = cfg.roomPosition.y + (y * 16),
                    posZ = cfg.roomPosition.z + 8,
                    rotX = 0,
                    rotY = 0,
                    rotZ = 0
                }
    
                local markerIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                         markerLocation, 
                                                         markerObject, 
                                                         "place")
                
                setScale(pid, cellDescription, markerIndex, markerObject.refId, cfg.borderScale)
    
                table.insert(SnakeGame.gameObjects[playerName], {
                    uniqueIndex = markerIndex,
                    cell = cellDescription,
                    type = "marker"
                })
            end
        end
    end
    
    -- Add a specific custom marker with exact console coordinates and converted angles
    local customMarkerLocation = {
        posX = 120.0,
        posY = 120.0,
        posZ = -128.0,
        rotX = degToRad(270.0),
        rotY = degToRad(0.0),
        rotZ = degToRad(90.0)
    }

    local markerIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                             customMarkerLocation, 
                                             markerObject, 
                                             "place")

    setScale(pid, cellDescription, markerIndex, markerObject.refId, 32)

    table.insert(SnakeGame.gameObjects[playerName], {
        uniqueIndex = markerIndex,
        cell = cellDescription,
        type = "marker"
    })


    
    -- logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerControls", false)
    logicHandler.RunConsoleCommandOnPlayer(pid, "DisableVanityMode", false)
    logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerViewSwitch", false)
    logicHandler.RunConsoleCommandOnPlayer(pid, "PCForce1stPerson", false)
    
    -- Teleport the player to the platform
       tes3mp.SetCell(pid, cellDescription)
       tes3mp.SetPos(pid, cfg.platformPosition.x, cfg.platformPosition.y, cfg.platformPosition.z + 1)
       tes3mp.SetRot(pid, degToRad(60), 0)
       tes3mp.SendCell(pid)
       tes3mp.SendPos(pid)
end

-- Initialize game state
local function initGameState(pid)
    local playerName = string.lower(Players[pid].accountName)
    local cellDescription = cfg.roomCell
    
    if SnakeGame.activePlayers[playerName] then
        stopGame(pid)
    end
    
    -- Make sure objects are initialized
    if not SnakeGame.preCreatedObjects then
        if jsonInterface.load(SNAKEGAMEJSONPATH) ~= nil then
            SnakeGame.preCreatedObjects = jsonInterface.load(SNAKEGAMEJSONPATH)
            tes3mp.LogMessage(enumerations.log.INFO, 
                "[SnakeGame] Loaded pre-created objects from " .. SNAKEGAMEJSONPATH)
        else
            -- First time initialization
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] First-time initialization")
            cfg.initializing = true
            InitializeGameObjects()
            cfg.initializing = false
        end
    end
    
    -- Initialize game state variables
    SnakeGame.activePlayers[playerName] = {
        snake = {},
        food = {x = 0, y = 0},
        direction = "right",
        score = 0,
        gameOver = false,
        headIndex = nil,
        segmentIndices = {},
        foodIndex = nil,
        foodRefId = nil,
        usedBodyIndices = {} 
    }
    
    -- Set up initial snake position
    local gameState = SnakeGame.activePlayers[playerName]
    local centerX = math.floor(cfg.roomSize / 2)
    local centerY = math.floor(cfg.roomSize / 2)
    
    for i = 1, cfg.initialSnakeLength do
        table.insert(gameState.snake, {x = centerX - (i - 1), y = centerY})
    end
    
    -- Initialize game objects array for this player (only to track dynamic objects)
    SnakeGame.gameObjects[playerName] = {}
    
    -- track the pre created head
    if SnakeGame.preCreatedObjects.head then

        gameState.headIndex = SnakeGame.preCreatedObjects.head.uniqueIndex

        -- Track this dynamic object
        table.insert(SnakeGame.gameObjects[playerName], {
            uniqueIndex = gameState.headIndex,
            cell = cellDescription,
            type = "head"
        })

    else
        tes3mp.LogMessage(enumerations.log.ERROR, 
            "[SnakeGame] Pre-created head not available, cannot start game")
        return
    end
    
    -- Place initial food using a pre-created food object
    if cfg.initFood then
        placeFood(pid)
        
        if SnakeGame.preCreatedObjects.food then
            -- Randomly select one of the food items
            local randomFoodIndex = math.random(1, #cfg.objects.food)
            local selectedFood = cfg.objects.food[randomFoodIndex]
            
            -- Find the matching pre-created food object
            local preCreatedFoodObject = nil
            for _, foodObj in ipairs(SnakeGame.preCreatedObjects.food) do
                if foodObj.refId == selectedFood then
                    preCreatedFoodObject = foodObj
                    break
                end
            end
            
            if preCreatedFoodObject then
                local foodLocation = {
                    posX = cfg.roomPosition.x + (gameState.food.x * 16),
                    posY = cfg.roomPosition.y + (gameState.food.y * 16),
                    posZ = cfg.roomPosition.z + 0.5,
                    rotX = 0,
                    rotY = 0,
                    rotZ = 9
                }
                
                -- Special height adjustment for rotating_skooma
                if selectedFood == "rotating_skooma" then
                    foodLocation.posZ = foodLocation.posZ + cfg.rotating_skooma_height_offset
                end
                
                local uniqueIndex = preCreatedFoodObject.uniqueIndex
                
                if LoadedCells[cellDescription].data.objectData[uniqueIndex] then
                    LoadedCells[cellDescription].data.objectData[uniqueIndex].location = {
                        posX = foodLocation.posX,
                        posY = foodLocation.posY,
                        posZ = foodLocation.posZ,
                        rotX = foodLocation.rotX,
                        rotY = foodLocation.rotY,
                        rotZ = foodLocation.rotZ
                    }
                    
                    ResendPlace(pid, uniqueIndex, cellDescription, true)
                    gameState.foodIndex = uniqueIndex
                    gameState.foodRefId = selectedFood
                    
                    -- Track this dynamic object
                    table.insert(SnakeGame.gameObjects[playerName], {
                        uniqueIndex = uniqueIndex,
                        cell = cellDescription,
                        type = "food"
                    })
                    
                    tes3mp.LogMessage(enumerations.log.INFO, 
                        "[SnakeGame] Placed food (" .. selectedFood .. ") at (" .. gameState.food.x .. "," .. gameState.food.y .. ")")
                else
                    tes3mp.LogMessage(enumerations.log.ERROR, 
                        "[SnakeGame] Pre-created food object not found in cell")
                end
            else
                tes3mp.LogMessage(enumerations.log.ERROR, 
                    "[SnakeGame] Selected food " .. selectedFood .. " not found in pre-created objects")
            end
        else
            tes3mp.LogMessage(enumerations.log.ERROR, 
                "[SnakeGame] Pre-created food not available")
        end
    end
    
    -- Teleport the player to the platform
    tes3mp.SetCell(pid, cellDescription)
    tes3mp.SetPos(pid, cfg.platformPosition.x, cfg.platformPosition.y, cfg.platformPosition.z + 1)
    tes3mp.SetRot(pid, degToRad(60), 0)
    tes3mp.SendCell(pid)
    tes3mp.SendPos(pid)
    
    -- Apply the player control settings
    logicHandler.RunConsoleCommandOnPlayer(pid, "DisableVanityMode", false)
    logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerViewSwitch", false)
    logicHandler.RunConsoleCommandOnPlayer(pid, "PCForce1stPerson", false)
    
    -- Start the game timer
    startGameTimer(pid)
    
    tes3mp.MessageBox(pid, -1, "Snake Game Started! Use chat commands: " .. 
                             cfg.commands.up .. ", " .. 
                             cfg.commands.down .. ", " ..
                             cfg.commands.left .. ", " ..
                             cfg.commands.right .. " to control the snake.")
end

-- Update game logic
function UpdateGame(pid)
    local playerName = string.lower(Players[pid].accountName)
    local gameState = SnakeGame.activePlayers[playerName]
    local cellDescription = cfg.roomCell
    
    if not gameState or gameState.gameOver then
        tes3mp.LogMessage(enumerations.log.ERROR, "[SnakeGame] No game state or game over for " .. playerName)
        return
    end
    
    local head = gameState.snake[1]
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Updating game for " .. playerName .. 
        " - Direction: " .. gameState.direction .. 
        ", Snake length: " .. #gameState.snake ..
        ", Head position: (" .. head.x .. "," .. head.y .. ")")
    
    -- Calculate new head position
    local newHead = {x = head.x, y = head.y}
    if gameState.direction == "up" or gameState.direction == "raise" then
        newHead.y = newHead.y + 1
    elseif gameState.direction == "down" or gameState.direction == "lower" then
        newHead.y = newHead.y - 1
    elseif gameState.direction == "left" then
        newHead.x = newHead.x - 1
    elseif gameState.direction == "right" then
        newHead.x = newHead.x + 1
    end
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] New head position: (" .. newHead.x .. "," .. newHead.y .. ")")
    
    -- Check wall collisions
    if newHead.x < 0 or newHead.x >= cfg.roomSize or 
       newHead.y < 0 or newHead.y >= cfg.roomSize then
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Wall collision detected")
        gameOver(pid, "You hit a wall!")
        return
    end
    
    -- Check self collisions
    for i = 2, #gameState.snake do
        if newHead.x == gameState.snake[i].x and newHead.y == gameState.snake[i].y then
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Self collision detected")
            gameOver(pid, "You hit yourself!")
            return
        end
    end
    
    -- Check if we're eating food
    local ateFood = (cfg.foodCollision and newHead.x == gameState.food.x and newHead.y == gameState.food.y) or
                    (cfg.initFood and not gameState.foodIndex)
    
    -- Move snake head to new position
    local headRotation = cfg.headRotations[gameState.direction]
    local headLocation = {
        posX = cfg.roomPosition.x + (newHead.x * 16),
        posY = cfg.roomPosition.y + (newHead.y * 16),
        posZ = cfg.roomPosition.z + 9.5,
        rotX = math.rad(headRotation.rotX),
        rotY = math.rad(headRotation.rotY),
        rotZ = math.rad(headRotation.rotZ)
    }
    
    if LoadedCells[cellDescription].data.objectData[gameState.headIndex] then
        LoadedCells[cellDescription].data.objectData[gameState.headIndex].location = {
            posX = headLocation.posX,
            posY = headLocation.posY,
            posZ = headLocation.posZ,
            rotX = headLocation.rotX,
            rotY = headLocation.rotY,
            rotZ = headLocation.rotZ
        }
        
        ResendPlace(pid, gameState.headIndex, cellDescription, true)
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Moved head to (" .. newHead.x .. "," .. newHead.y .. ")")
    else
        tes3mp.LogMessage(enumerations.log.ERROR, 
            "[SnakeGame] Head object not found, cannot update game")
        return
    end
    
    -- Find an unused body segment from the pre-created ones
    local bodySegmentIndex = nil
    
    -- Look for the next available body segment
    for i, bodyObj in ipairs(SnakeGame.preCreatedObjects.body) do
        if not gameState.usedBodyIndices[bodyObj.uniqueIndex] then
            bodySegmentIndex = bodyObj.uniqueIndex
            gameState.usedBodyIndices[bodySegmentIndex] = true
            break
        end
    end
    
    if not bodySegmentIndex then
        tes3mp.LogMessage(enumerations.log.ERROR, 
            "[SnakeGame] No available body segments found, cannot update game")
        return
    end
    
    -- Place body segment at old head position
    local bodyLocation = {
        posX = cfg.roomPosition.x + (head.x * 16),
        posY = cfg.roomPosition.y + (head.y * 16),
        posZ = cfg.roomPosition.z + 9.3,
        rotX = 0,
        rotY = 0,
        rotZ = 0
    }
    
    if LoadedCells[cellDescription].data.objectData[bodySegmentIndex] then
        LoadedCells[cellDescription].data.objectData[bodySegmentIndex].location = {
            posX = bodyLocation.posX,
            posY = bodyLocation.posY,
            posZ = bodyLocation.posZ,
            rotX = bodyLocation.rotX,
            rotY = bodyLocation.rotY,
            rotZ = bodyLocation.rotZ
        }
        
        ResendPlace(pid, bodySegmentIndex, cellDescription, true)
        
        -- Add this segment to the tracked objects
        table.insert(SnakeGame.gameObjects[playerName], {
            uniqueIndex = bodySegmentIndex,
            cell = cellDescription,
            type = "body"
        })
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Placed body segment at old head position (" .. head.x .. "," .. head.y .. ")")
    else
        tes3mp.LogMessage(enumerations.log.ERROR, 
            "[SnakeGame] Body segment not found, cannot update game")
        return
    end
    
    -- Add the new head to the front of the snake
    table.insert(gameState.snake, 1, newHead)
    
    -- Update segment indices
    gameState.segmentIndices = gameState.segmentIndices or {}
    
    -- Shift all indices and add new body segment
    for i = #gameState.snake, 3, -1 do
        gameState.segmentIndices[i] = gameState.segmentIndices[i-1]
    end
    gameState.segmentIndices[2] = bodySegmentIndex
    
    -- Handle food
    if ateFood then
        -- Keep the tail - we're growing
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Ate food - growing snake")
        gameState.score = gameState.score + 1
        
        -- Play the basic food eating sound
        logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound " .. cfg.eatFoodSound, false)
        
        -- If there was a previous food and it has voice lines, play a random one
        if gameState.foodRefId and cfg.foodVoiceLines[gameState.foodRefId] then
            local voiceLines = cfg.foodVoiceLines[gameState.foodRefId]
            local randomLine = voiceLines[math.random(1, #voiceLines)]
            tes3mp.LogMessage(enumerations.log.INFO, 
                "[SnakeGame] Playing voice line: " .. randomLine .. " for food: " .. gameState.foodRefId)
            tes3mp.PlaySpeech(pid, randomLine)
        end
        
        -- Move the eaten food back to staging area
        if gameState.foodIndex then
            local foodObj = nil
            for _, obj in ipairs(SnakeGame.gameObjects[playerName]) do
                if obj.uniqueIndex == gameState.foodIndex then
                    foodObj = obj
                    break
                end
            end
            
            if foodObj then
                -- Move food to staging area
                local stagingLocation = cfg.stagingLocation
                
                if LoadedCells[foodObj.cell].data.objectData[foodObj.uniqueIndex] then
                    LoadedCells[foodObj.cell].data.objectData[foodObj.uniqueIndex].location = {
                        posX = stagingLocation.x,
                        posY = stagingLocation.y,
                        posZ = stagingLocation.z,
                        rotX = 0,
                        rotY = 0,
                        rotZ = 0
                    }
                    
                    ResendPlace(pid, foodObj.uniqueIndex, foodObj.cell, true)
                    
                    -- Remove it from tracked objects
                    for i, obj in ipairs(SnakeGame.gameObjects[playerName]) do
                        if obj.uniqueIndex == foodObj.uniqueIndex then
                            table.remove(SnakeGame.gameObjects[playerName], i)
                            break
                        end
                    end
                    
                    tes3mp.LogMessage(enumerations.log.INFO, 
                        "[SnakeGame] Moved food back to staging area")
                end
            end
        end
        
        -- Place new food
        placeFood(pid)
        
        -- Randomly select one of the food items
        local randomFoodIndex = math.random(1, #cfg.objects.food)
        local selectedFood = cfg.objects.food[randomFoodIndex]
        
        -- Find the matching pre-created food object
        local preCreatedFoodObject = nil
        for _, foodObj in ipairs(SnakeGame.preCreatedObjects.food) do
            if foodObj.refId == selectedFood then
                preCreatedFoodObject = foodObj
                break
            end
        end
        
        if preCreatedFoodObject then
            local foodLocation = {
                posX = cfg.roomPosition.x + (gameState.food.x * 16),
                posY = cfg.roomPosition.y + (gameState.food.y * 16),
                posZ = cfg.roomPosition.z + 0.5,
                rotX = 0,
                rotY = 0,
                rotZ = 9
            }
            
            -- Special height adjustment for rotating_skooma
            if selectedFood == "rotating_skooma" then
                foodLocation.posZ = foodLocation.posZ + cfg.rotating_skooma_height_offset
            end
            
            local uniqueIndex = preCreatedFoodObject.uniqueIndex
            
            if LoadedCells[cellDescription].data.objectData[uniqueIndex] then
                LoadedCells[cellDescription].data.objectData[uniqueIndex].location = {
                    posX = foodLocation.posX,
                    posY = foodLocation.posY,
                    posZ = foodLocation.posZ,
                    rotX = foodLocation.rotX,
                    rotY = foodLocation.rotY,
                    rotZ = foodLocation.rotZ
                }
                
                ResendPlace(pid, uniqueIndex, cellDescription, true)
                gameState.foodIndex = uniqueIndex
                gameState.foodRefId = selectedFood
                
                -- Track this dynamic object
                table.insert(SnakeGame.gameObjects[playerName], {
                    uniqueIndex = uniqueIndex,
                    cell = cellDescription,
                    type = "food"
                })
                
                tes3mp.LogMessage(enumerations.log.INFO, 
                    "[SnakeGame] Placed new food (" .. selectedFood .. ") at (" .. gameState.food.x .. "," .. gameState.food.y .. ")")
            else
                tes3mp.LogMessage(enumerations.log.ERROR, 
                    "[SnakeGame] Pre-created food object not found in cell")
            end
        end
    else
        -- Not growing, so move the tail segment back to staging area
        local tail = gameState.snake[#gameState.snake]
        local tailIndex = gameState.segmentIndices[#gameState.snake]
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Removing tail at position (" .. tail.x .. "," .. tail.y .. ") with index " .. tostring(tailIndex))
        
        if tailIndex then
            -- Move body segment to staging area
            local stagingLocation = cfg.stagingLocation
            
            if LoadedCells[cellDescription].data.objectData[tailIndex] then
                LoadedCells[cellDescription].data.objectData[tailIndex].location = {
                    posX = stagingLocation.x,
                    posY = stagingLocation.y,
                    posZ = stagingLocation.z,
                    rotX = 0,
                    rotY = 0,
                    rotZ = 0
                }
                
                ResendPlace(pid, tailIndex, cellDescription, true)
                
                -- Mark this body segment as no longer used
                gameState.usedBodyIndices[tailIndex] = nil
                
                -- Remove it from tracked objects
                for i, obj in ipairs(SnakeGame.gameObjects[playerName]) do
                    if obj.uniqueIndex == tailIndex then
                        table.remove(SnakeGame.gameObjects[playerName], i)
                        break
                    end
                end
                
                tes3mp.LogMessage(enumerations.log.INFO, 
                    "[SnakeGame] Moved tail back to staging area")
            else
                tes3mp.LogMessage(enumerations.log.WARN, 
                    "[SnakeGame] Tail segment not found in cell")
            end
        else
            tes3mp.LogMessage(enumerations.log.WARN, 
                "[SnakeGame] No tail index found for position (" .. tail.x .. "," .. tail.y .. ")")
        end
        
        -- Remove the tail from the snake and segment indices
        table.remove(gameState.snake)
        gameState.segmentIndices[#gameState.snake + 1] = nil
    end
    
    -- Apply visual effects
    logicHandler.RunConsoleCommandOnObject(pid,
                                          "PlaySound3DVP, \"" .. cfg.moveSound .. "\", 1.0, 1.0",
                                          cellDescription,
                                          gameState.headIndex,
                                          false)
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Final snake state: length=" .. #gameState.snake .. 
        ", head=(" .. newHead.x .. "," .. newHead.y .. ")")
    
    startGameTimer(pid)
end

-- Command handler for customCommandHooks.registerCommand
local function commandHandler(pid, command, args)
    local playerName = string.lower(Players[pid].accountName)
    command = string.lower(command[1])
    
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Command received: " .. command .. " from player: " .. playerName)
    
    if command == cfg.commands.start then
        tes3mp.CustomMessageBox(pid, cfg.mainMenuId, "Snake Game", 
                              color.Green .. "Start Game;" ..
                              color.Red .. "Quit")
        return true
        -- initGameState(pid)
    elseif command == cfg.commands.stop then
        if SnakeGame.activePlayers[playerName] then
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Stopping game for: " .. playerName)
            stopGame(pid)
        else
            tes3mp.MessageBox(pid, -1, "No active game to stop.")
        end
    elseif command == cfg.commands.up or
           command == cfg.commands.down or
           command == cfg.commands.left or
           command == cfg.commands.right then
        if SnakeGame.activePlayers[playerName] and not SnakeGame.activePlayers[playerName].gameOver then
            local newDirection = command
            local currentDirection = SnakeGame.activePlayers[playerName].direction
            
            if (newDirection == cfg.commands.up and currentDirection ~= cfg.commands.down) or
               (newDirection == cfg.commands.down and currentDirection ~= cfg.commands.up) or
               (newDirection == cfg.commands.left and currentDirection ~= cfg.commands.right) or
               (newDirection == cfg.commands.right and currentDirection ~= cfg.commands.left) then
                SnakeGame.activePlayers[playerName].direction = newDirection
                tes3mp.LogMessage(enumerations.log.INFO, 
                    "[SnakeGame] Direction changed to " .. newDirection .. " for " .. playerName)
            end
        end
    end
    
    return false -- Allow other scripts to process
end

-- Handle GUI actions
local function onGUIAction(eventStatus, pid, idGui, data)
    if idGui == cfg.gameOverId then
        if tonumber(data) == 0 then -- Play Again
            initGameState(pid)
        elseif tonumber(data) == 1 then -- Quit
            stopGame(pid)
        end
    elseif idGui == cfg.mainMenuId then
        if tonumber(data) == 0 then -- Start Game
            initGameState(pid)
        elseif tonumber(data) == 1 then -- Quit
            -- Nothing to do here
        end
    end
end

local function InitializeGameObjects()
    local cellDescription = cfg.roomCell
    local objectsCreated = {}
    
    -- Set up a staging area outside the game room for pre-created objects
    local stagingLocation = cfg.stagingLocation
    
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Initializing game objects in staging area")
    
    -- Create one of each food type
    objectsCreated.food = {}
    for _, foodRefId in ipairs(cfg.objects.food) do
        local foodLocation = {
            posX = stagingLocation.x,
            posY = stagingLocation.y,
            posZ = stagingLocation.z,
            rotX = 0,
            rotY = 0,
            rotZ = 0
        }
        
        -- Special height adjustment for rotating_skooma
        if foodRefId == "rotating_skooma" then
            foodLocation.posZ = foodLocation.posZ + cfg.rotating_skooma_height_offset
        end
        
        local foodObject = {
            refId = foodRefId,
            count = 1,
            charge = -1,
            enchantmentCharge = -1,
            soul = "",
            location = foodLocation
        }
        
        -- local foodIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
        --                                                      foodLocation, 
        --                                                      foodObject, 
        --                                                      "place")
        local foodIndex = createObjects(cellDescription, {foodObject}, "place")
        
        -- Store the food object reference
        table.insert(objectsCreated.food, {
            refId = foodRefId,
            uniqueIndex = foodIndex
        })
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Placed food " .. foodRefId .. " at staging area with index " .. foodIndex)
    end
    
    local centerX = math.floor(cfg.roomSize / 2)
    local centerY = math.floor(cfg.roomSize / 2)
    
    -- Place head
    local headLocation = {
        posX = 120.0,
        posY = 120.0,
        posZ = cfg.roomPosition.z + 9.5,
        rotX = math.rad(cfg.headRotations.right.rotX),
        rotY = math.rad(cfg.headRotations.right.rotY),
        rotZ = math.rad(cfg.headRotations.right.rotZ)
    }

    local headObject = {
        refId = cfg.objects.snakeHead,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = "",
        location = headLocation
    }
    
    -- local headIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
    --                                                      headLocation, 
    --                                                      headObject, 
    --                                                      "place")
    local headIndex = createObjects(cellDescription, {headObject}, "place")
    
    objectsCreated.head = {
        refId = cfg.objects.snakeHead,
        uniqueIndex = headIndex
    }
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Placed snake head at staging area with index " .. headIndex)
    
    -- Create maximum number of potential snake body segments
    -- Based on room size, maximum snake length would be roomSize * roomSize
    local maxSegments = cfg.roomSize * cfg.roomSize
    objectsCreated.body = {}
    
    for i = 1, maxSegments do
        local segmentLocation = {
            posX = stagingLocation.x,
            posY = stagingLocation.y,
            posZ = stagingLocation.z,
            rotX = 0,
            rotY = 0,
            rotZ = 0
        }
        
        local segmentObject = {
            refId = cfg.objects.snakeBody,
            count = 1,
            charge = -1,
            enchantmentCharge = -1,
            soul = "",
            location = segmentLocation
        }
        
        -- local segmentIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
        --                                                         segmentLocation, 
        --                                                         segmentObject, 
        --                                                         "place")
        local segmentIndex = createObjects(cellDescription, {segmentObject}, "place")
        
        table.insert(objectsCreated.body, {
            refId = cfg.objects.snakeBody,
            uniqueIndex = segmentIndex
        })
        
        -- Log every 10 segments to avoid spam
        if i % 10 == 0 or i == 1 or i == maxSegments then
            tes3mp.LogMessage(enumerations.log.INFO, 
                "[SnakeGame] Placed snake body segment " .. i .. "/" .. maxSegments .. 
                " at staging area with index " .. segmentIndex)
        end
    end
    
    -- Create wall
    local wallLocation = {
        posX = cfg.wallPosition.x,
        posY = cfg.wallPosition.y,
        posZ = cfg.wallPosition.z,
        rotX = degToRad(-180),
        rotY = 0,
        rotZ = 0
    }
    
    local wallObject = {
        refId = cfg.objects.wall,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = "",
        location = wallLocation,
        scale = cfg.wallScale
    }
    
    -- local wallIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
    --                                                      wallLocation, 
    --                                                      wallObject, 
    --                                                      "place")
    local wallIndex = createObjects(cellDescription, {wallObject}, "place")
    
    objectsCreated.wall = {
        refId = cfg.objects.wall,
        uniqueIndex = wallIndex
    }
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Placed wall at staging area with index " .. wallIndex)
    
    -- Create floor
    local floorLocation = {
        posX = cfg.roomPosition.x,
        posY = cfg.roomPosition.y, 
        posZ = cfg.roomPosition.z - 23, -- Slightly below ground
        rotX = 0,
        rotY = 0,
        rotZ = 0
    }
    
    local floorObject = {
        refId = cfg.objects.floor,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = "",
        location = floorLocation,
        scale = cfg.floorScale
    }
    
    -- local floorIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
    --                                                       floorLocation, 
    --                                                       floorObject, 
    --                                                       "place")
    local floorIndex = createObjects(cellDescription, {floorObject}, "place")
    
    objectsCreated.floor = {
        refId = cfg.objects.floor,
        uniqueIndex = floorIndex
    }
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Placed floor at staging area with index " .. floorIndex)
    
    -- Create border markers in their final position
    objectsCreated.borders = {}
    local size = cfg.roomSize
    local step = 1 -- step size in grid units
    
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Creating game border in final position")
    
    for x = -1, size, step do
        for y = -1, size, step do
            -- Check if the current point is on the border
            if x == -1 or x == size or y == -1 or y == size then
                local borderLocation = {
                    posX = cfg.roomPosition.x + (x * 16),
                    posY = cfg.roomPosition.y + (y * 16),
                    posZ = cfg.roomPosition.z + 8,
                    rotX = 0,
                    rotY = 0,
                    rotZ = 0
                }
                
                local borderObject = {
                    refId = cfg.objects.border,
                    count = 1,
                    charge = -1,
                    enchantmentCharge = -1,
                    soul = "",
                    location = borderLocation
                }
                
                -- Set scale for border
                if cfg.borderScale ~= 1 then
                    local pid = 0 -- Use server PID for initialization
                    borderObject.scale = cfg.borderScale
                    -- setScale(pid, cellDescription, borderIndex, borderObject.refId, cfg.borderScale)
                end
                
                -- local borderIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                --                                                       borderLocation, 
                --                                                       borderObject, 
                --                                                       "place")
                local borderIndex = createObjects(cellDescription, {borderObject}, "place")
                
                table.insert(objectsCreated.borders, {
                    refId = cfg.objects.border,
                    uniqueIndex = borderIndex,
                    position = {x = x, y = y}
                })
            end
        end
    end
    
    -- Add the special custom marker for the large floor panel
    local customMarkerLocation = {
        posX = 120.0,
        posY = 120.0,
        posZ = -128.0,
        rotX = degToRad(270.0),
        rotY = degToRad(0.0),
        rotZ = degToRad(90.0)
    }
    
    local customBorderObject = {
        refId = cfg.objects.border,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = "",
        scale = 32,
        location = customMarkerLocation
        
    }

    
    -- local customMarkerIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
    --                                              customMarkerLocation, 
    --                                              customBorderObject, 
    --                                              "place")
    local customMarkerIndex = createObjects(cellDescription, {customBorderObject}, "place")
    
    -- Set large scale for this special border marker
    local pid = 0 -- Use server PID for initialization
    -- setScale(pid, cellDescription, customMarkerIndex, customBorderObject.refId, 32)
    
    table.insert(objectsCreated.borders, {
        refId = cfg.objects.border,
        uniqueIndex = customMarkerIndex,
        position = {x = "custom", y = "custom"} -- Special identifier
    })
    
    tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Created border with " .. #objectsCreated.borders .. " markers in final position")
    
    -- Save all the created object references to a global table or to disk
    SnakeGame.preCreatedObjects = objectsCreated
    
    -- Save the data to a JSON file for persistence across server restarts
    local jsonData = jsonInterface.save(SNAKEGAMEJSONPATH, SnakeGame.preCreatedObjects)
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Initialized and saved " .. (1 + 1 + 1 + 1 + #cfg.objects.food + maxSegments) .. 
        " game objects to " .. SNAKEGAMEJSONPATH)
    
    return objectsCreated
end

local function OnServerPostInitHandler()

    local scriptStore = RecordStores["script"]
    scriptStore.data.permanentRecords["test_RotateScript"] = { 
        scriptText = 
    "begin test_RotateScript\n\tshort RotatingItem\n\tset RotatingItem to 1\n\tif ( RotatingItem == 1 )\n\t\trotate, Z, 180\n\tendif\nend\n"
    }

    scriptStore:QuicksaveToDrive()
    
    local potionStore = RecordStores["potion"]
    potionStore.data.permanentRecords["rotating_skooma"] = { 
        baseId = "potion_skooma_01",
        script = "test_RotateScript"
    }
    potionStore:QuicksaveToDrive()
    
    local apparatusStore = RecordStores["apparatus"]
    apparatusStore.data.permanentRecords["rotating_skooma_pipe"] = { 
        baseId = "apparatus_a_spipe_01",
        script = "test_RotateScript"
    }
    apparatusStore:QuicksaveToDrive()
    
    local ingredientStore = RecordStores["ingredient"]
    ingredientStore.data.permanentRecords["rotating_moonsugar"] = { 
        baseId = "ingred_moon_sugar_01",
        script = "test_RotateScript"
    }
    ingredientStore:QuicksaveToDrive()
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Records Created.")
    
    -- Then initialize all the game objects
    -- Check if we have saved objects from previous server runs
    if jsonInterface.load(SNAKEGAMEJSONPATH) ~= nil then
        SnakeGame.preCreatedObjects = jsonInterface.load(SNAKEGAMEJSONPATH)
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Loaded " .. tableHelper.getCount(SnakeGame.preCreatedObjects.body) + 
            tableHelper.getCount(SnakeGame.preCreatedObjects.food) + 3 .. 
            " pre-created objects from " .. SNAKEGAMEJSONPATH)
    else
        -- If not, create all objects and save them
        cfg.initializing = true
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Initializing value before: " .. tostring(cfg.initializing))
        InitializeGameObjects()
        cfg.initializing = false
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Initializing value after: " .. tostring(cfg.initializing))
    end

end

-- Event handlers (only disconnect and server exit)
customEventHooks.registerHandler("OnPlayerDisconnect", OnPlayerDisconnectHandler)
customEventHooks.registerHandler("OnServerPostInit", OnServerPostInitHandler)
customEventHooks.registerHandler("OnGUIAction", onGUIAction)

-- customEventHooks.registerHandler("OnServerExit", function(eventStatus)
--     for _, pid in pairs(Players) do
--         if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
--             stopGame(pid)
--         end
--     end
-- end)

-- Register commands
customCommandHooks.registerCommand(cfg.commands.start, commandHandler)
customCommandHooks.registerCommand(cfg.commands.stop, commandHandler)
customCommandHooks.registerCommand(cfg.commands.up, commandHandler)
customCommandHooks.registerCommand(cfg.commands.down, commandHandler)
customCommandHooks.registerCommand(cfg.commands.left, commandHandler)
customCommandHooks.registerCommand(cfg.commands.right, commandHandler)

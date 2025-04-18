--TODO :
    --  start from github save...
    --  create indexes for all possible snake parts and save them to the indexStore.
    -- after the first initalization we should only ever need to store the smallest index and start trom that one each time
    -- using the createObjects function or a modified ResendPlace with move packets.
    -- 
    -- food not being placed after eating 2......

-- cfguration
local cfg = {
    
    -- GUI IDs
    mainMenuId = 31450,
    gameOverId = 31451,
    
    --seconds between snake updates (travel speed)
    updateInterval = .3,
    initialSnakeLength = 3,
    
    --scales 
    headScale = 1,
    bodyScale = .6,
    foodScale = 1.5,
    wallScale = -1.25, --negative to invert the rectnagular stone block so we see the texture on the inside
    borderScale = 2,
    borderFloor = 32,
    
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
        wall = "ex_imp_plat_01",
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

local indexStore = {}
local INDEXSTORE_PATH = "custom/snakeGameIndexes.json"

local function resetIndexStore()
    -- Leave only the static parts of the index store
    local staticParts = {}
    
    -- Keep static elements like wall, floor, markers
    if indexStore["wall"] then staticParts["wall"] = indexStore["wall"] end
    if indexStore["floor"] then staticParts["floor"] = indexStore["floor"] end
    if indexStore["big_marker"] then staticParts["big_marker"] = indexStore["big_marker"] end
    
    -- Keep marker indexes
    for i = 1, 100 do
        local markerKey = "marker_" .. i
        if indexStore[markerKey] then staticParts[markerKey] = indexStore[markerKey] end
    end
    
    -- Keep food indexes
    for _, foodType in ipairs(cfg.objects.food) do
        local foodKey = "food_" .. foodType
        if indexStore[foodKey] then staticParts[foodKey] = indexStore[foodKey] end
    end
    
    -- Set the cleaned indexStore
    indexStore = staticParts
    indexStore["body_parts"] = {}
    
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Reset index store to static objects only")
end

-- Load the stored unique indexes on script initialization
local function loadIndexStore()
    -- if tes3mp.DoesFileExist(INDEXSTORE_PATH) then
        local jsonData = jsonInterface.load(INDEXSTORE_PATH)
        if jsonData then
            -- Clean up the loaded data
            local cleanedData = {}
            
            -- Only keep keys we actually use in a predictable format
            if jsonData["snake_head"] then cleanedData["snake_head"] = jsonData["snake_head"] end
            
            -- Initialize body_parts array if it exists
            cleanedData["body_parts"] = {}
            
            -- Process food indexes
            for _, foodType in ipairs(cfg.objects.food) do
                local foodKey = "food_" .. foodType
                if jsonData[foodKey] then cleanedData[foodKey] = jsonData[foodKey] end
            end
            
            -- Process static objects
            if jsonData["wall"] then cleanedData["wall"] = jsonData["wall"] end
            if jsonData["floor"] then cleanedData["floor"] = jsonData["floor"] end
            if jsonData["big_marker"] then cleanedData["big_marker"] = jsonData["big_marker"] end
            
            -- Process marker indexes
            for i = 1, 100 do  -- Reasonable upper limit
                local markerKey = "marker_" .. i
                if jsonData[markerKey] then cleanedData[markerKey] = jsonData[markerKey] end
            end
            
            -- Set the cleaned data
            indexStore = cleanedData
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Loaded and cleaned " .. tableHelper.getCount(indexStore) .. " stored object indexes")
        else
            tes3mp.LogMessage(enumerations.log.WARN, "[SnakeGame] Failed to load index store from " .. INDEXSTORE_PATH)
            indexStore = {}
        end
    -- else
    --     tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] No index store found, will create new objects")
    --     indexStore = {}
    -- end
end

-- Save the stored unique indexes
local function saveIndexStore()
    if tableHelper.getCount(indexStore) > 0 then
        jsonInterface.save(INDEXSTORE_PATH, indexStore)
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Saved " .. tableHelper.getCount(indexStore) .. " object indexes to " .. INDEXSTORE_PATH)
    end
end

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
    DeleteObject(pid, cellDescription, uniqueIndex, forEveryone)
    tes3mp.ClearObjectList()
    tes3mp.SetObjectListPid(pid)
    tes3mp.SetObjectListCell(cellDescription)
    local object = LoadedCells[cellDescription].data.objectData[uniqueIndex]
    if not object then return end
    local inventory = LoadedCells[cellDescription].data.objectData[uniqueIndex].inventory
    local scale = object.scale or 1
    if object and object.location and object.refId then
        local splitIndex = uniqueIndex:split("-")
        tes3mp.SetObjectRefNum(splitIndex[1])
        tes3mp.SetObjectMpNum(splitIndex[2])
        tes3mp.SetObjectRefId(object.refId)
        tes3mp.SetObjectCharge(object.charge or -1)
        tes3mp.SetObjectEnchantmentCharge(object.enchantmentCharge or -1)
        tes3mp.SetObjectPosition(object.location.posX, object.location.posY, object.location.posZ)
        tes3mp.SetObjectRotation(object.location.rotX, object.location.rotY, object.location.rotZ)
    if object.scale == nil then object.scale = 1 end
        tes3mp.SetObjectScale(object.scale)
    end
    tes3mp.SendObjectPlace(forEveryone, false)
    -- tes3mp.SendObjectMove(forEveryone, false)
    tes3mp.SendObjectRotate(forEveryone, false)
    tes3mp.SendObjectScale(forEveryone, false)
    
    if scale ~= 1 then
        tableHelper.insertValueIfMissing(LoadedCells[cellDescription].data.packets.scale, uniqueIndex)
    end
   
end

local function createObjects(cellDescription, objectsToCreate, packetType, temp_object_uniqueIndex)
    local uniqueIndexes = {}
    local generatedRecordIdsPerType = {}
    local unloadCellAtEnd = false
    local shouldSendPacket = false

    -- If the desired cell is not loaded, load it temporarily
    if LoadedCells[cellDescription] == nil then
        logicHandler.LoadCell(cellDescription)
        unloadCellAtEnd = true
    end

    local cell = LoadedCells[cellDescription]

    -- Only send a packet if there are players on the server to send it to
    if tableHelper.getCount(Players) > 0 then
        shouldSendPacket = true
        tes3mp.ClearObjectList()
    end

    for _, object in pairs(objectsToCreate) do

        local refId = object.refId
        local count = object.count
        local charge = object.charge
        local enchantmentCharge = object.enchantmentCharge
        local soul = object.soul
        local location = object.location
        -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "object.scale: " .. tostring(object.scale))
        if object.scale == nil then object.scale = 1 end
        local scale = object.scale
        
-----------------------------------------------------------------------------------------------------------------------------------------------------
        -- set the uniqueIndex to the one we passed in.
        -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "temp_object_uniqueIndex: " .. temp_object_uniqueIndex)

        local splitIndex = temp_object_uniqueIndex:split("-")

        local mpNum = splitIndex[2]
        local uniqueIndex =  0 .. "-" .. mpNum
        local isValid = true
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

            table.insert(uniqueIndexes, uniqueIndex)
            -- WorldInstance:SetCurrentMpNum(mpNum) -- was causing random creatures to replace the objects i was moving across cell borders lol
            -- tes3mp.SetCurrentMpNum(mpNum)

            cell:InitializeObjectData(uniqueIndex, refId)
            cell.data.objectData[uniqueIndex].location = location

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

                local pid = tableHelper.getAnyValue(Players).pid
                tes3mp.SetObjectListPid(pid)
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

    if scale ~= 1 then
  		  tableHelper.insertValueIfMissing(LoadedCells[cellDescription].data.packets.scale, temp_object_uniqueIndex)
  	end


    -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "LoadedCells[cellDescription].data.packets.scale: " .. tostring(LoadedCells[cellDescription].data.packets.scale))
    -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "uniqueIndex: " .. tostring(temp_object_uniqueIndex))
    -- tableHelper.print(LoadedCells[cellDescription].data.packets.scale)
    -- tableHelper.print(LoadedCells[cellDescription].data.objectData[temp_object_uniqueIndex])

    -- cell:Save() --TODO re enable this if thigs aren't saving ( or use QuicksaveToDrive )

    if unloadCellAtEnd then
        logicHandler.UnloadCell(cellDescription)
    end

    return uniqueIndexes
end

-- function to create objects using stored indexes
local function createGameObject(pid, cellDescription, objectData, objectType, playerName, typeKey)
    local uniqueIndex
    
    -- Create type-specific key for storing in indexStore
    local storeKey = typeKey or objectType
    
    if indexStore[storeKey] then
        -- Use the stored uniqueIndex
        uniqueIndex = indexStore[storeKey]
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Using stored " .. objectType .. " index: " .. uniqueIndex)

        DeleteObject(pid, cellDescription, uniqueIndex, true)
        createObjects(cellDescription, {objectData}, "place", uniqueIndex)

    else
        -- Create new object and store its uniqueIndex
        if objectData.location then
            uniqueIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                             objectData.location, 
                                                             objectData, 
                                                             "place")
        else
            tes3mp.LogMessage(enumerations.log.ERROR, "[SnakeGame] Missing location for " .. objectType)
            return nil
        end
        
        -- Store the uniqueIndex for future use
        indexStore[storeKey] = uniqueIndex
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Stored new " .. objectType .. " index: " .. uniqueIndex)
        
        -- Save the updated index store
        saveIndexStore()
    end
    
    -- Apply scale if specified
    if objectData.scale and objectData.scale ~= 1 then
        setScale(pid, cellDescription, uniqueIndex, objectData.refId, objectData.scale)
    end
    
    -- Add to game objects for tracking
    table.insert(SnakeGame.gameObjects[playerName], {
        uniqueIndex = uniqueIndex,
        cell = cellDescription,
        type = objectType
    })
    
    return uniqueIndex
end

-- Stop game and clean up
local function stopGame(pid)
    local playerName = string.lower(Players[pid].accountName)
    
    if SnakeGame.timers[playerName] then
        tes3mp.StopTimer(SnakeGame.timers[playerName])
        SnakeGame.timers[playerName] = nil
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Stopped timer for " .. playerName)
    end
    
    local gameState = SnakeGame.activePlayers[playerName]
    if gameState then
        -- First, specifically hide all known snake segments
        if gameState.headIndex then
            -- Move head off-screen
            tes3mp.ClearObjectList()
            tes3mp.SetObjectListPid(pid)
            tes3mp.SetObjectListCell(cfg.roomCell)
            
            local splitIndex = gameState.headIndex:split("-")
            tes3mp.SetObjectRefNum(splitIndex[1])
            tes3mp.SetObjectMpNum(splitIndex[2])
            tes3mp.SetObjectRefId(cfg.objects.snakeHead)
            tes3mp.SetObjectPosition(9000, 9000, 9000)
            tes3mp.AddObject()
            
            tes3mp.SendObjectMove(true, false)
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Moved head off-screen")
        end
        
        -- Move all known body segments off-screen
        if gameState.segmentIndices then
            for i, segmentIndex in pairs(gameState.segmentIndices) do
                -- Move segment off-screen
                tes3mp.ClearObjectList()
                tes3mp.SetObjectListPid(pid)
                tes3mp.SetObjectListCell(cfg.roomCell)
                
                local splitIndex = segmentIndex:split("-")
                tes3mp.SetObjectRefNum(splitIndex[1])
                tes3mp.SetObjectMpNum(splitIndex[2])
                tes3mp.SetObjectRefId(cfg.objects.snakeBody)
                tes3mp.SetObjectPosition(9000, 9000, 9000)
                tes3mp.AddObject()
                
                tes3mp.SendObjectMove(true, false)
                tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Moved segment " .. i .. " off-screen")
            end
        end
        
        -- Move food off-screen
        if gameState.foodIndex and gameState.foodRefId then
            tes3mp.ClearObjectList()
            tes3mp.SetObjectListPid(pid)
            tes3mp.SetObjectListCell(cfg.roomCell)
            
            local splitIndex = gameState.foodIndex:split("-")
            tes3mp.SetObjectRefNum(splitIndex[1])
            tes3mp.SetObjectMpNum(splitIndex[2])
            tes3mp.SetObjectRefId(gameState.foodRefId)
            tes3mp.SetObjectPosition(9000, 9000, 9000)
            tes3mp.AddObject()
            
            tes3mp.SendObjectMove(true, false)
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Moved food off-screen")
        end
        
        -- Move any segments in the pool off-screen too
        if indexStore["body_parts"] then
            for i, segmentIndex in ipairs(indexStore["body_parts"]) do
                -- Move segment off-screen
                tes3mp.ClearObjectList()
                tes3mp.SetObjectListPid(pid)
                tes3mp.SetObjectListCell(cfg.roomCell)
                
                local splitIndex = segmentIndex:split("-")
                tes3mp.SetObjectRefNum(splitIndex[1])
                tes3mp.SetObjectMpNum(splitIndex[2])
                tes3mp.SetObjectRefId(cfg.objects.snakeBody)
                tes3mp.SetObjectPosition(9000, 9000, 9000)
                tes3mp.AddObject()
                
                tes3mp.SendObjectMove(true, false)
                tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Moved pooled segment " .. i .. " off-screen")
            end
        end
    end
    
    -- Now do a more thorough cleanup of all tracked objects
    if SnakeGame.gameObjects[playerName] then
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Clearing " .. #SnakeGame.gameObjects[playerName] .. " objects for " .. playerName)
            
        for i = #SnakeGame.gameObjects[playerName], 1, -1 do
            local object = SnakeGame.gameObjects[playerName][i]
            if object and object.uniqueIndex and logicHandler.IsCellLoaded(object.cell) then
                -- Move object out of sight
                tes3mp.ClearObjectList()
                tes3mp.SetObjectListPid(pid)
                tes3mp.SetObjectListCell(object.cell)
                
                local splitIndex = object.uniqueIndex:split("-")
                tes3mp.SetObjectRefNum(splitIndex[1])
                tes3mp.SetObjectMpNum(splitIndex[2])
                tes3mp.SetObjectPosition(9000, 9000, 9000)
                tes3mp.AddObject()
                
                tes3mp.SendObjectMove(true, false)
                tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Moved object " .. object.uniqueIndex .. " off-screen")
            end
        end
        
        SnakeGame.gameObjects[playerName] = nil
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Cleared all objects for " .. playerName)
    end
    
    -- Add a special cleanup for all snake body parts in the cell
    -- This will catch any segments that might have been missed
    tes3mp.ClearObjectList()
    tes3mp.SetObjectListPid(pid)
    tes3mp.SetObjectListCell(cfg.roomCell)
    tes3mp.SetObjectRefId(cfg.objects.snakeBody)
    tes3mp.SetObjectPosition(9000, 9000, 9000)
    tes3mp.AddObject()
    tes3mp.SendObjectMove(true, false)
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Executed emergency cleanup for all snake segments")
    
    -- Reset the player's game state
    SnakeGame.activePlayers[playerName] = nil
    
    -- Save the updated index store with the current state
    saveIndexStore()
    
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

-- Clear specific snake parts (tail only when not growing)
local function clearSnake(pid, tailIndex, grew)
    local playerName = string.lower(Players[pid].accountName)
    
    tes3mp.LogMessage(enumerations.log.WARN, "[SnakeGame] tailIndex " .. tostring(tailIndex))
    tes3mp.LogMessage(enumerations.log.WARN, "[SnakeGame] grew " .. tostring(grew))
    
    if not SnakeGame.gameObjects[playerName] then 
        tes3mp.LogMessage(enumerations.log.WARN, "[SnakeGame] No game objects for " .. playerName)
        return 
    end
    
    if tailIndex and not grew then
        for i = #SnakeGame.gameObjects[playerName], 1, -1 do
            local object = SnakeGame.gameObjects[playerName][i]
            tes3mp.LogMessage(enumerations.log.WARN, "[SnakeGame] who's pants just got shit? " .. playerName)
            if object and object.uniqueIndex == tailIndex then
                if logicHandler.IsCellLoaded(object.cell) then
                    logicHandler.DeleteObject(pid, object.cell, object.uniqueIndex, true)
                    table.remove(SnakeGame.gameObjects[playerName], i)
                    tes3mp.LogMessage(enumerations.log.INFO, 
                        "[SnakeGame] Cleared tail with index " .. object.uniqueIndex .. " for " .. playerName)
                end
                break
            end
        end
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
    
    -- Wall
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
    
    createGameObject(pid, cellDescription, wallObject, "wall", playerName)
    
    -- Floor
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
        scale = 1
    }
    
    createGameObject(pid, cellDescription, floorObject, "floor", playerName)
    
    -- Place markers along the full square border
    local size = cfg.roomSize
    local step = 1  -- step size in grid units
    
    local markerObject = {
        refId = cfg.objects.border,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = "",
        scale = cfg.borderScale
    }
    
    -- Create border markers
    local markerCount = 0
    for x = -1, size, step do
        for y = -1, size, step do
            -- Check if the current point is on the border
            if x == -1 or x == size or y == -1 or y == size then
                markerCount = markerCount + 1
                local markerLocation = {
                    posX = cfg.roomPosition.x + (x * 16),
                    posY = cfg.roomPosition.y + (y * 16),
                    posZ = cfg.roomPosition.z + 8,
                    rotX = 0,
                    rotY = 0,
                    rotZ = 0
                }
                
                local markerKey = "marker_" .. markerCount
                
                markerObject.location = markerLocation
                createGameObject(pid, cellDescription, markerObject, "marker", playerName, markerKey)
            end
        end
    end
    
    -- Add the special custom marker
    local customMarkerLocation = {
        posX = 120.0,
        posY = 120.0,
        posZ = -128.0,
        rotX = degToRad(270.0),
        rotY = degToRad(0.0),
        rotZ = degToRad(90.0)
    }

    local bigMarkerObject = {
        refId = cfg.objects.border,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = "",
        location = customMarkerLocation,
        scale = cfg.borderFloor
    }

    createGameObject(pid, cellDescription, bigMarkerObject, "big_marker", playerName)
    
    -- Player camera/control setup
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

local function ensureAllFoodIndexesExist(pid)
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Checking food indexes...")
    
    local missingFoodTypes = {}
    for _, foodType in ipairs(cfg.objects.food) do
        if not indexStore["food_" .. foodType] then
            table.insert(missingFoodTypes, foodType)
            tes3mp.LogMessage(enumerations.log.WARN, 
                "[SnakeGame] Missing food index for: " .. foodType)
        end
    end
    
    if #missingFoodTypes > 0 then
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Creating " .. #missingFoodTypes .. " missing food indexes")
        
        -- Create all missing food types at a dummy location
        local dummyLocation = {
            posX = 9000,
            posY = 9000,
            posZ = 9000,
            rotX = 0,
            rotY = 0,
            rotZ = 0
        }
        
        for _, foodType in ipairs(missingFoodTypes) do
            local foodObject = {
                refId = foodType,
                count = 1,
                charge = -1,
                enchantmentCharge = -1,
                soul = ""
            }
            
            local foodIndex = logicHandler.CreateObjectAtLocation(
                cfg.roomCell,
                dummyLocation,
                foodObject,
                "place"
            )
            
            -- Set the scale
            setScale(pid, cfg.roomCell, foodIndex, foodType, cfg.foodScale)
            
            -- Store the index
            indexStore["food_" .. foodType] = foodIndex
            
            tes3mp.LogMessage(enumerations.log.INFO, 
                "[SnakeGame] Created index for " .. foodType .. ": " .. foodIndex)
                
            -- Add to game objects for tracking
            if SnakeGame.gameObjects[string.lower(Players[pid].accountName)] then
                table.insert(SnakeGame.gameObjects[string.lower(Players[pid].accountName)], {
                    uniqueIndex = foodIndex,
                    cell = cfg.roomCell,
                    type = "food"
                })
            end
        end
        
        -- Save the updated index store
        saveIndexStore()
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] All food indexes created and saved")
    else
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] All food indexes already exist")
    end
    
    -- Log all food indexes
    for _, foodType in ipairs(cfg.objects.food) do
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Food index for " .. foodType .. ": " .. 
            tostring(indexStore["food_" .. foodType]))
    end
end

-- Initialize game state
local function initGameState(pid)
    local playerName = string.lower(Players[pid].accountName)
    
    if SnakeGame.activePlayers[playerName] then
        stopGame(pid)
    end
    
    -- Reset index store to clean state
    resetIndexStore()
    
    SnakeGame.activePlayers[playerName] = {
        snake = {},
        food = {x = 0, y = 0},
        direction = "right",
        score = 0,
        gameOver = false,
        headIndex = nil,
        segmentIndices = {},
        foodIndex = nil,
        foodRefId = nil
    }
    
    local gameState = SnakeGame.activePlayers[playerName]
    local centerX = math.floor(cfg.roomSize / 2)
    local centerY = math.floor(cfg.roomSize / 2)
    
    for i = 1, cfg.initialSnakeLength do
        table.insert(gameState.snake, {x = centerX - (i - 1), y = centerY})
    end
    
    SnakeGame.gameObjects[playerName] = {}
    
    -- Ensure all food indexes exist
    ensureAllFoodIndexesExist(pid)
    
    -- Check if we need to pre-allocate snake objects
    local needToPreallocate = not indexStore["snake_head"] or not indexStore["body_parts"]
    
    if needToPreallocate then
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Pre-allocating snake objects")
        
        -- Create head and body in a far-away location
        local dummyLocation = {
            posX = 9000,
            posY = 9000,
            posZ = 9000,
            rotX = 0,
            rotY = 0,
            rotZ = 0
        }
        
        -- Create the head
        local headObject = {
            refId = cfg.objects.snakeHead,
            count = 1,
            charge = -1,
            enchantmentCharge = -1,
            soul = "",
            location = dummyLocation,
            -- scale = cfg.headScale
        }
        
        local headIndex = logicHandler.CreateObjectAtLocation(
            cfg.roomCell, 
            dummyLocation, 
            headObject, 
            "place"
        )
        
        indexStore["snake_head"] = headIndex
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Pre-allocated snake head with index " .. headIndex)
        
        -- Create enough body segments for the initial snake
        indexStore["body_parts"] = {}
        
        for i = 1, cfg.initialSnakeLength * 2 do  -- Create a few extra
            local bodyObject = {
                refId = cfg.objects.snakeBody,
                count = 1,
                charge = -1,
                enchantmentCharge = -1,
                soul = "",
                location = dummyLocation,
                -- scale = cfg.bodyScale
            }
            
            local bodyIndex = logicHandler.CreateObjectAtLocation(
                cfg.roomCell, 
                dummyLocation, 
                bodyObject, 
                "place"
            )
            
            indexStore["body_parts"][i] = bodyIndex
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Pre-allocated body part " .. i .. " with index " .. bodyIndex)
        end
        
        saveIndexStore()
    end
    
    -- Now place the head at the start position
    local headLocation = {
        posX = cfg.roomPosition.x + (gameState.snake[1].x * 16),
        posY = cfg.roomPosition.y + (gameState.snake[1].y * 16),
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
        location = headLocation,
        -- scale = cfg.headScale
    }
    
    -- Place the head using the stored index
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Placing head at start position")
    gameState.headIndex = createGameObject(pid, cfg.roomCell, headObject, "head", playerName, "snake_head")
    
    if not gameState.headIndex then
        tes3mp.LogMessage(enumerations.log.ERROR, "[SnakeGame] Failed to place head")
    else 
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Head placed successfully with index " .. gameState.headIndex)
    end
    
    -- Now place the body segments
    for i = 2, #gameState.snake do
        local bodyLocation = {
            posX = cfg.roomPosition.x + (gameState.snake[i].x * 16),
            posY = cfg.roomPosition.y + (gameState.snake[i].y * 16),
            posZ = cfg.roomPosition.z + 9.3,
            rotX = 0,
            rotY = 0,
            rotZ = 0
        }
        
        local bodyObject = {
            refId = cfg.objects.snakeBody,
            count = 1,
            charge = -1,
            enchantmentCharge = -1,
            soul = "",
            location = bodyLocation,
            -- scale = cfg.bodyScale
        }
        
        -- Place body segment using a stored index
        local bodyKey = "body_parts"
        local bodyPartIndex = i - 1  -- First body part is at index 1
        
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Placing body segment " .. i .. " using index " .. 
                          (indexStore[bodyKey] and indexStore[bodyKey][bodyPartIndex] or "unknown"))
                          
        local segmentIndex = createGameObject(pid, cfg.roomCell, bodyObject, "body", playerName, "body_segment_" .. i)
        
        if not segmentIndex then
            tes3mp.LogMessage(enumerations.log.ERROR, "[SnakeGame] Failed to place body segment " .. i)
        else 
            gameState.segmentIndices[i] = segmentIndex
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Body segment " .. i .. " placed with index " .. segmentIndex)
        end
    end
    
    -- Place initial food
    if cfg.initFood then
        placeFood(pid)
        
        -- Random food type
        local randomFoodIndex = math.random(1, #cfg.objects.food)
        local selectedFood = cfg.objects.food[randomFoodIndex]
        
        local foodLocation = {
            posX = cfg.roomPosition.x + (gameState.food.x * 16),
            posY = cfg.roomPosition.y + (gameState.food.y * 16),
            posZ = cfg.roomPosition.z + 0.5,
            rotX = 0,
            rotY = 0,
            rotZ = 9
        }
        
        -- Special height adjustment for skooma
        if selectedFood == "rotating_skooma" then
            foodLocation.posZ = foodLocation.posZ + cfg.rotating_skooma_height_offset
        end
        
        local foodObject = {
            refId = selectedFood,
            count = 1,
            charge = -1,
            enchantmentCharge = -1,
            soul = "",
            location = foodLocation,
            scale = cfg.foodScale
        }
        
        -- Place food using the stored index
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Placing food")
        gameState.foodIndex = createGameObject(pid, cfg.roomCell, foodObject, "food", playerName, "food_" .. selectedFood)
        gameState.foodRefId = selectedFood
        
        if not gameState.foodIndex then
            tes3mp.LogMessage(enumerations.log.ERROR, "[SnakeGame] Failed to place food")
         else 
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Food placed successfully with index " .. gameState.foodIndex)
        end
    end
    
    buildGameRoom(pid)
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
    
    if not gameState or gameState.gameOver then
        tes3mp.LogMessage(enumerations.log.ERROR, "[SnakeGame] No game state or game over for " .. playerName)
        return
    end
    
    local cellDescription = cfg.roomCell
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
    
    -- Debugging information before update
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Current segment indices:")
    for i, idx in pairs(gameState.segmentIndices) do
        tes3mp.LogMessage(enumerations.log.INFO, "  Segment " .. i .. ": " .. tostring(idx))
    end
    
    -- Move head to new position
    local headRotation = cfg.headRotations[gameState.direction]
    local headLocation = {
        posX = cfg.roomPosition.x + (newHead.x * 16),
        posY = cfg.roomPosition.y + (newHead.y * 16),
        posZ = cfg.roomPosition.z + 9.5,
        rotX = math.rad(headRotation.rotX),
        rotY = math.rad(headRotation.rotY),
        rotZ = math.rad(headRotation.rotZ)
    }
    
    -- Move the head using direct packets
    tes3mp.ClearObjectList()
    tes3mp.SetObjectListPid(pid)
    tes3mp.SetObjectListCell(cellDescription)
    
    local splitIndex = gameState.headIndex:split("-")
    tes3mp.SetObjectRefNum(splitIndex[1])
    tes3mp.SetObjectMpNum(splitIndex[2])
    tes3mp.SetObjectRefId(cfg.objects.snakeHead)
    tes3mp.SetObjectPosition(headLocation.posX, headLocation.posY, headLocation.posZ)
    tes3mp.SetObjectRotation(headLocation.rotX, headLocation.rotY, headLocation.rotZ)
    tes3mp.AddObject()
    
    tes3mp.SendObjectMove(true, false)
    tes3mp.SendObjectRotate(true, false)
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Head moved to position (" .. newHead.x .. "," .. newHead.y .. ")")
    
    -- EITHER: Move a segment from the pool (when eating food)
    -- OR: Move the tail segment (when not eating food)
    
    local bodyLocation = {
        posX = cfg.roomPosition.x + (head.x * 16),
        posY = cfg.roomPosition.y + (head.y * 16),
        posZ = cfg.roomPosition.z + 9.3,
        rotX = 0,
        rotY = 0,
        rotZ = 0
    }
    
    local bodyIndexUsed = nil
    
    if ateFood then
        -- CASE: Eating food - get a new segment from the pool
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Eating food - adding a new segment")
        
        if indexStore["body_parts"] and #indexStore["body_parts"] > 0 then
            -- Use a segment from the pool
            bodyIndexUsed = table.remove(indexStore["body_parts"], 1)
            tes3mp.LogMessage(enumerations.log.INFO, 
                "[SnakeGame] Using segment from pool: " .. bodyIndexUsed)
        else
            -- Create a new segment if pool is empty
            local bodyObject = {
                refId = cfg.objects.snakeBody,
                count = 1,
                charge = -1,
                enchantmentCharge = -1,
                soul = ""
            }
            
            bodyIndexUsed = logicHandler.CreateObjectAtLocation(
                cellDescription,
                bodyLocation,  -- Initial position doesn't matter
                bodyObject,
                "place"
            )
            
            -- Set the correct scale
            setScale(pid, cellDescription, bodyIndexUsed, cfg.objects.snakeBody, cfg.bodyScale)
            
            tes3mp.LogMessage(enumerations.log.INFO, 
                "[SnakeGame] Created new segment with index: " .. bodyIndexUsed)
        end
    else
        -- CASE: Not eating - use the tail segment
        local tailPosition = #gameState.snake
        bodyIndexUsed = gameState.segmentIndices[tailPosition]
        
        if not bodyIndexUsed then
            -- Something went wrong - create a new segment
            tes3mp.LogMessage(enumerations.log.WARN, 
                "[SnakeGame] No tail index found! Creating a new segment.")
                
            local bodyObject = {
                refId = cfg.objects.snakeBody,
                count = 1,
                charge = -1,
                enchantmentCharge = -1,
                soul = ""
            }
            
            bodyIndexUsed = logicHandler.CreateObjectAtLocation(
                cellDescription,
                bodyLocation,
                bodyObject,
                "place"
            )
            
            -- Set the correct scale
            setScale(pid, cellDescription, bodyIndexUsed, cfg.objects.snakeBody, cfg.bodyScale)
        else
            tes3mp.LogMessage(enumerations.log.INFO, 
                "[SnakeGame] Using tail segment: " .. bodyIndexUsed)
        end
    end
    
    -- If we still don't have a body index, create one as a last resort
    -- if not bodyIndexUsed then
    --     tes3mp.LogMessage(enumerations.log.ERROR, 
    --         "[SnakeGame] Critical error - failed to get a body segment! Creating one now.")
            
    --     local bodyObject = {
    --         refId = cfg.objects.snakeBody,
    --         count = 1,
    --         charge = -1,
    --         enchantmentCharge = -1,
    --         soul = ""
    --     }
        
    --     bodyIndexUsed = logicHandler.CreateObjectAtLocation(
    --         cellDescription,
    --         bodyLocation,
    --         bodyObject,
    --         "place"
    --     )
        
    --     -- Set the correct scale
    --     setScale(pid, cellDescription, bodyIndexUsed, cfg.objects.snakeBody, cfg.bodyScale)
    -- end
    
    -- Move the selected segment to the position behind the head (only if we have a valid index)
    if bodyIndexUsed then
        tes3mp.ClearObjectList()
        tes3mp.SetObjectListPid(pid)
        tes3mp.SetObjectListCell(cellDescription)
        
        local splitIndex = bodyIndexUsed:split("-")
        tes3mp.SetObjectRefNum(splitIndex[1])
        tes3mp.SetObjectMpNum(splitIndex[2])
        tes3mp.SetObjectRefId(cfg.objects.snakeBody)
        tes3mp.SetObjectPosition(bodyLocation.posX, bodyLocation.posY, bodyLocation.posZ)
        tes3mp.AddObject()
        
        tes3mp.SendObjectMove(true, false)
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Moved segment " .. bodyIndexUsed .. " to position (" .. head.x .. "," .. head.y .. ")")
    end
    
    -- Update the snake array and segment indices
      local newSnake = {newHead, head}  -- New head followed by old head
      local newSegmentIndices = {}  -- Start with empty indices
      
      -- Add the body segment just behind the head
      newSegmentIndices[2] = bodyIndexUsed
      
      if ateFood then
          -- Add all existing segments (we're growing)
          for i = 2, #gameState.snake do
              table.insert(newSnake, gameState.snake[i])
              if gameState.segmentIndices[i] then
                  newSegmentIndices[i+1] = gameState.segmentIndices[i]
              end
          end
      else
          -- Add all existing segments except the tail (we're moving)
          for i = 2, #gameState.snake - 1 do
              table.insert(newSnake, gameState.snake[i])
              if gameState.segmentIndices[i] then
                  newSegmentIndices[i+1] = gameState.segmentIndices[i]
              end
          end
          
          -- Add the tail segment back to the pool if we have one
          local tailPos = #gameState.snake
          local tailIdx = gameState.segmentIndices[tailPos]
          if tailIdx and tailIdx ~= bodyIndexUsed then
              indexStore["body_parts"] = indexStore["body_parts"] or {}
              table.insert(indexStore["body_parts"], tailIdx)
              tes3mp.LogMessage(enumerations.log.INFO, 
                  "[SnakeGame] Added unused tail segment " .. tailIdx .. " back to the pool")
          end
      end
      
      -- Update the game state with the new snake and segment indices
      gameState.snake = newSnake
      gameState.segmentIndices = newSegmentIndices
    
    -- Log the updated segment indices
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Updated segment indices:")
    for i, idx in pairs(gameState.segmentIndices) do
        tes3mp.LogMessage(enumerations.log.INFO, "  Segment " .. i .. ": " .. tostring(idx))
    end
    
    -- Handle food eaten
    if ateFood then
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
        
        logicHandler.DeleteObject(pid, cellDescription, gameState.foodIndex, true)
        
        -- Generate new food position
        placeFood(pid)
        
        -- Randomly select one of the food items
        local randomFoodIndex = math.random(1, #cfg.objects.food)
        local selectedFood = cfg.objects.food[randomFoodIndex]
        
        local foodLocation = {
            posX = cfg.roomPosition.x + (gameState.food.x * 16),
            posY = cfg.roomPosition.y + (gameState.food.y * 16),
            posZ = cfg.roomPosition.z + 0.5,
            rotX = 0,
            rotY = 0,
            rotZ = 9
        }
        
        local foodObject = {
            refId = selectedFood,
            count = 1,
            charge = -1,
            enchantmentCharge = -1,
            soul = "",
            location = foodLocation,
            scale = cfg.foodScale
        }
        
        -- Special height adjustment for rotating_skooma
        if selectedFood == "rotating_skooma" then
            foodLocation.posZ = foodLocation.posZ + cfg.rotating_skooma_height_offset
        end
        
        -- Get the food index for the selected food
        if indexStore["food_" .. selectedFood] then
            gameState.foodIndex = indexStore["food_" .. selectedFood]
            gameState.foodRefId = selectedFood
            
           createObjects(cellDescription, {foodObject}, "place", gameState.foodIndex)
            -- Make sure the scale is correct
            setScale(pid, cellDescription, gameState.foodIndex, selectedFood, cfg.foodScale)
            
            tes3mp.LogMessage(enumerations.log.ERROR, 
                "[SnakeGame]gameState.foodIndex: " .. gameState.foodIndex)
            tes3mp.LogMessage(enumerations.log.ERROR, 
                "[SnakeGame]gameState.foodRefId: " .. gameState.foodRefId)
            tes3mp.LogMessage(enumerations.log.INFO, 
                "[SnakeGame] Food placed at (" .. gameState.food.x .. "," .. gameState.food.y .. ")")
        else
            tes3mp.LogMessage(enumerations.log.ERROR, 
                "[SnakeGame] No food index found for " .. selectedFood)
        end
    end
    
    -- Apply visual effects
    logicHandler.RunConsoleCommandOnObject(pid,
                                          "PlaySound3DVP, \"corpDRAG\", 1.0, 1.0",
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
    
    -- Load stored indexes
    loadIndexStore()
    
    tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Records Created and Indexes Loaded.")

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

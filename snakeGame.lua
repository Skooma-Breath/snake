--TODO :
--     create a table of uniqueIndexes to reuse every time the game is played
--     create the objects and place them outside the game room at some location
--     use a modified CreateObjectAtLocation in initGameState and then use ResendPlace to move the snake in UpdateGame 

-- Configuration
local config = {
    
    -- GUI IDs
    mainMenuId = 31450,
    gameOverId = 31451,
    
    --seconds between snake updates (travel speed)
    updateInterval = .2,
    initialSnakeLength = 3,
    
    --scales 
    headScale = 1,
    bodyScale = .6,
    foodScale = 1.5,
    wallScale = -1.25, --negative to invert the rectnagular stone block so we see the texture on the inside
    borderScale = 2,
    
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
            "vo\\d\\m\\tidl_dm015.mp3", -- dunmer burp
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "vo\\k\\m\\idl_km001.mp3", -- sweet skooma
            "vo\\n\\m\\hit_nm005.mp3", -- nord groan
            "vo\\r\\m\\hit_rm012.mp3", -- redguard groan
            "Vo\\o\\m\\hit_om007.mp3", -- orc noise
            "Vo\\o\\m\\hit_om006.mp3", -- orcnoise
        },
        ["rotating_skooma_pipe"] = {
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "vo\\d\\m\\idl_dm001.mp3", -- dunmer
            "vo\\h\\m\\idl_hm008.mp3", -- altmer clear throat
            "vo\\h\\m\\idl_hm007.mp3", -- altmer hummmmm
            "Vo\\i\\m\\Idl_IM004.mp3",  --imperial clear throat
            "Vo\\i\\m\\Idl_IM009.mp3",  --imperial clear throat
            "vo\\k\\m\\idl_km001.mp3", -- sweet skooma
            "vo\\n\\m\\idl_nm002.mp3", -- nord cough
            "vo\\n\\m\\idl_nm004.mp3", -- nord cough
            "vo\\n\\m\\idl_nm007.mp3", -- nord cough
            "vo\\r\\m\\idl_rm009.mp3", -- redguard cough
            "vo\\r\\m\\hit_rm007.mp3", -- redguard cough
            "vo\\w\\m\\idl_wm002.mp3", -- bosmer cough
            "Vo\\o\\m\\idl_om006.mp3", -- orc cough
            "Vo\\o\\m\\idl_om007.mp3", -- orc clear throat
            "Vo\\o\\m\\hit_om007.mp3", -- orc noise
            "Vo\\o\\m\\hit_om006.mp3", -- orcnoise
        },
        ["rotating_moonsugar"] = {
            "Vo\\o\\m\\Idl_OM005.mp3",   -- orc sniff
            "Vo\\i\\m\\Idl_IM001.mp3",  --imperial sniff
            "Vo\\i\\m\\Idl_IM002.mp3",
            "vo\\d\\m\\idl_dm002.mp3", --dunmer
            "vo\\a\\m\\hlo_am056.mp3", -- argonian
            "vo\\a\\m\\idl_am008.mp3", -- argonian nom noms
            "vo\\b\\m\\idl_bm009.mp3", --breton
            "vo\\h\\m\\idl_hm009.mp3", -- altmer sniff
            "vo\\k\\m\\idl_km004.mp3", -- khajiit sniff
            "vo\\k\\m\\hlo_km133.mp3", -- our sugar is yours friend
            "vo\\k\\m\\hlo_km120.mp3", -- welcome friend, share some sugar?
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

-- Helper function to convert degrees to radians
local function degToRad(degrees)
    return degrees * math.pi / 180
end

local function setScale(pid, cellDescription, uniqueIndex, refId, scale)

    tes3mp.ClearObjectList()
    tes3mp.SetObjectListPid(pid)
    tes3mp.SetObjectListCell(config.roomCell)
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
            "[SnakeGame] Clearing " .. #SnakeGame.gameObjects[playerName] .. " objects for " .. playerName)
            
        for i = #SnakeGame.gameObjects[playerName], 1, -1 do
            local object = SnakeGame.gameObjects[playerName][i]
            if object and object.uniqueIndex and logicHandler.IsCellLoaded(object.cell) then
                -- Try to delete each object
                local success = pcall(function() 
                    -- DeleteObject(pid, object.cell, object.uniqueIndex, true)
                    logicHandler.DeleteObject(pid, object.cell, object.uniqueIndex, true)
                end)
                
                if not success then
                    tes3mp.LogMessage(enumerations.log.WARN, 
                        "[SnakeGame] Failed to delete object " .. object.uniqueIndex)
                end
            end
        end
        
        SnakeGame.gameObjects[playerName] = nil
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Cleared all objects for " .. playerName)
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
        tes3mp.CustomMessageBox(pid, config.gameOverId, "Game Over\n" .. color.Red .. message,
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
    
    local foodPos = {x = math.random(0, config.roomSize - 1), y = math.random(0, config.roomSize - 1)}
    
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
                                                        math.floor(config.updateInterval * 1000), 
                                                        "i", 
                                                        pid)
    
    tes3mp.StartTimer(SnakeGame.timers[playerName])
end

-- Build the game room with walls
local function buildGameRoom(pid)
    local playerName = string.lower(Players[pid].accountName)
    local cellDescription = config.roomCell
    
    SnakeGame.gameObjects[playerName] = SnakeGame.gameObjects[playerName] or {}
    

    local wallLocation = {
        posX = config.wallPosition.x,
        posY = config.wallPosition.y,
        posZ = config.wallPosition.z,
        rotX = degToRad(-180),
        rotY = 0,
        rotZ = 0
    }
    
    local wallObject = {
        refId = config.objects.wall,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = ""
    }
    
    local wallIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                         wallLocation, 
                                                         wallObject, 
                                                         "place")
    
    
    setScale(pid, cellDescription, wallIndex,wallObject.refId, config.wallScale)
    
    table.insert(SnakeGame.gameObjects[playerName], {
        uniqueIndex = wallIndex,
        cell = cellDescription,
        type = "wall"
    })
    
    tes3mp.LogMessage(enumerations.log.INFO, 
                    "[SnakeGame] Placed wall at (" .. config.roomPosition.x .. "," .. config.roomPosition.y .. ",0)")
    
    local floorLocation = {
        posX = config.roomPosition.x,
        posY = config.roomPosition.y, 
        posZ = config.roomPosition.z - 23, -- Slightly below ground
        rotX = 0,
        rotY = 0,
        rotZ = 0
    }
        
    local floorObject = {
        refId = config.objects.floor, -- A flat object for the floor
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
    local size = config.roomSize
    local step = 1  -- step size in grid units
    
    local markerObject = {
        refId = config.objects.border,
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
                    posX = config.roomPosition.x + (x * 16),
                    posY = config.roomPosition.y + (y * 16),
                    posZ = config.roomPosition.z + 8,
                    rotX = 0,
                    rotY = 0,
                    rotZ = 0
                }
    
                local markerIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                         markerLocation, 
                                                         markerObject, 
                                                         "place")
                
                setScale(pid, cellDescription, markerIndex, markerObject.refId, config.borderScale)
    
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
       tes3mp.SetPos(pid, config.platformPosition.x, config.platformPosition.y, config.platformPosition.z + 1)
       tes3mp.SetRot(pid, degToRad(60), 0)
       tes3mp.SendCell(pid)
       tes3mp.SendPos(pid)
end

-- Initialize game state
local function initGameState(pid)
    local playerName = string.lower(Players[pid].accountName)
    
    if SnakeGame.activePlayers[playerName] then
        stopGame(pid)
    end
    
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
    local centerX = math.floor(config.roomSize / 2)
    local centerY = math.floor(config.roomSize / 2)
    
    for i = 1, config.initialSnakeLength do
        table.insert(gameState.snake, {x = centerX - (i - 1), y = centerY})
    end
    
    SnakeGame.gameObjects[playerName] = {}
    
    -- Place head
    local headLocation = {
        posX = config.roomPosition.x + (gameState.snake[1].x * 16),
        posY = config.roomPosition.y + (gameState.snake[1].y * 16),
        posZ = config.roomPosition.z + 9.5,
        rotX = math.rad(config.headRotations.right.rotX),
        rotY = math.rad(config.headRotations.right.rotY),
        rotZ = math.rad(config.headRotations.right.rotZ)
    }
    
    local headObject = {
        refId = config.objects.snakeHead,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = ""
    }
    
    gameState.headIndex = logicHandler.CreateObjectAtLocation(config.roomCell, 
                                                             headLocation, 
                                                             headObject, 
                                                             "place")
    
    table.insert(SnakeGame.gameObjects[playerName], {
        uniqueIndex = gameState.headIndex,
        cell = config.roomCell,
        type = "head"
    })
    
    setScale(pid, config.roomCell, gameState.headIndex, headObject.refId, config.headScale)
    
    -- Place body segments
    for i = 2, #gameState.snake do
        local segmentLocation = {
            posX = config.roomPosition.x + (gameState.snake[i].x * 16),
            posY = config.roomPosition.y + (gameState.snake[i].y * 16),
            posZ = config.roomPosition.z + 9.3,
            rotX = 0,
            rotY = 0,
            rotZ = 0
        }
        
        local segmentObject = {
            refId = config.objects.snakeBody,
            count = 1,
            charge = -1,
            enchantmentCharge = -1,
            soul = ""
        }
        
        local segmentIndex = logicHandler.CreateObjectAtLocation(config.roomCell, 
                                                                segmentLocation, 
                                                                segmentObject, 
                                                                "place")
        
        gameState.segmentIndices[i] = segmentIndex
        table.insert(SnakeGame.gameObjects[playerName], {
            uniqueIndex = segmentIndex,
            cell = config.roomCell,
            type = "body"
        })
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Placed segment " .. i .. " at (" .. gameState.snake[i].x .. "," .. gameState.snake[i].y .. ")")

        -- setScale(pid, config.roomCell, segmentIndex, segmentObject.refId, config.bodyScale)
    end
    
    if config.initFood and not gameState.foodIndex then
        placeFood(pid)
        local foodLocation = {
            posX = config.roomPosition.x + (gameState.food.x * 16),
            posY = config.roomPosition.y + (gameState.food.y * 16),
            posZ = config.roomPosition.z + 0.5,
            rotX = 0,
            rotY = 0,
            rotZ = 9
        }

        -- Randomly select one of the food items
        local randomFoodIndex = math.random(1, #config.objects.food)
        local selectedFood = config.objects.food[randomFoodIndex]
        
        -- Special height adjustment for rotating_skooma
        if selectedFood == "rotating_skooma" then
            foodLocation.posZ = foodLocation.posZ + config.rotating_skooma_height_offset  -- 9 units higher
        end
        
        local foodObject = {
            refId = selectedFood,
            count = 1,
            charge = -1,
            enchantmentCharge = -1,
            soul = ""
        }
        
        gameState.foodIndex = logicHandler.CreateObjectAtLocation(config.roomCell, 
                                                                 foodLocation, 
                                                                 foodObject, 
                                                                 "place")
        
        gameState.foodRefId = foodObject.refId 
        
        table.insert(SnakeGame.gameObjects[playerName], {
            uniqueIndex = gameState.foodIndex,
            cell = config.roomCell,
            type = "food"
        })
        
        setScale(pid, config.roomCell, gameState.foodIndex, foodObject.refId, config.foodScale)
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Initial food (" .. selectedFood .. ") placed at (" .. gameState.food.x .. "," .. gameState.food.y .. ")")
    end
    
    -- placeFood(pid)
    buildGameRoom(pid)
    startGameTimer(pid)
    
    tes3mp.MessageBox(pid, -1, "Snake Game Started! Use chat commands: " .. 
                             config.commands.up .. ", " .. 
                             config.commands.down .. ", " ..
                             config.commands.left .. ", " ..
                             config.commands.right .. " to control the snake.")
end

-- Update game logic
function UpdateGame(pid)
    local playerName = string.lower(Players[pid].accountName)
    local gameState = SnakeGame.activePlayers[playerName]
    
    if not gameState or gameState.gameOver then
        tes3mp.LogMessage(enumerations.log.ERROR, "[SnakeGame] No game state or game over for " .. playerName)
        return
    end
    
    local cellDescription = config.roomCell
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
    if newHead.x < 0 or newHead.x >= config.roomSize or 
       newHead.y < 0 or newHead.y >= config.roomSize then
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
    local ateFood = (config.foodCollision and newHead.x == gameState.food.x and newHead.y == gameState.food.y) or
                    (config.initFood and not gameState.foodIndex)
    
    -- Remove old head visually
    if gameState.headIndex then
        for i, obj in ipairs(SnakeGame.gameObjects[playerName]) do
            if obj.uniqueIndex == gameState.headIndex then
                -- DeleteObject(pid, obj.cell, obj.uniqueIndex, true)
                logicHandler.DeleteObject(pid, obj.cell, obj.uniqueIndex, true)
                table.remove(SnakeGame.gameObjects[playerName], i)
                tes3mp.LogMessage(enumerations.log.INFO, 
                    "[SnakeGame] Cleared head with index " .. obj.uniqueIndex .. " for " .. playerName)
                break
            end
        end
    end
    
    -- Place new head
    local headRotation = config.headRotations[gameState.direction]
    local headLocation = {
        posX = config.roomPosition.x + (newHead.x * 16),
        posY = config.roomPosition.y + (newHead.y * 16),
        posZ = config.roomPosition.z + 9.5,
        rotX = math.rad(headRotation.rotX),
        rotY = math.rad(headRotation.rotY),
        rotZ = math.rad(headRotation.rotZ)
    }
    
    local headObject = {
        refId = config.objects.snakeHead,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = ""
    }
    
    gameState.headIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                             headLocation, 
                                                             headObject, 
                                                             "place")
    
    table.insert(SnakeGame.gameObjects[playerName], {
        uniqueIndex = gameState.headIndex,
        cell = cellDescription,
        type = "head"
    })
    
    setScale(pid, config.roomCell, gameState.headIndex, headObject.refId, config.headScale)
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Head placed at (" .. newHead.x .. "," .. newHead.y .. ")")
    
    -- Place body segment at old head position
    local bodyLocation = {
        posX = config.roomPosition.x + (head.x * 16),
        posY = config.roomPosition.y + (head.y * 16),
        posZ = config.roomPosition.z + 9.3,
        rotX = 0,
        rotY = 0,
        rotZ = 0
    }
    
    local bodyObject = {
        refId = config.objects.snakeBody,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = ""
    }
    
    local bodyIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                         bodyLocation, 
                                                         bodyObject, 
                                                         "place")
    
    table.insert(SnakeGame.gameObjects[playerName], {
        uniqueIndex = bodyIndex,
        cell = cellDescription,
        type = "body"
    })
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] New body segment placed at (" .. head.x .. "," .. head.y .. ")")

    -- setScale(pid, config.roomCell, bodyIndex, bodyObject.refId, config.bodyScale)

    -- Add the new head to the front of the snake
    table.insert(gameState.snake, 1, newHead)
    
    -- Update segment indices
    gameState.segmentIndices = gameState.segmentIndices or {}
    
    -- Shift all indices and add new body segment
    for i = #gameState.snake, 3, -1 do
        gameState.segmentIndices[i] = gameState.segmentIndices[i-1]
    end
    gameState.segmentIndices[2] = bodyIndex
    
    -- Handle food
    if ateFood then
        -- Keep the tail - we're growing
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Ate food - growing snake")
        gameState.score = gameState.score + 1
        
        -- tes3mp.PlaySpeech(pid, "Vo\\o\\m\\Idl_OM005.mp3")
        -- Play the basic food eating sound
        logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound " .. config.eatFoodSound, false)
        
        -- If there was a previous food and it has voice lines, play a random one
        if gameState.foodRefId and config.foodVoiceLines[gameState.foodRefId] then
            local voiceLines = config.foodVoiceLines[gameState.foodRefId]
            local randomLine = voiceLines[math.random(1, #voiceLines)]
            tes3mp.LogMessage(enumerations.log.INFO, 
                "[SnakeGame] Playing voice line: " .. randomLine .. " for food: " .. gameState.foodRefId)
            tes3mp.PlaySpeech(pid, randomLine)
            -- tes3mp.PlaySpeech(pid, "Vo\\o\\m\\Idl_OM005.mp3")
        end
        
        -- Remove old food
        if gameState.foodIndex then
            for i, obj in ipairs(SnakeGame.gameObjects[playerName]) do
                if obj.uniqueIndex == gameState.foodIndex then
                    logicHandler.DeleteObject(pid, obj.cell, obj.uniqueIndex, true)
                    table.remove(SnakeGame.gameObjects[playerName], i)
                    break
                end
            end
        end
        
        -- Place new food
        placeFood(pid)
        local foodLocation = {
            posX = config.roomPosition.x + (gameState.food.x * 16),
            posY = config.roomPosition.y + (gameState.food.y * 16),
            posZ = config.roomPosition.z + 0.5,
            rotX = 0,
            rotY = 0,
            rotZ = 9
        }
        
        -- Randomly select one of the food items
        local randomFoodIndex = math.random(1, #config.objects.food)
        local selectedFood = config.objects.food[randomFoodIndex]
        
        -- Special height adjustment for rotating_skooma
        if selectedFood == "rotating_skooma" then
            foodLocation.posZ = foodLocation.posZ + config.rotating_skooma_height_offset  -- 9 units higher
        end
        
        local foodObject = {
            refId = selectedFood,
            count = 1,
            charge = -1,
            enchantmentCharge = -1,
            soul = ""
        }
        
        gameState.foodIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                                 foodLocation, 
                                                                 foodObject, 
                                                                 "place")
        
        gameState.foodRefId = foodObject.refId
        
        table.insert(SnakeGame.gameObjects[playerName], {
            uniqueIndex = gameState.foodIndex,
            cell = cellDescription,
            type = "food"
        })
        
        setScale(pid, config.roomCell, gameState.foodIndex, foodObject.refId, config.foodScale)
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Food placed at (" .. gameState.food.x .. "," .. gameState.food.y .. ")")
    else
        -- Remove the tail - we're not growing
        local tail = gameState.snake[#gameState.snake]
        local tailIndex = gameState.segmentIndices[#gameState.snake]
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Removing tail at position (" .. tail.x .. "," .. tail.y .. ") with index " .. tostring(tailIndex))
        
        if tailIndex then
            for i, obj in ipairs(SnakeGame.gameObjects[playerName]) do
                if obj.uniqueIndex == tailIndex then
                    -- DeleteObject(pid, obj.cell, obj.uniqueIndex, true)
                    logicHandler.DeleteObject(pid, obj.cell, obj.uniqueIndex, true)
                    table.remove(SnakeGame.gameObjects[playerName], i)
                    tes3mp.LogMessage(enumerations.log.INFO, 
                        "[SnakeGame] Cleared tail with index " .. tailIndex)
                    break
                end
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
                                          "PlaySound3DVP, \"corpDRAG\", 1.0, 1.0",
                                          cellDescription,
                                          gameState.headIndex,
                                          false)
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Final snake state: length=" .. #gameState.snake .. 
        ", head=(" .. newHead.x .. "," .. newHead.y .. ")")
    
    -- Debug info
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Segment indices:")
    for i, idx in pairs(gameState.segmentIndices) do
        if idx then
            tes3mp.LogMessage(enumerations.log.INFO, 
                "[SnakeGame] Segment " .. i .. " at position (" .. 
                gameState.snake[i].x .. "," .. gameState.snake[i].y .. 
                ") has index " .. tostring(idx))
        end
    end
    
    startGameTimer(pid)
end

-- Command handler for customCommandHooks.registerCommand
local function commandHandler(pid, command, args)
    local playerName = string.lower(Players[pid].accountName)
    command = string.lower(command[1])
    
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Command received: " .. command .. " from player: " .. playerName)
    
    if command == config.commands.start then
        tes3mp.CustomMessageBox(pid, config.mainMenuId, "Snake Game", 
                              color.Green .. "Start Game;" ..
                              color.Red .. "Quit")
        return true
        -- initGameState(pid)
    elseif command == config.commands.stop then
        if SnakeGame.activePlayers[playerName] then
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Stopping game for: " .. playerName)
            stopGame(pid)
        else
            tes3mp.MessageBox(pid, -1, "No active game to stop.")
        end
    elseif command == config.commands.up or
           command == config.commands.down or
           command == config.commands.left or
           command == config.commands.right then
        if SnakeGame.activePlayers[playerName] and not SnakeGame.activePlayers[playerName].gameOver then
            local newDirection = command
            local currentDirection = SnakeGame.activePlayers[playerName].direction
            
            if (newDirection == config.commands.up and currentDirection ~= config.commands.down) or
               (newDirection == config.commands.down and currentDirection ~= config.commands.up) or
               (newDirection == config.commands.left and currentDirection ~= config.commands.right) or
               (newDirection == config.commands.right and currentDirection ~= config.commands.left) then
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
    if idGui == config.gameOverId then
        if tonumber(data) == 0 then -- Play Again
            initGameState(pid)
        elseif tonumber(data) == 1 then -- Quit
            stopGame(pid)
        end
    elseif idGui == config.mainMenuId then
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
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Records Created.")

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
customCommandHooks.registerCommand(config.commands.start, commandHandler)
customCommandHooks.registerCommand(config.commands.stop, commandHandler)
customCommandHooks.registerCommand(config.commands.up, commandHandler)
customCommandHooks.registerCommand(config.commands.down, commandHandler)
customCommandHooks.registerCommand(config.commands.left, commandHandler)
customCommandHooks.registerCommand(config.commands.right, commandHandler)

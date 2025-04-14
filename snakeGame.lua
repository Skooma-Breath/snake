-- SnakeGame.lua
-- A Snake game implementation for TES3MP
-- Save this file in your server/scripts/custom folder

local config = {
    -- GUI IDs
    mainMenuId = 31450,
    gameOverId = 31451,
    
    -- Game settings
    initialSnakeLength = 3,
    maxSnakeLength = 50,
    updateInterval = .3, -- seconds between updates (lower = faster game)
    roomSize = 16, -- size of the game area (16x16)
    
    -- Control commands
    commands = {
        up = "raise",
        down = "lower",
        left = "left",
        right = "right",
        start = "snake",
        stop = "stop"
    },
    
    -- Objects
    objects = {
        snakeHead = "b_n_imperial_m_head_01", -- Snake head object
        snakeBody = "b_v_wood elf_f_head_01",   -- Snake body segments
        food = "potion_skooma_01",     -- Food object
        wall = "ex_imp_plat_01",          -- Wall object
        platform = "misc_uni_pillow_01"
    },
    
    -- Room location (where to create the game arena)
    roomCell = "Balmora, Guild of Mages",
    roomPosition = {
        x = 0, 
        y = 0, 
        z = 0
    },
    
    -- Player platform position
    platformPosition = {
        x = 131,
        y = -11,
        z = 3
    },

    -- Rotations adjusted based on your feedback
    rotations = {
        up = { rotX = 0, rotY = 0, rotZ = 0 },    -- Correct for up
        down = { rotX = 0, rotY = 0, rotZ = 180 },    -- Correct for down
        left = { rotX = 0, rotY = 0, rotZ = 270 },  -- Swapped left and right rotations
        right = { rotX = 0, rotY = 0, rotZ = 90 }   -- Swapped left and right rotations
    },
    
    -- Specific rotations for the head
    headRotations = {
        up = { rotX = 0, rotY = 0, rotZ = 180 },
        down = { rotX = 0, rotY = 0, rotZ = 0 },
        left = { rotX = 0, rotY = 0, rotZ = 90 },
        right = { rotX = 0, rotY = 0, rotZ = 270 }
    },
}

-- Game state variables
local SnakeGame = {
    activePlayers = {}, -- Players currently in a game
    gameObjects = {}, -- All placed objects
    timers = {} -- Game update timers
}

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

-- Place food at a random position not occupied by the snake
local function placeFood(pid)
    local playerName = string.lower(Players[pid].accountName)
    local gameState = SnakeGame.activePlayers[playerName]
    if not gameState then return end
    
    local snake = gameState.snake
    local food = gameState.food
    local validPosition = false
    
    -- Try to find a valid position for the food
    while not validPosition do
        food.x = math.random(0, config.roomSize - 1)
        food.y = math.random(0, config.roomSize - 1)
        
        validPosition = true
        
        -- Check if the position is occupied by the snake
        for _, segment in ipairs(snake) do
            if segment.x == food.x and segment.y == food.y then
                validPosition = false
                break
            end
        end
    end
    
    SnakeGame.activePlayers[playerName].food = food
end

-- Start the game update timer
local function startGameTimer(pid)
    local playerName = string.lower(Players[pid].accountName)
    
    -- Clear any existing timer
    if SnakeGame.timers[playerName] then
        tes3mp.StopTimer(SnakeGame.timers[playerName])
    end
    
    -- Create a new timer
    SnakeGame.timers[playerName] = tes3mp.CreateTimerEx("UpdateGame", 
                                   time.seconds(config.updateInterval), 
                                   "i", pid)
    tes3mp.StartTimer(SnakeGame.timers[playerName])
end

-- Improved buildGameRoom function with better wall visibility and placement
local function buildGameRoom(pid)
    local playerName = string.lower(Players[pid].accountName)
    local cellDescription = config.roomCell
    
    -- Check if cell is loaded
    if not logicHandler.IsCellLoaded(cellDescription) then
        logicHandler.LoadCell(cellDescription)
    end
    
    -- Create walls - only at the perimeter with better visibility
    -- for x = -1, config.roomSize do
        -- for y = -1, config.roomSize do
            -- Only place walls at the edges
            -- if x == -1 or x == config.roomSize or y == -1 or y == config.roomSize then
                -- Calculate position
                local posX = config.roomPosition.x 
                local posY = config.roomPosition.y 
                local posZ = config.roomPosition.z
                
                -- Adjust scale and height for better visibility
                local scale = -2 -- Larger scale for visibility
                
                local location = {
                    posX = posX,
                    posY = posY,
                    posZ = posZ,
                    rotX = 0,
                    rotY = 0,
                    rotZ = 0
                }
                
                local wallObject = {
                    refId = config.objects.wall,
                    count = 1,
                    charge = -1,
                    enchantmentCharge = -1,
                    soul = "",
                    scale = scale
                }
                
                local uniqueIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                               location, 
                                                               wallObject, 
                                                               "place")
                tes3mp.ClearObjectList()
                tes3mp.SetObjectListPid(pid)
                tes3mp.SetObjectListCell(cellDescription)
                local splitIndex = uniqueIndex:split("-")
                tes3mp.SetObjectRefNum(splitIndex[1])
                tes3mp.SetObjectMpNum(splitIndex[2])
                tes3mp.SetObjectRefId(wallObject.refId)
                tes3mp.SetObjectScale(scale)
                tes3mp.AddObject()
                tes3mp.SendObjectScale(true, false)
                
                table.insert(SnakeGame.gameObjects[playerName], {
                    uniqueIndex = uniqueIndex,
                    cell = cellDescription,
                    type = "wall"
                })
                
                -- Log wall placement
                tes3mp.LogMessage(enumerations.log.INFO, 
                    "[SnakeGame] Placed wall at (" .. posX .. "," .. posY .. "," .. posZ .. 
                    ") with scale " .. scale)
            -- end
        -- end
    -- end
    
    -- Create player platform with better visibility
    local platformLocation = {
        posX = config.platformPosition.x,
        posY = config.platformPosition.y,
        posZ = config.platformPosition.z,
        rotX = 0,
        rotY = 0,
        rotZ = math.rad(90)
    }
    
    local platformObject = {
        refId = config.objects.platform,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = "",
        scale = 1 -- Larger scale for visibility
    }
    
    local uniqueIndex1 = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                   platformLocation, 
                                                   platformObject, 
                                                   "place")
    tes3mp.ClearObjectList()
    tes3mp.SetObjectListPid(pid)
    tes3mp.SetObjectListCell(cellDescription)
    local splitIndex1 = uniqueIndex:split("-")
    tes3mp.SetObjectRefNum(splitIndex[1])
    tes3mp.SetObjectMpNum(splitIndex[2])
    tes3mp.SetObjectRefId(wallObject.refId)
    tes3mp.SetObjectScale(scale)
    tes3mp.AddObject()
    tes3mp.SendObjectScale(true, false)
    
    table.insert(SnakeGame.gameObjects[playerName], {
        uniqueIndex = uniqueIndex1,
        cell = cellDescription,
        type = "wall"
    })
    
    -- Let's also add some visual markers at the corners for better orientation
    local corners = {
        {x = -1, y = -1}, {x = -1, y = config.roomSize}, 
        {x = config.roomSize, y = -1}, {x = config.roomSize, y = config.roomSize}
    }
    
    for _, corner in ipairs(corners) do
        local markerLocation = {
            posX = config.roomPosition.x + (corner.x * 16),
            posY = config.roomPosition.y + (corner.y * 16),
            posZ = config.roomPosition.z + 5, -- Higher to be visible
            rotX = 0,
            rotY = 0,
            rotZ = 0
        }
        
        local markerObject = {
            refId = "light_de_lantern_14", -- A lantern or any visible marker
            count = 1,
            charge = -1,
            enchantmentCharge = -1,
            soul = "",
            scale = 1.0
        }
        
        local markerIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                     markerLocation, 
                                                     markerObject, 
                                                     "place")
        
        table.insert(SnakeGame.gameObjects[playerName], {
            uniqueIndex = markerIndex,
            cell = cellDescription,
            type = "marker"
        })
    end
    
    -- Create floor for better visibility of the playfield
    -- for x = 0, config.roomSize - 1 do
        -- for y = 0, config.roomSize - 1 do
            -- Only place a floor tile every other position to reduce object count
            -- if (x + y) % 2 == 0 then  
                local floorLocation = {
                    posX = config.roomPosition.x,
                    posY = config.roomPosition.y, 
                    posZ = config.roomPosition.z - 23, -- Slightly below ground
                    rotX = 0,
                    rotY = 0,
                    rotZ = 0
                }
                
                local floorObject = {
                    refId = "in_lava_1024", -- A flat object for the floor
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
            -- end
        -- end
    -- end
    
    -- Teleport the player to the platform
    tes3mp.SetCell(pid, cellDescription)
    tes3mp.SetPos(pid, config.platformPosition.x, config.platformPosition.y, config.platformPosition.z + 1)
    tes3mp.SendCell(pid)
    tes3mp.SendPos(pid)
    
    -- Disable player controls except for camera
    -- logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerControls", false)
    logicHandler.RunConsoleCommandOnPlayer(pid, "DisableVanityMode", false)
    -- Allow looking around
    logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerViewSwitch", false)
    -- Force first person view for better gameplay
    logicHandler.RunConsoleCommandOnPlayer(pid, "PCForce1stPerson", false)
    
    -- Set player angle to look down at the playfield (approximately 45 degrees)
    logicHandler.RunConsoleCommandOnPlayer(pid, "Player->setangle x 60", false)
    logicHandler.RunConsoleCommandOnPlayer(pid, "Player->setangle z 0", false)

    -- Add ambient light to make the game area more visible
    -- logicHandler.RunConsoleCommandOnPlayer(pid, "set gamehour to 12", false) -- Set to noon for maximum light
    
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Game room built for player: " .. playerName)
end

-- Clear all game objects for a player
local function clearGameObjects(pid)
    local playerName = string.lower(Players[pid].accountName)
    
    -- Check if player has game objects
    if not SnakeGame.gameObjects[playerName] then 
        SnakeGame.gameObjects[playerName] = {}
        return 
    end
    
    -- Delete all objects (walls, snake parts, and food)
    for i = #SnakeGame.gameObjects[playerName], 1, -1 do
        local object = SnakeGame.gameObjects[playerName][i]
        
        if object and object.uniqueIndex and object.cell then
            -- Check if the cell is loaded
            if logicHandler.IsCellLoaded(object.cell) then
                -- Delete the object for everyone
                logicHandler.DeleteObject(pid, object.cell, object.uniqueIndex, true)
            end
            -- Remove from our tracking array regardless
            table.remove(SnakeGame.gameObjects[playerName], i)
        end
    end
    
    -- Make sure the array is cleared completely
    SnakeGame.gameObjects[playerName] = {}
    
    -- Log to verify objects are being cleared
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Cleared all game objects for " .. playerName)
end

-- Clear only snake and food objects, keep walls
local function clearSnakeAndFood(pid)
    local playerName = string.lower(Players[pid].accountName)
    
    -- Check if player has game objects
    if not SnakeGame.gameObjects[playerName] then return end
    
    -- Only clear the snake and food, not the walls
    for i = #SnakeGame.gameObjects[playerName], 1, -1 do
        local object = SnakeGame.gameObjects[playerName][i]
        
        if object and object.type and (object.type == "head" or object.type == "body" or object.type == "food") then
            -- Delete the object
            if logicHandler.IsCellLoaded(object.cell) then
                logicHandler.DeleteObject(pid, object.cell, object.uniqueIndex, true)
                table.remove(SnakeGame.gameObjects[playerName], i)
            end
        end
    end
end

-- Alternative segment direction calculation based on actual movement
local function calculateSegmentDirections(snake)
    local directions = {}
    
    -- Head direction will be set by the game state
    directions[1] = "down" -- Placeholder
    
    -- For each body segment
    for i = 2, #snake do
        local current = snake[i]
        local prev = snake[i-1]
        
        -- Direction is where this segment needs to look to "see" the previous segment
        if current.x < prev.x then
            directions[i] = "left" -- Need to look right to see previous segment
        elseif current.x > prev.x then
            directions[i] = "right" -- Need to look left to see previous segment
        elseif current.y < prev.y then
            directions[i] = "down" -- Need to look down to see previous segment
        elseif current.y > prev.y then
            directions[i] = "up" -- Need to look up to see previous segment
        else
            -- Fallback (shouldn't happen)
            directions[i] = directions[i-1] or "down"
        end
        
        -- Debug log
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Segment " .. i .. " at (" .. current.x .. "," .. current.y .. 
            ") looking at prev segment at (" .. prev.x .. "," .. prev.y .. 
            ") - direction: " .. directions[i])
    end
    
    return directions
end

-- Updated renderGame function with fixed rotation logic
local function renderGame(pid)
    local playerName = string.lower(Players[pid].accountName)
    local gameState = SnakeGame.activePlayers[playerName]
    if not gameState then return end
    
    local cellDescription = config.roomCell
    
    -- Clear previous snake and food objects
    clearSnakeAndFood(pid)
    
    -- Calculate segment directions
    local segmentDirections = calculateSegmentDirections(gameState.snake)
    
    -- Override head direction with the current movement direction
    segmentDirections[1] = gameState.direction
    
    -- Place snake head with proper rotation
    local headRotation = config.headRotations[gameState.direction]
    
    local headLocation = {
        posX = config.roomPosition.x + (gameState.snake[1].x * 16),
        posY = config.roomPosition.y + (gameState.snake[1].y * 16),
        posZ = config.roomPosition.z + 0.5, -- Slightly above ground
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
    local headIndex
    if not SnakeGame.gameObjects[playerName].uniqueIndex then
        headIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                    headLocation, 
                                                    headObject, 
                                                    "place")
        
        table.insert(SnakeGame.gameObjects[playerName], {
            uniqueIndex = headIndex,
            cell = cellDescription,
            type = "head"
        })
    else
        ResendPlace(pid, SnakeGame.gameObjects[playerName][1].uniqueIndex, cellDescription, false)
    end

    -- Log the head rotation
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Placed head facing " .. gameState.direction .. 
        " with rotation " .. headRotation.rotZ .. " degrees")
    
    -- Place snake body segments with appropriate rotations
    for i = 2, #gameState.snake do
        local segmentDirection = segmentDirections[i]
        local segmentRotation = config.rotations[segmentDirection]
        
        local segmentLocation = {
            posX = config.roomPosition.x + (gameState.snake[i].x * 16),
            posY = config.roomPosition.y + (gameState.snake[i].y * 16),
            posZ = config.roomPosition.z + 0.3, -- Slightly above ground
            rotX = math.rad(segmentRotation.rotX),
            rotY = math.rad(segmentRotation.rotY),
            rotZ = math.rad(segmentRotation.rotZ)
        }
        
        local segmentObject = {
            refId = config.objects.snakeBody,
            count = 1,
            charge = -1,
            enchantmentCharge = -1,
            soul = ""
        }
        
        local segmentIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                     segmentLocation, 
                                                     segmentObject, 
                                                     "place")
        
        table.insert(SnakeGame.gameObjects[playerName], {
            uniqueIndex = segmentIndex,
            cell = cellDescription,
            type = "body"
        })
        
        -- Log the segment rotation
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Placed segment " .. i .. " facing " .. segmentDirection .. 
            " with rotation " .. segmentRotation.rotZ .. " degrees")
    end
    
    -- Place food (unchanged)
    local foodLocation = {
        posX = config.roomPosition.x + (gameState.food.x * 16),
        posY = config.roomPosition.y + (gameState.food.y * 16),
        posZ = config.roomPosition.z + 0.5,
        rotX = 0,
        rotY = 0,
        rotZ = 0
    }
    
    local foodObject = {
        refId = config.objects.food,
        count = 1,
        charge = -1,
        enchantmentCharge = -1,
        soul = ""
    }
    
    local foodIndex = logicHandler.CreateObjectAtLocation(cellDescription, 
                                                foodLocation, 
                                                foodObject, 
                                                "place")
    
    table.insert(SnakeGame.gameObjects[playerName], {
        uniqueIndex = foodIndex,
        cell = cellDescription,
        type = "food"
    })
    
    -- Apply visual effects to the head
    logicHandler.RunConsoleCommandOnObject(pid,
                                "PlaySound3DVP, \"corpDRAG\", 1.0, 1.0",
                                cellDescription,
                                headIndex,
                                false)
end

-- Handle game over
local function gameOver(pid, reason)
    local playerName = string.lower(Players[pid].accountName)
    local gameState = SnakeGame.activePlayers[playerName]
    
    if not gameState then return end
    
    gameState.gameOver = true
    
    -- Stop the timer
    if SnakeGame.timers[playerName] then
        tes3mp.StopTimer(SnakeGame.timers[playerName])
        SnakeGame.timers[playerName] = nil
    end
    
    -- Show game over message
    local message = reason .. "\nFinal Score: " .. gameState.score
    tes3mp.CustomMessageBox(pid, config.gameOverId, "Game Over\n" .. color.Red .. message,
                          color.Green .. "Play Again;" ..
                          color.Yellow .. "Quit")
    
    -- Play game over sound
    logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"conjuration fail\"", false)
end

-- Update game state
function UpdateGame(pid)
    local playerName = string.lower(Players[pid].accountName)
    local gameState = SnakeGame.activePlayers[playerName]
    
    if not gameState or gameState.gameOver then
        return
    end
    
    -- Log the update with coordinates
    local head = gameState.snake[1]
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Updating game for " .. playerName .. 
        " - Direction: " .. gameState.direction .. 
        ", Snake length: " .. #gameState.snake ..
        ", Head position: (" .. head.x .. "," .. head.y .. ")")
    
    -- Get the head position
    local newHead = {x = head.x, y = head.y}
    
    -- Move head in the current direction - FIXED COORDINATE SYSTEM
    -- Note: In TES3MP, +Y might point in a different direction than expected
    if gameState.direction == "up" or gameState.direction == "raise" then
        -- Assuming "up"/"raise" should decrease Y in this coordinate system
        newHead.y = newHead.y + 1  -- Changed from + to -
    elseif gameState.direction == "down" or gameState.direction == "lower" then
        -- Assuming "down"/"lower" should increase Y
        newHead.y = newHead.y - 1  -- Changed from - to +
    elseif gameState.direction == "left" then
        newHead.x = newHead.x - 1  -- Left should still decrease X
    elseif gameState.direction == "right" then
        newHead.x = newHead.x + 1  -- Right should still increase X
    end
    
    -- Log the new head position for debugging
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] New head position will be: (" .. newHead.x .. "," .. newHead.y .. ")")
    
    -- Check for wall collision
    if newHead.x < 0 or newHead.x >= config.roomSize or 
       newHead.y < 0 or newHead.y >= config.roomSize then
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Wall collision detected")
        gameOver(pid, "You hit a wall!")
        return
    end
    
    -- Check for self collision
    for i = 1, #gameState.snake do
        if newHead.x == gameState.snake[i].x and newHead.y == gameState.snake[i].y then
            tes3mp.LogMessage(enumerations.log.INFO, 
                "[SnakeGame] Self collision detected at segment " .. i .. 
                " (" .. gameState.snake[i].x .. "," .. gameState.snake[i].y .. ")")
            gameOver(pid, "You hit yourself!")
            return
        end
    end
    
    -- Insert new head at the beginning of the snake
    table.insert(gameState.snake, 1, newHead)
    
    -- Check for food collision
    if newHead.x == gameState.food.x and newHead.y == gameState.food.y then
        -- Grow the snake by not removing the tail
        gameState.score = gameState.score + 1
        
        -- Play sound effect
        logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"item gold up\"", false)
        
        -- Place new food
        placeFood(pid)
    else
        -- Remove the tail segment
        table.remove(gameState.snake)
    end
    
    -- Render updated game state
    renderGame(pid)
    
    -- Continue the game
    startGameTimer(pid)
end

-- Stop game and clean up resources
local function stopGame(pid)
    local playerName = string.lower(Players[pid].accountName)
    
    -- Stop timer
    if SnakeGame.timers[playerName] then
        tes3mp.StopTimer(SnakeGame.timers[playerName])
        SnakeGame.timers[playerName] = nil
    end
    
    -- Clear all game objects
    clearGameObjects(pid)
    
    -- Delete all game objects
    if SnakeGame.gameObjects[playerName] then
        for _, object in ipairs(SnakeGame.gameObjects[playerName]) do
            logicHandler.DeleteObject(pid, object.cell, object.uniqueIndex, true)
        end
        SnakeGame.gameObjects[playerName] = nil
    end
    
    -- Remove game state
    SnakeGame.activePlayers[playerName] = nil
    
    -- Enable player controls
    logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerControls", false)
    
    -- Return to third person view if preferred
    -- logicHandler.RunConsoleCommandOnPlayer(pid, "TogglePOV", false)
    
    tes3mp.MessageBox(pid, -1, "Snake Game ended.")
end

-- Update the changeDirection function to handle the new command names
local function changeDirection(pid, direction)
    local playerName = string.lower(Players[pid].accountName)
    local gameState = SnakeGame.activePlayers[playerName]
    
    if not gameState then
        tes3mp.LogMessage(enumerations.log.ERROR, "[SnakeGame] No game state found for: " .. playerName)
        return
    end
    
    if gameState.gameOver then
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Cannot change direction - game over for: " .. playerName)
        return
    end
    
    -- Store previous direction for debugging
    local prevDirection = gameState.direction
    
    -- Normalize the direction input
    local normalizedDirection = direction
    
    -- Map custom commands to standard directions
    if direction == "raise" then normalizedDirection = "up" end
    if direction == "lower" then normalizedDirection = "down" end
    
    tes3mp.LogMessage(enumerations.log.INFO, 
        "[SnakeGame] Direction input: '" .. direction .. 
        "' normalized to: '" .. normalizedDirection .. 
        "' current: '" .. prevDirection .. "'")
    
    -- Prevent 180-degree turns (can't go directly backwards)
    local invalidMove = false
    if (normalizedDirection == "up" and (prevDirection == "down" or prevDirection == "lower")) then
        invalidMove = true
    elseif (normalizedDirection == "down" and (prevDirection == "up" or prevDirection == "raise")) then
        invalidMove = true
    elseif (normalizedDirection == "left" and prevDirection == "right") then
        invalidMove = true
    elseif (normalizedDirection == "right" and prevDirection == "left") then
        invalidMove = true
    end
    
    if invalidMove then
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Invalid direction change: can't go from " .. 
            prevDirection .. " to " .. normalizedDirection)
        tes3mp.MessageBox(pid, -1, "Can't turn directly backwards!")
    else
        -- Valid move, update direction (store the normalized direction)
        gameState.direction = normalizedDirection
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Direction changed from " .. 
            prevDirection .. " to " .. normalizedDirection)
        
        -- Immediately notify the player of the change
        tes3mp.MessageBox(pid, -1, "Direction changed to: " .. direction)
    end
end

-- Initialize a new game state for a player
local function initGameState(pid)
    local playerName = string.lower(Players[pid].accountName)
    
    -- Clear any existing game state and objects
    if SnakeGame.activePlayers[playerName] then
        stopGame(pid)
    else
        clearGameObjects(pid) -- Add this to handle case where objects exist but no game state
    end
    
    -- Create new game state
    SnakeGame.activePlayers[playerName] = {
        snake = {}, -- Snake body segments positions
        food = {x = 0, y = 0},
        direction = "right", -- Starting direction
        score = 0,
        gameOver = false
    }
    
    -- Initialize snake at the center of the room
    local centerX = math.floor(config.roomSize / 2)
    local centerY = math.floor(config.roomSize / 2)
    
    for i = 1, config.initialSnakeLength do
        table.insert(SnakeGame.activePlayers[playerName].snake, {
            x = centerX - (i - 1), -- Start with a horizontal snake
            y = centerY
        })
    end
    
    -- Place initial food
    placeFood(pid)
    
    -- Initialize game objects table for this player
    SnakeGame.gameObjects[playerName] = {}
    
    -- Start game timer
    startGameTimer(pid)
    
    -- Build the game room
    buildGameRoom(pid)
    
    -- Render initial game state
    renderGame(pid)
    
    -- Message player
    tes3mp.MessageBox(pid, -1, "Snake Game Started! Use chat commands: " .. 
                              config.commands.up .. ", " .. 
                              config.commands.down .. ", " ..
                              config.commands.left .. ", " ..
                              config.commands.right .. " to control the snake.")
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

-- Improved command handler with debug logging
local function commandHandler(pid, cmd)
    local command = string.lower(cmd[1])
    local playerName = string.lower(Players[pid].accountName)
    
    -- Debug log
    tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Command received: " .. command .. " from player: " .. playerName)
    
    if command == config.commands.start then
        tes3mp.CustomMessageBox(pid, config.mainMenuId, "Snake Game", 
                              color.Green .. "Start Game;" ..
                              color.Red .. "Quit")
        return true
    elseif command == config.commands.stop then
        if SnakeGame.activePlayers[playerName] then
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Stopping game for: " .. playerName)
            stopGame(pid)
        else
            tes3mp.MessageBox(pid, -1, "No active game to stop.")
        end
        return true
    elseif command == config.commands.up or
           command == config.commands.down or
           command == config.commands.left or
           command == config.commands.right then
        
        if not SnakeGame.activePlayers[playerName] then
            tes3mp.MessageBox(pid, -1, "You need to start a game first with /" .. config.commands.start)
            return true
        end
        
        -- Immediately notify the player of direction change for feedback
        tes3mp.MessageBox(pid, -1, "Direction changed to: " .. command)
        
        -- Change direction with debug logging
        local previousDirection = SnakeGame.activePlayers[playerName].direction
        changeDirection(pid, command)
        
        tes3mp.LogMessage(enumerations.log.INFO, 
            "[SnakeGame] Direction change for " .. playerName ..
            ": " .. previousDirection .. " -> " .. SnakeGame.activePlayers[playerName].direction)
        
        return true
    end
    
    return false -- Let other handlers process if not our command
end

-- Register event handlers
customEventHooks.registerHandler("OnGUIAction", onGUIAction)

--commands
customCommandHooks.registerCommand(config.commands.start, commandHandler)
customCommandHooks.registerCommand(config.commands.stop, commandHandler)
customCommandHooks.registerCommand(config.commands.up, commandHandler)
customCommandHooks.registerCommand(config.commands.down, commandHandler)
customCommandHooks.registerCommand(config.commands.left, commandHandler)
customCommandHooks.registerCommand(config.commands.right, commandHandler)

-- Clean up on player disconnect
customEventHooks.registerHandler("OnPlayerDisconnect", function(eventStatus, pid)
    stopGame(pid)
end)

-- Clean up on server exit
customEventHooks.registerHandler("OnServerExit", function(eventStatus)
    for _, pid in pairs(Players) do
        if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
            stopGame(pid)
        end
    end
end)

-- Return the public interface
return SnakeGame
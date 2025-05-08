-- Snake Game for TES3MP
-- Main module

-- Load all the components
SnakeGame = {}
SnakeGame.cfg = require("custom.snake.config")
SnakeGame.helpers = require("custom.snake.helpers")
SnakeGame.gamestate = require("custom.snake.gamestate")
SnakeGame.gameLogic = require("custom.snake.gamelogic")
SnakeGame.handlersAndValidators = require("custom.snake.handlersAndValidators")
SnakeGame.serverPostInit = require("custom.snake.serverPostInit")
SnakeGame.leaderboard = require("custom.snake.leaderboard")

SnakeGame.logging_enabled = false

-- Update game logic
function UpdateGame(pid)
    local playerName = string.lower(Players[pid].accountName)
    local gameState = SnakeGame.gamestate.SnakeGame.activePlayers[playerName]
    local cellDescription = SnakeGame.cfg.roomCell

    if not gameState or gameState.gameOver then
        tes3mp.LogMessage(enumerations.log.ERROR, "[SnakeGame] No game state or game over for " .. playerName)
        return
    end

    local head = gameState.snake[1]
    if SnakeGame.logging_enabled then
        tes3mp.LogMessage(enumerations.log.INFO,
            "[SnakeGame] Updating game for " .. playerName ..
            " - Direction: " .. gameState.direction ..
            ", Snake length: " .. #gameState.snake ..
            ", Head position: (" .. head.x .. "," .. head.y .. ")")
    end

    -- Calculate new head position
    local newHead = { x = head.x, y = head.y }
    if gameState.direction == "up" or gameState.direction == "raise" then
        newHead.y = newHead.y + 1
    elseif gameState.direction == "down" or gameState.direction == "lower" then
        newHead.y = newHead.y - 1
    elseif gameState.direction == "left" then
        newHead.x = newHead.x - 1
    elseif gameState.direction == "right" then
        newHead.x = newHead.x + 1
    end

    if SnakeGame.logging_enabled then
        tes3mp.LogMessage(enumerations.log.INFO,
            "[SnakeGame] New head position: (" .. newHead.x .. "," .. newHead.y .. ")")
    end

    -- Check wall collisions
    if newHead.x < 0 or newHead.x >= SnakeGame.cfg.roomSize or
        newHead.y < 0 or newHead.y >= SnakeGame.cfg.roomSize then
        tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Wall collision detected")
        SnakeGame.gameLogic.gameOver(pid, "You hit a wall!")
        return
    end

    -- Check self collisions
    for i = 2, #gameState.snake do
        if newHead.x == gameState.snake[i].x and newHead.y == gameState.snake[i].y then
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Self collision detected")
            SnakeGame.gameLogic.gameOver(pid, "You hit yourself!")
            return
        end
    end

    -- Check if we're eating food
    local ateFood = (SnakeGame.cfg.foodCollision and newHead.x == gameState.food.x and newHead.y == gameState.food.y) or
        (SnakeGame.cfg.initFood and not gameState.foodIndex)

    -- Move snake head to new position
    local headRotation = SnakeGame.cfg.headRotations[gameState.direction]
    local headLocation = {
        posX = SnakeGame.cfg.roomPosition.x + (newHead.x * 16),
        posY = SnakeGame.cfg.roomPosition.y + (newHead.y * 16),
        posZ = SnakeGame.cfg.roomPosition.z + 9.5,
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

        SnakeGame.helpers.ResendPlace(pid, gameState.headIndex, cellDescription, true)

        if SnakeGame.logging_enabled then
            tes3mp.LogMessage(enumerations.log.INFO,
                "[SnakeGame] Moved head to (" .. newHead.x .. "," .. newHead.y .. ")")
        end
    else
        tes3mp.LogMessage(enumerations.log.ERROR,
            "[SnakeGame] Head object not found, cannot update game")
        return
    end

    -- Find an unused body segment from the pre-created ones
    local bodySegmentIndex = nil

    -- Look for the next available body segment
    for i, bodyObj in ipairs(SnakeGame.gamestate.SnakeGame.preCreatedObjects.body) do
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
        posX = SnakeGame.cfg.roomPosition.x + (head.x * 16),
        posY = SnakeGame.cfg.roomPosition.y + (head.y * 16),
        posZ = SnakeGame.cfg.roomPosition.z + 9.3,
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

        SnakeGame.helpers.ResendPlace(pid, bodySegmentIndex, cellDescription, true)

        -- Add this segment to the tracked objects
        table.insert(SnakeGame.gamestate.SnakeGame.gameObjects[playerName], {
            uniqueIndex = bodySegmentIndex,
            cell = cellDescription,
            type = "body"
        })

        if SnakeGame.logging_enabled then
            tes3mp.LogMessage(enumerations.log.INFO,
                "[SnakeGame] Placed body segment at old head position (" .. head.x .. "," .. head.y .. ")")
        end
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
        gameState.segmentIndices[i] = gameState.segmentIndices[i - 1]
    end
    gameState.segmentIndices[2] = bodySegmentIndex

    -- Handle food
    if ateFood then
        -- Keep the tail - we're growing
        if SnakeGame.logging_enabled then
            tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Ate food - growing snake")
        end
        gameState.score = gameState.score + 1

        -- Play the basic food eating sound
        logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound " .. SnakeGame.cfg.eatFoodSound, false)

        -- play voiceline
        if gameState.foodRefId and SnakeGame.cfg.foodVoiceLines[gameState.foodRefId] then
            local voiceLines = SnakeGame.cfg.foodVoiceLines[gameState.foodRefId]
            local randomLine = voiceLines[math.random(1, #voiceLines)]
            if SnakeGame.logging_enabled then
                tes3mp.LogMessage(enumerations.log.INFO,
                    "[SnakeGame] Playing voice line: " .. randomLine .. " for food: " .. gameState.foodRefId)
            end
            tes3mp.PlaySpeech(pid, randomLine)
        end

        -- Move the eaten food back to staging area
        if gameState.foodIndex then
            local foodObj = nil
            for _, obj in ipairs(SnakeGame.gamestate.SnakeGame.gameObjects[playerName]) do
                if obj.uniqueIndex == gameState.foodIndex then
                    foodObj = obj
                    break
                end
            end

            if foodObj then
                -- Move food to staging area
                local stagingLocation = SnakeGame.cfg.stagingLocation

                if LoadedCells[foodObj.cell].data.objectData[foodObj.uniqueIndex] then
                    LoadedCells[foodObj.cell].data.objectData[foodObj.uniqueIndex].location = {
                        posX = stagingLocation.x,
                        posY = stagingLocation.y,
                        posZ = stagingLocation.z,
                        rotX = 0,
                        rotY = 0,
                        rotZ = 0
                    }

                    SnakeGame.helpers.ResendPlace(pid, foodObj.uniqueIndex, foodObj.cell, true)

                    -- Remove it from tracked objects
                    for i, obj in ipairs(SnakeGame.gamestate.SnakeGame.gameObjects[playerName]) do
                        if obj.uniqueIndex == foodObj.uniqueIndex then
                            table.remove(SnakeGame.gamestate.SnakeGame.gameObjects[playerName], i)
                            break
                        end
                    end

                    if SnakeGame.logging_enabled then
                        tes3mp.LogMessage(enumerations.log.INFO,
                            "[SnakeGame] Moved food back to staging area")
                    end
                end
            end
        end

        -- Place new food
        SnakeGame.gameLogic.placeFood(pid)

        -- Randomly select one of the food items
        local randomFoodIndex = math.random(1, #SnakeGame.cfg.objects.food)
        local selectedFood = SnakeGame.cfg.objects.food[randomFoodIndex]

        -- Find the matching pre-created food object
        local preCreatedFoodObject = nil
        for _, foodObj in ipairs(SnakeGame.gamestate.SnakeGame.preCreatedObjects.food) do
            if foodObj.refId == selectedFood then
                preCreatedFoodObject = foodObj
                break
            end
        end

        if preCreatedFoodObject then
            local foodLocation = {
                posX = SnakeGame.cfg.roomPosition.x + (gameState.food.x * 16),
                posY = SnakeGame.cfg.roomPosition.y + (gameState.food.y * 16),
                posZ = SnakeGame.cfg.roomPosition.z + 0.5,
                rotX = 0,
                rotY = 0,
                rotZ = 9
            }

            -- Special height adjustment for rotating_skooma
            if selectedFood == SnakeGame.cfg.objects.food[1] then
                foodLocation.posZ = foodLocation.posZ + SnakeGame.cfg.rotating_skooma_height_offset
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

                SnakeGame.helpers.ResendPlace(pid, uniqueIndex, cellDescription, true)
                gameState.foodIndex = uniqueIndex
                gameState.foodRefId = selectedFood

                -- Track this dynamic object
                table.insert(SnakeGame.gamestate.SnakeGame.gameObjects[playerName], {
                    uniqueIndex = uniqueIndex,
                    cell = cellDescription,
                    type = "food"
                })

                if SnakeGame.logging_enabled then
                    tes3mp.LogMessage(enumerations.log.INFO,
                        "[SnakeGame] Placed new food (" ..
                        selectedFood .. ") at (" .. gameState.food.x .. "," .. gameState.food.y .. ")")
                end
            else
                tes3mp.LogMessage(enumerations.log.ERROR,
                    "[SnakeGame] Pre-created food object not found in cell")
            end
        end
    else
        -- Not growing, so move the tail segment back to staging area
        local tail = gameState.snake[#gameState.snake]
        local tailIndex = gameState.segmentIndices[#gameState.snake]

        if SnakeGame.logging_enabled then
            tes3mp.LogMessage(enumerations.log.INFO,
                "[SnakeGame] Removing tail at position (" ..
                tail.x .. "," .. tail.y .. ") with index " .. tostring(tailIndex))
        end

        if tailIndex then
            -- Move body segment to staging area
            local stagingLocation = SnakeGame.cfg.stagingLocation

            if LoadedCells[cellDescription].data.objectData[tailIndex] then
                LoadedCells[cellDescription].data.objectData[tailIndex].location = {
                    posX = stagingLocation.x,
                    posY = stagingLocation.y,
                    posZ = stagingLocation.z,
                    rotX = 0,
                    rotY = 0,
                    rotZ = 0
                }

                SnakeGame.helpers.ResendPlace(pid, tailIndex, cellDescription, true)

                -- Mark this body segment as no longer used
                gameState.usedBodyIndices[tailIndex] = nil

                -- Remove it from tracked objects
                for i, obj in ipairs(SnakeGame.gamestate.SnakeGame.gameObjects[playerName]) do
                    if obj.uniqueIndex == tailIndex then
                        table.remove(SnakeGame.gamestate.SnakeGame.gameObjects[playerName], i)
                        break
                    end
                end

                if SnakeGame.logging_enabled then
                    tes3mp.LogMessage(enumerations.log.INFO,
                        "[SnakeGame] Moved tail back to staging area")
                end
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

    -- Apply move sound
    table.insert(Players[pid].consoleCommandsQueued, "PlaySound3DVP, \"" .. SnakeGame.cfg.moveSound .. "\", 1.0, 1.0")
    tes3mp.ClearObjectList()
    tes3mp.SetObjectListPid(pid)
    tes3mp.SetObjectListCell(cellDescription)
    tes3mp.SetObjectListConsoleCommand("PlaySound3DVP, \"" .. SnakeGame.cfg.moveSound .. "\", 1.0, 1.0")
    local splitIndex = gameState.headIndex:split("-")
    tes3mp.SetObjectRefNum(splitIndex[1])
    tes3mp.SetObjectMpNum(splitIndex[2])
    tes3mp.AddObject()
    tes3mp.SendConsoleCommand(true, false)

    -- logicHandler.RunConsoleCommandOnObject(pid,
    --     "PlaySound3DVP, \"" .. SnakeGame.cfg.moveSound .. "\", 1.0, 1.0",
    --     cellDescription,
    --     gameState.headIndex,
    --     false)

    if SnakeGame.logging_enabled then
        tes3mp.LogMessage(enumerations.log.INFO,
            "[SnakeGame] Final snake state: length=" .. #gameState.snake ..
            ", head=(" .. newHead.x .. "," .. newHead.y .. ")")
    end

    SnakeGame.gameLogic.startGameTimer(pid)
end

-- Register event handlers
customEventHooks.registerHandler("OnPlayerDisconnect", SnakeGame.handlersAndValidators.OnPlayerDisconnectHandler)
customEventHooks.registerHandler("OnGUIAction", SnakeGame.handlersAndValidators.onGUIAction)
customEventHooks.registerHandler("OnServerPostInit", SnakeGame.serverPostInit.OnServerPostInitHandler)
customEventHooks.registerHandler("OnObjectActivate", SnakeGame.handlersAndValidators.OnObjectActivateHandler)
customEventHooks.registerHandler("OnPlayerCellChange", SnakeGame.handlersAndValidators.OnPlayerCellChangeHandler)
customEventHooks.registerHandler("OnObjectDelete", SnakeGame.handlersAndValidators.OnObjectDeleteHandler)

--validators
customEventHooks.registerValidator("OnPlayerItemUse", SnakeGame.handlersAndValidators.OnPlayerItemUseValidator)
customEventHooks.registerValidator("OnPlayerInventory", SnakeGame.handlersAndValidators.OnPlayerInventoryValidator)

-- Register commands
customCommandHooks.registerCommand(SnakeGame.cfg.commands.start, SnakeGame.handlersAndValidators.commandHandler)
customCommandHooks.registerCommand(SnakeGame.cfg.commands.stop, SnakeGame.handlersAndValidators.commandHandler)
customCommandHooks.registerCommand(SnakeGame.cfg.commands.up, SnakeGame.handlersAndValidators.commandHandler)
customCommandHooks.registerCommand(SnakeGame.cfg.commands.down, SnakeGame.handlersAndValidators.commandHandler)
customCommandHooks.registerCommand(SnakeGame.cfg.commands.left, SnakeGame.handlersAndValidators.commandHandler)
customCommandHooks.registerCommand(SnakeGame.cfg.commands.right, SnakeGame.handlersAndValidators.commandHandler)

tes3mp.LogMessage(enumerations.log.INFO, "[SnakeGame] Module initialized")

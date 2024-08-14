local DEFAULT_KEYBIND = "X"

-- Do not edit below this line unless you know what you're doing.

local HandsUp = false
local function HandsUpThread()
    CreateThread(
        function()
            while HandsUp do
                DisablePlayerFiring(cache.playerId, true)
                Wait(0)
            end
        end
    )
end

local function AddedChecks()
    -- added checks in case something breaks or edge case, just to ensure everything is working as intended
    CreateThread(
        function()
            while HandsUp do
                if
                    LocalPlayer.state.dead or
                        not IsEntityPlayingAnim(cache.ped, "random@mugging3", "handsup_standing_base", 49) or
                        cache.vehicle
                 then
                    HandsUp = false
                    StopAnimTask(cache.ped, "random@mugging3", "handsup_standing_base", 2.0)
                end
                Wait(3000)
            end
        end
    )
end

local function isRestrained()
    -- your checks here for your framework

    --[[
        if LocalPlayer.state.cuffed then return true end
    --]]
    return false
end

local function RestrictUse()
    if cache.vehicle then
        return true
    end
    if LocalPlayer.state.dead then
        return true
    end
    if isRestrained() then
        return true
    end
    if IsPedSwimming(cache.ped) then
        return true
    end
    if IsPedShooting(cache.ped) then
        return true
    end
    if IsPedClimbing(cache.ped) then
        return true
    end
    if IsPedDiving(cache.ped) then
        return true
    end
    if IsPedFalling(cache.ped) then
        return true
    end
    if IsPedJumping(cache.ped) then
        return true
    end
    if IsPedJumpingOutOfVehicle(cache.ped) then
        return true
    end
    if IsPedInParachuteFreeFall(cache.ped) then
        return true
    end

    return false
end

RegisterCommand(
    "handsup",
    function()
        if not HandsUp then
            -- put hands up

            if RestrictUse() then
                --return lib.notify({ type = 'error', position = 'center-right', title = 'System', description = 'You cannot do this right now.', id = 'hands_up_error' })
                return
            end

            HandsUp = true
            HandsUpThread()
            AddedChecks()
            lib.requestAnimDict("random@mugging3", 3000)
            TaskPlayAnim(cache.ped, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
        else
            -- put hands down
            StopAnimTask(cache.ped, "random@mugging3", "handsup_standing_base", 2.0)
            Wait(500) -- added wait to ensure the animation is stopped before disabling the firing so ppl dont glitch shoot
            HandsUp = false
        end
    end,
    false
)

RegisterKeyMapping("handsup", "Hands Up", "keyboard", DEFAULT_KEYBIND)

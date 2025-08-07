-- WowSwingTimer Core functionality
WowSwingTimer = {}
WowSwingTimer.version = "1.0.0"

-- Default settings
local defaults = {
    enabled = true,
    showMainHand = true,
    showOffHand = true,
    framePosition = { x = 100, y = -100 },
    barWidth = 200,
    barHeight = 20,
    showText = true,
    backgroundColor = { r = 0, g = 0, b = 0, a = 0.5 },
    fillColor = { r = 1, g = 1, b = 0, a = 0.8 }
}

-- Variables for tracking swing timers
local mainHandSpeed = 0
local offHandSpeed = 0
local mainHandStart = 0
local offHandStart = 0
local playerGUID = nil

-- Event frame
local eventFrame = CreateFrame("Frame")

-- Initialize the addon
function WowSwingTimer:Initialize()
    -- Load saved variables or use defaults
    if not WowSwingTimerDB then
        WowSwingTimerDB = {}
    end
    
    -- Merge defaults with saved settings
    for key, value in pairs(defaults) do
        if WowSwingTimerDB[key] == nil then
            WowSwingTimerDB[key] = value
        end
    end
    
    -- Get player GUID
    playerGUID = UnitGUID("player")
    
    -- Update weapon speeds
    self:UpdateWeaponSpeeds()
    
    -- Create UI
    self:CreateUI()
    
    print("WoW Swing Timer loaded successfully!")
end

-- Update weapon attack speeds
function WowSwingTimer:UpdateWeaponSpeeds()
    local mainHandSpeed_temp, offHandSpeed_temp = UnitAttackSpeed("player")
    
    if mainHandSpeed_temp then
        mainHandSpeed = mainHandSpeed_temp
    end
    
    if offHandSpeed_temp then
        offHandSpeed = offHandSpeed_temp
    end
end

-- Start main hand swing timer
function WowSwingTimer:StartMainHandSwing()
    mainHandStart = GetTime()
    if WowSwingTimerDB.enabled and WowSwingTimerDB.showMainHand then
        self:UpdateMainHandBar()
    end
end

-- Start off hand swing timer
function WowSwingTimer:StartOffHandSwing()
    offHandStart = GetTime()
    if WowSwingTimerDB.enabled and WowSwingTimerDB.showOffHand then
        self:UpdateOffHandBar()
    end
end

-- Update main hand progress bar
function WowSwingTimer:UpdateMainHandBar()
    if not self.mainHandBar or not self.mainHandBar:IsVisible() then
        return
    end
    
    local elapsed = GetTime() - mainHandStart
    local progress = math.min(elapsed / mainHandSpeed, 1)
    
    self.mainHandBar:SetValue(progress * 100)
    
    if WowSwingTimerDB.showText then
        local remaining = math.max(mainHandSpeed - elapsed, 0)
        self.mainHandText:SetText(string.format("MH: %.1fs", remaining))
    end
    
    if progress < 1 then
        C_Timer.After(0.05, function() self:UpdateMainHandBar() end)
    end
end

-- Update off hand progress bar
function WowSwingTimer:UpdateOffHandBar()
    if not self.offHandBar or not self.offHandBar:IsVisible() then
        return
    end
    
    local elapsed = GetTime() - offHandStart
    local progress = math.min(elapsed / offHandSpeed, 1)
    
    self.offHandBar:SetValue(progress * 100)
    
    if WowSwingTimerDB.showText then
        local remaining = math.max(offHandSpeed - elapsed, 0)
        self.offHandText:SetText(string.format("OH: %.1fs", remaining))
    end
    
    if progress < 1 then
        C_Timer.After(0.05, function() self:UpdateOffHandBar() end)
    end
end

-- Event handling
local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "WowSwingTimer" then
            WowSwingTimer:Initialize()
        end
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
        
        -- Check if this is our player's swing
        if sourceGUID == playerGUID then
            if eventType == "SWING_DAMAGE" or eventType == "SWING_MISSED" then
                -- Determine if it was main hand or off hand
                -- This is a simplified approach - in reality, determining MH vs OH is more complex
                if GetTime() - mainHandStart >= mainHandSpeed - 0.1 then
                    WowSwingTimer:StartMainHandSwing()
                elseif offHandSpeed > 0 and GetTime() - offHandStart >= offHandSpeed - 0.1 then
                    WowSwingTimer:StartOffHandSwing()
                end
            end
        end
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        -- Update weapon speeds when equipment changes
        WowSwingTimer:UpdateWeaponSpeeds()
    end
end

-- Register events
eventFrame:SetScript("OnEvent", OnEvent)
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

-- Slash commands
SLASH_WOWSWINGTIMER1 = "/swingtimer"
SLASH_WOWSWINGTIMER2 = "/st"

SlashCmdList["WOWSWINGTIMER"] = function(msg)
    local command = string.lower(msg or "")
    
    if command == "toggle" then
        WowSwingTimerDB.enabled = not WowSwingTimerDB.enabled
        if WowSwingTimerDB.enabled then
            print("WoW Swing Timer: Enabled")
            WowSwingTimer:ShowUI()
        else
            print("WoW Swing Timer: Disabled")
            WowSwingTimer:HideUI()
        end
    elseif command == "reset" then
        WowSwingTimer:ResetPosition()
        print("WoW Swing Timer: Position reset")
    else
        print("WoW Swing Timer Commands:")
        print("/swingtimer toggle - Enable/disable the addon")
        print("/swingtimer reset - Reset frame position")
    end
end

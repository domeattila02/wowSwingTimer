-- WowSwingTimer UI functionality

-- Create the main UI frame
function WowSwingTimer:CreateUI()
    -- Main frame
    self.frame = CreateFrame("Frame", "WowSwingTimerFrame", UIParent)
    self.frame:SetSize(WowSwingTimerDB.barWidth, WowSwingTimerDB.barHeight * 2 + 10)
    self.frame:SetPoint("CENTER", UIParent, "CENTER", WowSwingTimerDB.framePosition.x, WowSwingTimerDB.framePosition.y)
    self.frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    self.frame:SetBackdropColor(0, 0, 0, 0.8)
    self.frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    
    -- Make frame movable
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:SetScript("OnDragStart", function(frame)
        frame:StartMoving()
    end)
    self.frame:SetScript("OnDragStop", function(frame)
        frame:StopMovingOrSizing()
        local point, relativeTo, relativePoint, x, y = frame:GetPoint()
        WowSwingTimerDB.framePosition.x = x
        WowSwingTimerDB.framePosition.y = y
    end)
    
    -- Main hand swing bar
    self.mainHandBar = CreateFrame("StatusBar", "WowSwingTimerMainHand", self.frame)
    self.mainHandBar:SetSize(WowSwingTimerDB.barWidth - 8, WowSwingTimerDB.barHeight)
    self.mainHandBar:SetPoint("TOP", self.frame, "TOP", 0, -6)
    self.mainHandBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.mainHandBar:SetMinMaxValues(0, 100)
    self.mainHandBar:SetValue(0)
    self.mainHandBar:SetStatusBarColor(
        WowSwingTimerDB.fillColor.r,
        WowSwingTimerDB.fillColor.g,
        WowSwingTimerDB.fillColor.b,
        WowSwingTimerDB.fillColor.a
    )
    
    -- Main hand background
    self.mainHandBG = self.mainHandBar:CreateTexture(nil, "BACKGROUND")
    self.mainHandBG:SetAllPoints(self.mainHandBar)
    self.mainHandBG:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.mainHandBG:SetVertexColor(
        WowSwingTimerDB.backgroundColor.r,
        WowSwingTimerDB.backgroundColor.g,
        WowSwingTimerDB.backgroundColor.b,
        WowSwingTimerDB.backgroundColor.a
    )
    
    -- Main hand text
    if WowSwingTimerDB.showText then
        self.mainHandText = self.mainHandBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        self.mainHandText:SetPoint("CENTER", self.mainHandBar, "CENTER")
        self.mainHandText:SetText("MH: Ready")
        self.mainHandText:SetTextColor(1, 1, 1, 1)
    end
    
    -- Off hand swing bar (only if dual wielding)
    if offHandSpeed > 0 then
        self.offHandBar = CreateFrame("StatusBar", "WowSwingTimerOffHand", self.frame)
        self.offHandBar:SetSize(WowSwingTimerDB.barWidth - 8, WowSwingTimerDB.barHeight)
        self.offHandBar:SetPoint("TOP", self.mainHandBar, "BOTTOM", 0, -2)
        self.offHandBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
        self.offHandBar:SetMinMaxValues(0, 100)
        self.offHandBar:SetValue(0)
        self.offHandBar:SetStatusBarColor(
            WowSwingTimerDB.fillColor.r * 0.8,
            WowSwingTimerDB.fillColor.g * 0.8,
            WowSwingTimerDB.fillColor.b + 0.2,
            WowSwingTimerDB.fillColor.a
        )
        
        -- Off hand background
        self.offHandBG = self.offHandBar:CreateTexture(nil, "BACKGROUND")
        self.offHandBG:SetAllPoints(self.offHandBar)
        self.offHandBG:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
        self.offHandBG:SetVertexColor(
            WowSwingTimerDB.backgroundColor.r,
            WowSwingTimerDB.backgroundColor.g,
            WowSwingTimerDB.backgroundColor.b,
            WowSwingTimerDB.backgroundColor.a
        )
        
        -- Off hand text
        if WowSwingTimerDB.showText then
            self.offHandText = self.offHandBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            self.offHandText:SetPoint("CENTER", self.offHandBar, "CENTER")
            self.offHandText:SetText("OH: Ready")
            self.offHandText:SetTextColor(1, 1, 1, 1)
        end
    end
    
    -- Show/hide based on settings
    if WowSwingTimerDB.enabled then
        self:ShowUI()
    else
        self:HideUI()
    end
end

-- Show the UI
function WowSwingTimer:ShowUI()
    if self.frame then
        self.frame:Show()
    end
end

-- Hide the UI
function WowSwingTimer:HideUI()
    if self.frame then
        self.frame:Hide()
    end
end

-- Reset frame position
function WowSwingTimer:ResetPosition()
    if self.frame then
        self.frame:ClearAllPoints()
        self.frame:SetPoint("CENTER", UIParent, "CENTER", 100, -100)
        WowSwingTimerDB.framePosition.x = 100
        WowSwingTimerDB.framePosition.y = -100
    end
end

-- Update UI when weapon changes
function WowSwingTimer:UpdateUI()
    if self.frame then
        self.frame:Hide()
        self.frame = nil
    end
    self:CreateUI()
end

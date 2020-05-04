Menu = {}

local logoSmall = Image:new(Graphics.loadImage("app0:assets/images/logo-small.png"))
local libraryIcon = Image:new(Graphics.loadImage("app0:assets/icons/library.png"))
local catalogsIcon = Image:new(Graphics.loadImage("app0:assets/icons/catalogs.png"))
local historyIcon = Image:new(Graphics.loadImage("app0:assets/icons/history.png"))
local downloadsIcon = Image:new(Graphics.loadImage("app0:assets/icons/downloads.png"))
local settingsIcon = Image:new(Graphics.loadImage("app0:assets/icons/settings.png"))
local importIcon = Image:new(Graphics.loadImage("app0:assets/icons/import.png"))
local updateIcon = Image:new(Graphics.loadImage("app0:assets/icons/update.png"))

---@param mode string
---Menu mode
local mode

---@param new_mode string | '"LIBRARY"' | '"CATALOGS"' | '"SETTINGS"' | '"DOWNLOAD"'
---Sets menu mode
function Menu.setMode(new_mode, break_lock)
    if mode == new_mode and not break_lock then return end
    Catalogs.setMode(new_mode)
    ActionBar.clear()
    if new_mode == "LIBRARY" then
        ActionBar.addAction(updateIcon, function()
            ParserManager.updateCounters()
            ActionBar.setIndex(0)
        end)
        ActionBar.addAction(importIcon, function()
            ActionBar.clear()
            Catalogs.setMode("IMPORT")
            ActionBar.setName(Language[Settings.Language].APP["IMPORT"])
        end)
    elseif new_mode == "CATALOGS" then
        ActionBar.addAction(updateIcon, function()
            Catalogs.updateParserList()
            ActionBar.setIndex(0)
        end)
    end
    ActionBar.setName(Language[Settings.Language].APP[new_mode])
    mode = new_mode
end

local next_mode = {
    ["LIBRARY"] = "CATALOGS",
    ["CATALOGS"] = "HISTORY",
    ["HISTORY"] = "DOWNLOAD",
    ["DOWNLOAD"] = "SETTINGS",
    ["SETTINGS"] = "SETTINGS"
}

local prev_mode = {
    ["LIBRARY"] = "LIBRARY",
    ["CATALOGS"] = "LIBRARY",
    ["HISTORY"] = "CATALOGS",
    ["DOWNLOAD"] = "HISTORY",
    ["SETTINGS"] = "DOWNLOAD"
}

function Menu.input(oldpad, pad, oldtouch, touch)
    if Details.getMode() == "END" then
        if Controls.check(pad, SCE_CTRL_RTRIGGER) and not Controls.check(oldpad, SCE_CTRL_RTRIGGER) then
            Menu.setMode(next_mode[mode])
        end
        if Controls.check(pad, SCE_CTRL_LTRIGGER) and not Controls.check(oldpad, SCE_CTRL_LTRIGGER) then
            Menu.setMode(prev_mode[mode])
        end
        if touch.x and not oldtouch.x and touch.x < 50 then
            if touch.y < 120 then
            elseif touch.y < 200 then
                Menu.setMode("LIBRARY")
            elseif touch.y < 280 then
                Menu.setMode("CATALOGS")
            elseif touch.y < 360 then
                Menu.setMode("HISTORY")
            elseif touch.y > 470 then
                Menu.setMode("SETTINGS")
            elseif touch.y > 390 then
                Menu.setMode("DOWNLOAD")
            end
        end
        Catalogs.input(oldpad, pad, oldtouch, touch)
        ActionBar.input(touch, oldtouch)
    else
        if Extra.getMode() == "END" then
            Details.input(oldpad, pad, oldtouch, touch)
        else
            Extra.input(oldpad, pad, oldtouch, touch)
        end
    end
end

function Menu.update()
    ActionBar.update()
    Catalogs.update()
    Extra.update()
    Details.update()
end

local button_a = {
    ["LIBRARY"] = 1,
    ["CATALOGS"] = 1,
    ["HISTORY"] = 1,
    ["DOWNLOAD"] = 1,
    ["SETTINGS"] = 1
}

local download_led = 0

function Menu.draw()
    for k, v in pairs(button_a) do
        if k == mode or k == "LIBRARY" and mode == "IMPORT" then
            button_a[k] = math.max(v - 0.1, 0)
        else
            button_a[k] = math.min(v + 0.1, 1)
        end
    end
    Screen.clear(Themes[Settings.Theme].COLOR_LEFT_BACK)
    if logoSmall then
        --Graphics.drawImage(0, 0, logoSmall.e)
    end
    Graphics.fillRect(50, 960, 0, 544, COLOR_BACK)
    if Details.getFade() ~= 1 then
        Catalogs.draw()
    end
    Details.draw()
    Graphics.fillRect(0, 50, 0, 544, Themes[Settings.Theme].COLOR_LEFT_BACK)
    Graphics.drawImage(9, 144, libraryIcon.e, COLOR_GRADIENT(COLOR_ROYAL_BLUE, COLOR_WHITE, button_a["LIBRARY"]))
    Graphics.drawImage(9, 224, catalogsIcon.e, COLOR_GRADIENT(COLOR_ROYAL_BLUE, COLOR_WHITE, button_a["CATALOGS"]))
    Graphics.drawImage(9, 304, historyIcon.e, COLOR_GRADIENT(COLOR_ROYAL_BLUE, COLOR_WHITE, button_a["HISTORY"]))
    Graphics.drawImage(9, 424, downloadsIcon.e, COLOR_GRADIENT(COLOR_ROYAL_BLUE, COLOR_WHITE, button_a["DOWNLOAD"]))
    Graphics.drawImage(9, 494, settingsIcon.e, COLOR_GRADIENT(COLOR_ROYAL_BLUE, COLOR_WHITE, button_a["SETTINGS"]))
    if ChapterSaver.is_download_running() then
        download_led = math.min(download_led + 0.1, 1)
    else
        download_led = math.max(download_led - 0.1, 0)
    end
    Graphics.fillCircle(38, 424, 6, Color.new(65, 105, 226, 255 * download_led - 160 * download_led * math.abs(math.sin(Timer.getTime(GlobalTimer) / 1000))))
    ActionBar.draw()
    Extra.draw()
end

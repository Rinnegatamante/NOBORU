local actions = {}
local index = 0
ActionBar = {}
local Name = ""
local y = 1
local old = {}

function ActionBar.setName(new_name)
    old[#old + 1] = {v = 0, name = Name}
    y = 1
    Name = new_name
end

function ActionBar.draw()
    Graphics.fillRect(0, 960, 0, 50, COLOR_BLACK)
    for _, v in ipairs(old) do
        Font.print(FONT30, 64, 5 - 24 * v.v, v.name, Color.new(255, 255, 255, 255 - 255 * v.v))
    end
    Font.print(FONT30, 64, 5 - 24 * y, Name, Color.new(255, 255, 255, 255 - 255 * y))
end

function ActionBar.update()
    local new_old = {}
    for _, v in ipairs(old) do
        v.v = math.min(v.v + 0.1, 1)
        if v.v ~= 1 then
            new_old[#new_old + 1] = v
        end
    end
    old = new_old
    y = math.max(y - 0.1, 0)
end

function ActionBar.clear()
    
end

function ClearActions()
    actions = {}
    index = 0
end

function AddAction(icon, action)
    actions[#actions + 1] = {
        icon = icon,
        f = action,
        a = 1
    }
end

function MakeAction(_index)
    if actions[_index] then
        index = _index
        if actions[index].f then
            actions[index].f()
        end
    end
end

function SetActionIndex(_index)
    if actions[_index] then
        index = _index
    end
end

function DrawActionsBar()
    for k, v in ipairs(actions) do
        if v.icon.e then
            Graphics.drawImage(960-56-80*(k - 1), 9, v.icon.e, COLOR_GRADIENT(COLOR_ROYAL_BLUE, COLOR_WHITE, v.a))
        end
    end
end

function InputActionsBar(touch, oldtouch)
    if oldtouch.x == nil and touch.x ~= nil and touch.y < 50 then
        for k, v in ipairs(actions) do
            if touch.x < 960 - 80 * (k - 1) and touch.x > 960 - 80 * k then
                if v.f and index ~= k then
                    v.f()
                end
                index = k
                break
            end
        end
    end
end

function UpdateActionsBar()
    for k, v in ipairs(actions) do
        if k == index then
            v.a = math.max(v.a - 0.1, 0)
        else
            v.a = math.min(v.a + 0.1, 1)
        end
    end
end

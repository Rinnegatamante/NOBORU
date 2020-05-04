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
    for k, v in ipairs(actions) do
        if v.icon.e then
            Graphics.drawImage(960-56-80*(k - 1), 9, v.icon.e, COLOR_GRADIENT(COLOR_ROYAL_BLUE, COLOR_WHITE, v.a))
        end
    end
end

function ActionBar.save()
    return {
        Name = Name,
        actions = actions,
        index = index
    }
end

function ActionBar.load(load_table)
    Name = load_table.Name
    actions = load_table.actions
    index = load_table.index
end

function ActionBar.update()
    for k, v in ipairs(actions) do
        if k == index then
            v.a = math.max(v.a - 0.1, 0)
        else
            v.a = math.min(v.a + 0.1, 1)
        end
    end
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

function ActionBar.input(touch, oldtouch)
    if oldtouch.x == nil and touch.x ~= nil and touch.y < 50 then
        for k, v in ipairs(actions) do
            if touch.x < 960 - 80 * (k - 1) and touch.x > 960 - 80 * k then
                if index ~= k then
                    index = k
                    if v.f then
                        v.f()
                    end
                end
                break
            end
        end
    end
end

function ActionBar.clear()
    actions = {}
    index = 0
end

function ActionBar.addAction(icon, action)
    actions[#actions + 1] = {
        icon = icon,
        f = action,
        a = 1
    }
end

function ActionBar.makeAction(_index)
    if actions[_index] then
        index = _index
        if actions[index].f then
            actions[index].f()
        end
    end
end

function ActionBar.setIndex(_index)
    if actions[_index] or _index == 0 then
        index = _index
    end
end

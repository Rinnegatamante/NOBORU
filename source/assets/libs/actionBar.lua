local actions = {}
local index = 0

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

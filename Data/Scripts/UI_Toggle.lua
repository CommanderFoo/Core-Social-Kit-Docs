local root = script.parent

local check = root:FindDescendantByName("Check")
local border = root:FindDescendantByName("Border")
local toggle_button = root:FindDescendantByName("Toggle Button")

local event = root:GetCustomProperty("event") or ""
local hovered_color = root:GetCustomProperty("hovered_color")
local unhovered_color = root:GetCustomProperty("unhovered_color")
local disabled_color = root:GetCustomProperty("disabled_color")
local border_color = root:GetCustomProperty("border_color")
local check_color = root:GetCustomProperty("check_color")
local disabled = root:GetCustomProperty("disabled")
local checked = root:GetCustomProperty("checked")

local toggled = checked

check:SetColor(check_color)
border:SetColor(border_color)
toggle_button:SetButtonColor(unhovered_color)

if(event and #event > 0) then
	event = event .. "_"
else
	event = "toggle_"
end

if(checked) then
	check.visibility = Visibility.FORCE_ON
end

if(disabled) then
	toggle_button:SetButtonColor(disabled_color)
end

toggle_button.hoveredEvent:Connect(function()
	if(disabled) then
		return
	end

	toggle_button:SetButtonColor(hovered_color)
end)

toggle_button.unhoveredEvent:Connect(function()
	if(disabled) then
		return
	end

	toggle_button:SetButtonColor(unhovered_color)
end)

toggle_button.clickedEvent:Connect(function()
	if(disabled) then
		return
	end

	if(check.visibility == Visibility.FORCE_ON) then
		check.visibility = Visibility.FORCE_OFF
		toggled = false
	else
		check.visibility = Visibility.FORCE_ON
		toggled = true
	end

	Events.Broadcast("on_" .. event .. "toggled", toggled)
end)

function disable_toggle(clear_check)
	disabled = true
	toggle_button:SetButtonColor(disabled_color)

	if(clear_check) then
		check.visibility = Visibility.FORCE_OFF
		toggled = false
	end
end

function enable_select()
	disabled = false
	toggle_button:SetButtonColor(unhovered_color)
end

Events.Connect("on_" .. event .. "disable", disable_toggle)
Events.Connect("on_" .. event .. "enable", enable_select)
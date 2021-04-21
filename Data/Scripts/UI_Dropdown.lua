local root = script.parent.parent

local options_panel = root:FindDescendantByName("Options Panel")
local options_container = root:FindDescendantByName("Options")
local selected = root:FindDescendantByName("Selected")
local arrow = root:FindDescendantByName("Arrow")
local selected_border = root:FindDescendantByName("Selected Border")
local options_border = root:FindDescendantByName("Options Border")
local options_background = root:FindDescendantByName("Options Background")

local event = root:GetCustomProperty("event") or ""
local hovered_color = root:GetCustomProperty("hovered_color")
local unhovered_color = root:GetCustomProperty("unhovered_color")
local disabled_color = root:GetCustomProperty("disabled_color")
local border_color = root:GetCustomProperty("border_color")
local arrow_color = root:GetCustomProperty("arrow_color")
local text_hovered_color = root:GetCustomProperty("text_hovered_color")
local text_unhovered_color = root:GetCustomProperty("text_unhovered_color")

local poke_options = script:GetCustomProperty("poke_options"):WaitForObject():GetChildren()
local poke_option = script:GetCustomProperty("poke_option")

for _, p in ipairs(poke_options) do
	local opt = World.SpawnAsset(poke_option, { parent = options_container })

	opt.text = p:GetCustomProperty("poke_text")
end

local local_player = Game.GetLocalPlayer()

local options = options_container:GetChildren()

local total_options = #options
local offset = 0
local selected_option = selected
local disabled = root:GetCustomProperty("disabled")

arrow:SetColor(arrow_color)

selected_border:SetColor(border_color)

selected:SetButtonColor(unhovered_color)
selected:SetFontColor(text_unhovered_color)

options_border:SetColor(border_color)
options_background:SetColor(unhovered_color)

options_container.parent = options_panel
options_container.x = 0
options_container.y = 0
options_panel.y = root.height
options_container.visibility = Visibility.INHERIT

if(event and #event > 0) then
	event = event .. "_"
else
	event = "dropdown_"
end

if(disabled) then
	selected:SetButtonColor(disabled_color)
end

selected.hoveredEvent:Connect(function()
	if(disabled) then
		return
	end

	selected:SetButtonColor(hovered_color)
	selected:SetFontColor(text_hovered_color)
end)

selected.unhoveredEvent:Connect(function()
	if(disabled) then
		return
	end

	selected:SetButtonColor(unhovered_color)
	selected:SetFontColor(text_unhovered_color)
end)

for i = 1, total_options do
	options[i].y = offset
	offset = offset + options[i].height
	options[i]:SetButtonColor(unhovered_color)
	options[i]:SetFontColor(text_unhovered_color)

	options[i].hoveredEvent:Connect(function()
		options[i]:SetButtonColor(hovered_color)
		options[i]:SetFontColor(text_hovered_color)
	end)

	options[i].unhoveredEvent:Connect(function()
		options[i]:SetButtonColor(unhovered_color)
		options[i]:SetFontColor(text_unhovered_color)
	end)

	options[i].clickedEvent:Connect(function()
		selected_option = options[i]
		selected.text = options[i].text
		close_select()

		Events.Broadcast("on_" .. event .. "selected", i, options[i], options[i]:GetCustomProperty("value"))
	end)
end

function close_select()
	options_panel.visibility = Visibility.FORCE_OFF
	arrow.rotationAngle = 180
end

selected.clickedEvent:Connect(function()
	options_panel.height = (50 * total_options) + 4

	if(options_panel.visibility == Visibility.FORCE_ON) then
		close_select()
	elseif(not disabled) then
		options_panel.visibility = Visibility.FORCE_ON
		arrow.rotationAngle = 0
	end

	Events.Broadcast("on_" .. event .. "focused")
end)

function disable_select(clear_selected)
	disabled = true
	selected:SetButtonColor(disabled_color)

	if(clear_selected) then
		selected_option = selected
		selected_option.text = ""
	end
end

function enable_select()
	disabled = false
	selected:SetButtonColor(unhovered_color)
end

local_player.bindingPressedEvent:Connect(close_select)

Events.Connect("on_" .. event .. "disable", disable_select)
Events.Connect("on_" .. event .. "enable", enable_select)
local Input = require(script:GetCustomProperty("Input_Bindings"))
local YOOTIL = require(script:GetCustomProperty("YOOTIL"))

local root = script.parent.parent
local key_press = root:GetCustomProperty("key_press")
local key_press_disable = root:GetCustomProperty("key_press_disable")
local cooldown = root:GetCustomProperty("cooldown")
local notification_y_offset = root:GetCustomProperty("notify_y_offset")
local border_color = root:GetCustomProperty("border_color")
local background_color = root:GetCustomProperty("background_color")
local text_color = root:GetCustomProperty("text_color")
local selected_color = root:GetCustomProperty("selected_color")
local unselected_color = root:GetCustomProperty("unselected_color")
local disabled_color = root:GetCustomProperty("disabled_color")

local wrapper = script:GetCustomProperty("wrapper"):WaitForObject()
local info_container = script:GetCustomProperty("info_container"):WaitForObject()
local player_info = script:GetCustomProperty("player_info")
local notice = script:GetCustomProperty("notice"):WaitForObject()
local poke_button = script:GetCustomProperty("poke_button"):WaitForObject()
local poke_button_background = script:GetCustomProperty("poke_button_background"):WaitForObject()
local pokes = script:GetCustomProperty("pokes"):WaitForObject()
local border = script:GetCustomProperty("Border"):WaitForObject()
local background = script:GetCustomProperty("Background"):WaitForObject()
local poke_notification = script:GetCustomProperty("poke_notification"):WaitForObject()
local poke_name = script:GetCustomProperty("poke_name"):WaitForObject()
local poke_text = script:GetCustomProperty("poke_text"):WaitForObject()

local notification_border = script:GetCustomProperty("notification_border"):WaitForObject()
local notification_background = script:GetCustomProperty("notification_background"):WaitForObject()
local notification_image = script:GetCustomProperty("notification_image"):WaitForObject()
local notification_line = script:GetCustomProperty("notification_line"):WaitForObject()

local local_player = Game.GetLocalPlayer()

local tween = nil
local open = false
local cursor_visible_state = UI.IsCursorVisible()
local cursor_interact_state = UI.CanCursorInteractWithUI()

local player_selected = nil

local poke_queue = YOOTIL.Utils.Queue:new()
local current_item = nil
local in_tween = nil
local out_tween = nil

local disabled = false

poke_notification.y = poke_notification.y + notification_y_offset

notice:SetColor(text_color)
border:SetColor(border_color)
background:SetColor(background_color)

notification_border:SetColor(border_color)
notification_background:SetColor(background_color)
notification_image:SetColor(text_color)
notification_line:SetColor(text_color)
poke_name:SetColor(text_color)
poke_text:SetColor(text_color)

local_player.bindingPressedEvent:Connect(function(p, binding)
	if(key_press == Input[binding]) then

		-- Check cursor state so we can return it after close.

		if(not open) then
			cursor_visible_state = UI.IsCursorVisible()
			cursor_interact_state = UI.CanCursorInteractWithUI()
		end

		if(tween ~= nil) then
			tween:stop()
			tween = nil		
		end
		
		if(open) then
			UI.SetCursorVisible(cursor_visible_state)
			UI.SetCanCursorInteractWithUI(cursor_interact_state)
			open = false

			tween = YOOTIL.Tween:new(.8, {v = wrapper.y}, {v = -(wrapper.height + 150)})
		else
			update()

			UI.SetCursorVisible(true)
			UI.SetCanCursorInteractWithUI(true)
			open = true

			tween = YOOTIL.Tween:new(.8, {v = -wrapper.height}, {v = 130})
		end

		tween:on_complete(function()
			tween = nil
		end)
	
		tween:set_easing("inOutBack")
	
		tween:on_change(function(changed)
			wrapper.y = changed.v
		end)
	elseif(key_press_disable == Input[binding]) then
		if(disabled) then
			disabled = false
		else
			disabled = true
		end
	end
end)

function clear_all()
	local childs = info_container:GetChildren()

	for i, c in pairs(childs) do
		c:Destroy()
	end

	player_selected = nil
	
	poke_button_background:SetColor(disabled_color)
	poke_button.isInteractable = false

	Events.Broadcast("on_poke_disable", true)
end

function update()
	clear_all()

	local players = Game.GetPlayers()

	if(#players > 1) then
		notice.visibility = Visibility.FORCE_OFF
		
		local spacing = 10
		local counter = 0
		local rows = 1
		local cols = 4
		local y_offset = spacing + 80
		local x_offset = spacing
		local width = 140
		local height = 140

		for i, p in ipairs(players) do
		--for i = 1, 16 do
			if(p.id ~= local_player.id) then
				local info = World.SpawnAsset(player_info, { parent = info_container })
				
				local avatar = info:GetCustomProperty("avatar"):WaitForObject()
				local button = info:GetCustomProperty("button"):WaitForObject()
				local player_name = info:GetCustomProperty("player_name"):WaitForObject()
				local border = info:GetCustomProperty("border"):WaitForObject()
				local background = info:GetCustomProperty("background"):WaitForObject()
				
				player_name:SetColor(text_color)
				border:SetColor(unselected_color)
				info:SetColor(unselected_color)

				player_name.text = YOOTIL.Utils.truncate(p.name, 12, "..")
				avatar:SetImage(p)

				button.clickedEvent:Connect(function(obj)
					if(player_selected ~= nil) then
						player_selected.info:SetColor(unselected_color)
						player_selected.border:SetColor(unselected_color)
					end

					local last_poke_index = 0

					if(player_selected ~= nil and player_selected.poke > 0) then
						last_poke_index = player_selected.poke
					end

					player_selected = {

						info = info,
						border = border,
						player = p,
						poke = last_poke_index

					}

					info:SetColor(selected_color)
					border:SetColor(selected_color)

					Events.Broadcast("on_poke_enable")
				end)

				if(counter % 4 == 0) then
					x_offset = spacing

					if(counter > 0) then
						y_offset = y_offset + height + spacing
						rows = rows + 1
					end
				elseif(i > 1) then
					x_offset = x_offset + width + spacing
				end

				counter = counter + 1
			
				info.x = x_offset
				info.y = y_offset
			end
		end
	
		--info_container.parent.width = ((width + spacing) * 4) + spacing

		local container_height = ((height + spacing) * rows) + spacing + 80

		info_container.height = container_height
		info_container.parent.height = container_height

		wrapper.height = container_height
	else
		notice.visibility = Visibility.FORCE_ON
	end
end

function Tick(dt)
	if(tween ~= nil) then
		tween:tween(dt)
	end

	if(poke_queue:length() > 0 and current_item == nil) then
		current_item = poke_queue:pop()
		in_tween = YOOTIL.Tween:new(1.2, {v = 560}, {v = 200})
		out_tween = YOOTIL.Tween:new(1.2, {v = 200}, {v = 560})
	end

	if(current_item ~= nil) then
		if(in_tween and in_tween:active()) then
			in_tween:on_start(function()
				poke_name.text = YOOTIL.Utils.truncate(current_item.poker_name, 13, "..")
				poke_text.text = current_item.poke
				poke_notification.visibility = Visibility.FORCE_ON
			end)

			in_tween:on_complete(function()
				in_tween = nil
			end)

			in_tween:on_change(function(changed)
				poke_notification.x = changed.v
			end)
			
			in_tween:set_easing("outElastic")
			out_tween:set_delay(0.2)
			in_tween:tween(dt)

		elseif(out_tween and out_tween:active()) then
			out_tween:on_complete(function()
				poke_notification.visibility = Visibility.FORCE_OFF
				current_item = nil
				out_tween = nil
			end)
			
			out_tween:on_change(function(changed)
				poke_notification.x = changed.v					
			end)
			
			out_tween:set_easing("inOutBack")
			out_tween:set_delay(3)
			out_tween:tween(dt)
		end
	end
end

function get_poke(index)
	for i = 1, #pokes:GetChildren() do
		if(index == i) then
			return pokes:GetChildren()[i].text
		end
	end

	return nil
end

poke_button.clickedEvent:Connect(function()
	if(player_selected ~= nil) then
		Events.BroadcastToServer("on_player_poked", player_selected.player.id, player_selected.poke)
	end

	poke_button_background:SetColor(disabled_color)
	poke_button.isInteractable = false

	Task.Spawn(function()
		poke_button_background:SetColor(Color.WHITE)
		poke_button.isInteractable = true	
	end, cooldown)
end)

Events.Connect("on_poke_selected", function(index)
	if(player_selected ~= nil) then
		player_selected.poke = index
		poke_button_background:SetColor(Color.WHITE)
		poke_button.isInteractable = true
	end
end)

Events.Connect("on_poked", function(poker_name, poke_index)
	if(disabled) then
		return
	end

	local the_poke = get_poke(poke_index)

	if(the_poke ~= nil) then
		poke_queue:push({
			
			poker_name = poker_name,
			poke = the_poke

		})
	end
end)
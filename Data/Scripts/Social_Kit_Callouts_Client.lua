local Input = require(script:GetCustomProperty("Input_Bindings"))
local YOOTIL = require(script:GetCustomProperty("YOOTIL"))

local root = script.parent.parent
local callout_duration = root:GetCustomProperty("callout_duration")
local callout_y_offset = root:GetCustomProperty("callout_y_offset")
local callout_x_offset = root:GetCustomProperty("callout_x_offset")
local view_own_callouts = root:GetCustomProperty("view_own_callouts")

local ui_container = script:GetCustomProperty("ui_container"):WaitForObject()
local locator_obj = script:GetCustomProperty("locator")
local bubble = script:GetCustomProperty("bubble")

local callouts = {}

local callout_childs = script:GetCustomProperty("callouts"):WaitForObject():GetChildren()

for i, c in ipairs(callout_childs) do
	callouts[c:GetCustomProperty("key_press")] = {

		key_press = c:GetCustomProperty("key_press"),
		text = c:GetCustomProperty("text"),
		width = c:GetCustomProperty("width"),
		height = c:GetCustomProperty("height"),
		border_color = c:GetCustomProperty("border_color"),
		background_color = c:GetCustomProperty("background_color"),
		text_color = c:GetCustomProperty("text_color"),
		align_text_center = c:GetCustomProperty("align_text_center"),
		text_height = c:GetCustomProperty("text_height"),
		text_size = c:GetCustomProperty("text_size")

	}
end

local players = {}

local local_player = Game.GetLocalPlayer()

Game.playerJoinedEvent:Connect(function(player)
	local locator = World.SpawnAsset(locator_obj)
		
	locator:AttachToPlayer(player, "Nameplate")
	locator:SetWorldScale(Vector3.New(.2, .2, .2))
	
	locator.visibility = Visibility.FORCE_OFF

	players[player.id] = {

		player = player,
		locator = locator,
		callout = nil,
		offset = 0

	}
end)

Game.playerLeftEvent:Connect(function(player)
	if(players[player.id]) then
		if(Object.IsValid(players[player.id].locator)) then
			players[player.id].locator:Destroy()
		end

		if(Object.IsValid(players[player.id].callout)) then
			players[player.id].callout:Destroy()
		end

		players[player.id].tween = nil
		players[player.id] = nil
	end
end)

local_player.bindingPressedEvent:Connect(function(p, binding)
	if(callouts[Input[binding]] ~= nil) then
		if(view_own_callouts) then
			create_callout(p.id, Input[binding])
		end

		Events.BroadcastToServer("on_callout", Input[binding])
	end
end)

function create_callout(player_id, input)
	if(players[player_id] and not players[player_id].tween) then
		players[player_id].callout = World.SpawnAsset(bubble, { parent = ui_container })

		local text_box = players[player_id].callout:FindDescendantByName("Text Box")
		local wrapper = players[player_id].callout
		local background = players[player_id].callout:FindDescendantByName("Main Background")
		
		local bubble_parent = players[player_id].callout:FindDescendantByName("Bubble Parent")
		local bubble_parent_background = bubble_parent:FindDescendantByName("Bubble Parent Background")

		local bubble_child = players[player_id].callout:FindDescendantByName("Bubble Child")
		local bubble_child_background = bubble_child:FindDescendantByName("Bubble Child Background")

		text_box.text = callouts[input].text
		text_box:SetColor(callouts[input].text_color)
		wrapper:SetColor(callouts[input].border_color)
		background:SetColor(callouts[input].background_color)
		
		bubble_parent:SetColor(callouts[input].border_color)
		bubble_parent_background:SetColor(callouts[input].background_color)
		
		bubble_child:SetColor(callouts[input].border_color)
		bubble_child_background:SetColor(callouts[input].background_color)

		local background_alpha = callouts[input].background_color.a
		local wrapper_alpha = callouts[input].border_color.a
		local text_color_alpha = callouts[input].background_color.a

		players[player_id].callout.width = callouts[input].width
		players[player_id].callout.height = callouts[input].height

		text_box.height = -callouts[input].text_height
		text_box.fontSize = callouts[input].text_size

		if(callouts[input].align_text_center) then
			text_box.justification = TextJustify.CENTER
		end

		local tween = YOOTIL.Tween:new(.6, {a = 1}, {a = 0})

		tween:set_delay(callout_duration)

		tween:on_change(function(changed)
			players[player_id].offset = players[player_id].offset + (changed.a * 5)

			local background_color = background:GetColor()
			local wrapper_color = wrapper:GetColor()
			local text_color = text_box:GetColor()
			local bubble_border_color = bubble_parent:GetColor()
			local bubble_background_color = bubble_parent_background:GetColor()

			background_color.a = math.max(0, changed.a - background_alpha)
			wrapper_color.a = changed.a
			text_color.a = changed.a
			bubble_border_color.a = math.max(0, changed.a - wrapper_alpha)
			bubble_background_color.a = math.max(0, changed.a - background_alpha)
			
			background:SetColor(background_color)
			wrapper:SetColor(wrapper_color)
			text_box:SetColor(text_color)

			bubble_parent:SetColor(background_color)
			bubble_parent_background:SetColor(wrapper_color)
			bubble_child:SetColor(background_color)
			bubble_child_background:SetColor(wrapper_color)
			
		end)

		tween:on_start(function()
			bubble_parent.visibility = Visibility.FORCE_OFF
			bubble_child.visibility = Visibility.FORCE_OFF
		end)

		tween:on_complete(function()
			if(Object.IsValid(players[player_id].callout)) then
				players[player_id].callout:Destroy()
			end

			players[player_id].offset = 0
			players[player_id].tween = nil
			players[player_id].show = false
		end)

		players[player_id].tween = tween
	end
end

function Tick(dt)
	for _, p in pairs(players) do
		local callout = p.callout

		if(p.tween ~= nil) then
			p.tween:tween(dt)
		end

		if(Object.IsValid(callout)) then
			local screen = UI.GetScreenSize()
			local screen_pos = UI.GetScreenPosition(p.locator:GetWorldPosition())

			if(screen_pos) then
				if(screen_pos.x > 0 and screen_pos.x < screen.x and screen_pos.y > 0 and screen_pos.y < screen.y) then
					local offset = 0

					if(p.player.id ~= local_player.id) then
						local dist = YOOTIL.Vector3.distance(p.locator:GetWorldPosition(), root:GetWorldPosition())

						offset = dist / 150
					end

					callout.x = (screen_pos.x - callout.width) + callout_x_offset
					callout.y = screen_pos.y - callout.height - offset - p.offset + callout_y_offset
					
					callout.visibility = Visibility.FORCE_ON
				else
					callout.visibility = Visibility.FORCE_OFF
				end
			else
				callout.visibility = Visibility.FORCE_OFF
			end
		elseif(p.tween ~= nil) then
			p.tween = nil
		end
	end
end

Events.Connect("on_player_callout", function(player_id, callout_binding)
	if(player_id ~= local_player.id) then
		create_callout(player_id, callout_binding)
	end
end)
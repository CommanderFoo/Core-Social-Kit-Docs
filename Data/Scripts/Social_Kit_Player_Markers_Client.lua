local Input = require(script:GetCustomProperty("Input_Bindings"))
local YOOTIL = require(script:GetCustomProperty("YOOTIL"))

local root = script.parent.parent

local key_press_mark = root:GetCustomProperty("key_press_mark")
local key_press_hide_all = root:GetCustomProperty("key_press_hide_all")
local player_marker = root:GetCustomProperty("marker")
local show_distance = root:GetCustomProperty("show_distance")
local marker_color = root:GetCustomProperty("marker_color")
local distance_color = root:GetCustomProperty("distance_color")
local random_color = root:GetCustomProperty("random_color")
local marker_y_offset = root:GetCustomProperty("marker_y_offset")
local marker_x_offset = root:GetCustomProperty("marker_x_offset")

local ui_container = script:GetCustomProperty("ui_container"):WaitForObject()

local players = {}

local local_player = Game.GetLocalPlayer()

local markers_shown = true

Game.playerJoinedEvent:Connect(function(player)
	players[player.id] = {

		player = player,
		marker = nil,
		marker_image = nil,
		marker_distance = nil,
		position = nil

	}
end)

Game.playerLeftEvent:Connect(function(player)
	if(players[player.id]) then
		if(Object.IsValid(players[player.id].marker)) then
			players[player.id].marker:Destroy()
		end

		players[player.id] = nil
	end
end)

local_player.bindingPressedEvent:Connect(function(p, binding)
	if(key_press_mark == Input[binding]) then
		create_player_marker(p.id)

		Events.BroadcastToServer("on_marker", players[p.id].position, players[p.id].color)
	elseif(key_press_hide_all == Input[binding]) then
		hide_show_markers()
	end
end)

function hide_show_markers()
	if(markers_shown) then
		markers_shown = false
	else
		markers_shown = true
	end

	for _, p in pairs(players) do
		if(markers_shown) then
			p.marker.visibility = Visibility.FORCE_ON
		else
			p.marker.visibility = Visibility.FORCE_OFF
		end
	end
end

function create_player_marker(player_id, pos, color)
	if(players[player_id]) then
		if(not Object.IsValid(players[player_id].marker)) then
			players[player_id].marker = World.SpawnAsset(player_marker, { parent = ui_container })

			players[player_id].marker_image = players[player_id].marker:FindDescendantByName("Marker Image")
			players[player_id].marker_distance = players[player_id].marker:FindDescendantByName("Marker Distance")

			if(pos == nil) then
				pos = players[player_id].player:GetWorldPosition()
			end

			players[player_id].position = pos

			local marker_image_color = marker_color
			local distance_text_color = distance_color

			if(random_color) then
				if(color == nil) then
					marker_image_color = Color.New(math.random(255) / 255, math.random(255) / 255, math.random(255) / 255, 1)
					distance_text_color = marker_image_color
				else
					marker_image_color = color
					distance_text_color = color
				end
			end

			players[player_id].color = marker_image_color
			players[player_id].marker_image:SetColor(marker_image_color)
			players[player_id].marker_distance:SetColor(distance_text_color)
		elseif(Object.IsValid(players[player_id].marker)) then
			players[player_id].marker:Destroy()
			players[player_id].position = nil
		end
	end
end

function Tick(dt)
	if(markers_shown) then
		for _, p in pairs(players) do
			if(Object.IsValid(p.marker) and p.position ~= nil) then
				local screen = UI.GetScreenSize()
				local screen_pos = UI.GetScreenPosition(p.position)

				if(screen_pos) then
					if(screen_pos.x > 0 and screen_pos.x < screen.x and screen_pos.y > 0 and screen_pos.y < screen.y) then
						if(show_distance) then
							local dist = YOOTIL.Vector3.distance(p.position, local_player:GetWorldPosition())

							p.marker_distance.text = string.format("%s m", YOOTIL.Utils.number_format(math.floor(dist / 100)))
						end

						p.marker.x = (screen_pos.x - p.marker.width) + marker_x_offset
						p.marker.y = (screen_pos.y - p.marker.height) + marker_y_offset
						
						p.marker.visibility = Visibility.FORCE_ON
					else
						p.marker.visibility = Visibility.FORCE_OFF
					end
				else
					p.marker.visibility = Visibility.FORCE_OFF
				end
			end
		end
	end
end

Events.Connect("on_player_marker", function(player_id, pos, color)
	if(player_id ~= local_player.id) then
		create_player_marker(player_id, pos, color)
	end
end)
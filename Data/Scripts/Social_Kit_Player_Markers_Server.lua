Events.ConnectForPlayer("on_marker", function(player, pos, color)
	Events.BroadcastToAllPlayers("on_player_marker", player.id, pos, color)
end)
Events.ConnectForPlayer("on_callout", function(player, callout_binding)
	Events.BroadcastToAllPlayers("on_player_callout", player.id, callout_binding)
end)
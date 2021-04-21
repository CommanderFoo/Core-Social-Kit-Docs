Events.ConnectForPlayer("on_player_poked", function(poker, pokey_id, poke_index)
	for _, p in pairs(Game.GetPlayers()) do
		if(p.id == pokey_id) then
			Events.BroadcastToPlayer(p, "on_poked", poker.name, poke_index)
			break
		end
	end
end)
--the physics library
physics = {}

--player movement
player.inertiax = 0
player.inertiay = 0

--left and right
function physics.player_mod_x(value)
	print(player.inertiax)
	if math.abs(player.inertiax+value) <= 0.1 then
		player.inertiax = player.inertiax + value
	end
end
--apply left and right
function physics.player_x_apply(dt)
	local oldposx,oldposy = player.playerx,player.playery
	player.playerx = player.playerx + player.inertiax
	
	collision(oldposx,oldposy)
	
end

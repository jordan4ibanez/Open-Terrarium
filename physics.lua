--the physics library
physics = {}

--player movement
player.inertiax = 0
player.inertiay = 0

--left and right
function physics.player_mod_x(value)
	--print(player.inertiax)
	if math.abs(player.inertiax+value) <= 0.1 then
		player.inertiax = player.inertiax + value
	end
end
--up and down
function physics.player_mod_y(value)
	--print(player.inertiay+value)
	print(player.on_block)
	if  player.on_block == true then
		print("jump")
		player.inertiay = player.inertiay + value
		player.on_block = false
	end
end
--apply left and right
function physics.player_x_apply(dt)
	local oldposx,oldposy = player.playerx,player.playery
	
	player.playery = player.playery + player.inertiay
	collisiony(oldposy)
	player.playerx = player.playerx + player.inertiax
	collisionx(oldposx)
	--print(player.inertiax)
	if math.abs(player.inertiax) <= 0.005 then
		player.inertiax = 0
	elseif player.inertiax < 0 then
		player.inertiax = player.inertiax + 0.005
	elseif player.inertiax > 0 then
		player.inertiax = player.inertiax - 0.005
	else
		player.inertiax = player.inertiax 
	end
	
end

function physics.gravity()
	if player.on_block == true then
		player.inertiay = 0
		--player.on_block = false
	else
		if player.inertiay < 1 then
			player.inertiay = player.inertiay  + 0.01
		end
	end

end

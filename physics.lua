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
	--print(player.on_block)
	player.inertiay = player.inertiay + value
	
	if  player.on_block == true then
		--print("jump")
		player.inertiay = player.inertiay + value
		player.on_block = false
	end
end
--apply left and right
function physics.player_x_apply(dt)
	--local oldposx,oldposy = player.playerx,player.playery
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	--DEBUG
	
	--
	--collision(player.playerx,player.playery)
	--
	
	player.playery = player.playery + player.inertiay
	player.playerx = player.playerx + player.inertiax
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	--collisionx(oldposx)
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
	if player_in_unloaded_chunk == false then
		if player.on_block == true then
			--fall damage
			--[[
			if lastheight and math.floor(((map_max-player.playery)+(chunky*map_max))) < lastheight - 5 then 
				--health = health - math.floor(player.inertiay*10)
				health = health - ((lastheight - 5) - math.floor(((map_max-player.playery)+(chunky*map_max))))
				oof:setPitch(love.math.random(65,100)/100)
				oof:stop()
				oof:play()
				if health <= 0 then
					print("died, deleting map")
					deaths = deaths + 1
					maplib.delete_map()
					health = 10
				end
			end
			]]--
			player.inertiay = 0
			lastheight = math.floor(((map_max-player.playery)+(chunky*map_max)))
			--print(lastheight)
			--player.on_block = false
		else
			if player.inertiay < 0.5 then
				player.inertiay = player.inertiay  + 0.01
			end
		end
	else
		--print("player in unloaded chunk")
		--player.inertiay = 0
		--player.inertiax = 0
	end

end

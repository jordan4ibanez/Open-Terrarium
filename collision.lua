--basic grid based collision detection

function collision(oldposx,oldposy)
	--stairs
	--if (player.playerx <= map_max and player.playerx > 1) and 
	--	(player.playery < map_max and player.playery > 1) and 
	--	loaded_chunks[0][0][player.playerx][player.playery]["block"] == 3 then
	--	player.playery = player.playery - 1
	if (player.playerx > map_max or player.playerx <= 0) or (player.playery > map_max or player.playery <= 0) or ore[loaded_chunks[0][0][player.playerx][player.playery]["block"]]["collide"] ~= false then
		--print("collide")
		player.playerx,player.playery = oldposx,oldposy
		--can't move
		oof:setPitch(love.math.random(65,100)/100)
		oof:stop()
		oof:play()
		--print("return true")
		return(true)
	end
	
end

--make the player fall when in air
gravtimer = 0

function gravity(dt)
	--don't apply gravity if at bottom
	--if player.playery == map_max then
	--	player.playery = player.playery + 1
	--	maplib.new_block()
	--	return
	--end
	gravtimer = gravtimer + dt
	--reverse gravity in water
	if player.playery ~= 1 and ore[loaded_chunks[0][0][player.playerx][player.playery]["block"]]["float"] == true then
		if gravtimer >= 0.2 then
			local oldposx,oldposy = player.playerx,player.playery
			
			player.playery = player.playery - 1
			
			collision(oldposx,oldposy)
			
			gravtimer = 0
		end
	elseif player.playery == 1 and ore[loaded_chunks[0][1][player.playerx][map_max]["block"]]["float"] == false then
		if gravtimer >= 0.2 then
			player.playery = player.playery - 1
			maplib.new_block()
		end
	--else apply normal gravity
	elseif player.playery ~= map_max and ore[loaded_chunks[0][0][player.playerx][player.playery+1]["block"]]["collide"] == false then
		
		if gravtimer >= 0.2 then
			local oldposx,oldposy = player.playerx,player.playery
			
			player.playery = player.playery + 1
			
			collision(oldposx,oldposy)
			
			gravtimer = 0
		end
	elseif player.playery == map_max and ore[loaded_chunks[0][-1][player.playerx][1]["block"]]["collide"] == false then
		--print("applying new chunk gravity")
		if gravtimer >= 0.2 then
			player.playery = player.playery + 1
			maplib.new_block()
		end
	else
		--print("failure")
		gravtimer = 0
	end

end

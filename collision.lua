--basic grid based collision detection

function collision(oldposx,oldposy)
	--stairs
	if (player.playerx <= mapwidth and player.playerx > 1) and 
		(player.playery < mapheight and player.playery > 1) and 
		tiles[player.playerx][player.playery]["block"] == 3 then
		player.playery = player.playery - 1
	elseif (player.playerx > mapwidth or player.playerx <= 0) or (player.playery > mapheight or player.playery <= 0) or tiles[player.playerx][player.playery]["block"] ~= 1 then
		player.playerx,player.playery = oldposx,oldposy
		--can't move
		oof:setPitch(love.math.random(65,100)/100)
		oof:stop()
		oof:play()
		return(true)
	end
	
end

--make the player fall when in air
gravtimer = 0

function gravity(dt)
	--don't apply gravity if at bottom
	if player.playery == mapheight then
		player.playery = player.playery + 1
		maplib.new_block()
		return
	end
	
	if tiles[player.playerx][player.playery+1]["block"] == 1 then
		gravtimer = gravtimer + dt
		if gravtimer >= 0.2 then
			local oldposx,oldposy = player.playerx,player.playery
			
			player.playery = player.playery + 1
			
			collision(oldposx,oldposy)
			
			gravtimer = 0
		end
	else
		gravtimer = 0
	end

end

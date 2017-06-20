--basic grid based collision detection

function collision(oldposx,oldposy)

	if (player.playerx > mapwidth or player.playerx <= 0) or (player.playery > mapheight or player.playery <= 0) or tiles[player.playerx][player.playery]["block"] ~= 0 then
		player.playerx,player.playery = oldposx,oldposy
	end
	
end

--make the player fall when in air
gravtimer = 0

function gravity(dt)
	if player.playery < mapheight and tiles[player.playerx][player.playery+1]["block"] == 0 then
		gravtimer = gravtimer + dt
		if gravtimer >= 0.35 then
			local oldposx,oldposy = player.playerx,player.playery
			
			player.playery = player.playery + 1
			
			collision(oldposx,oldposy)
			
			gravtimer = 0
		end
	else
		gravtimer = 0
	end

end

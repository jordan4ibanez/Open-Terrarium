--basic grid based collision detection

function collision(oldposx,oldposy)

	if (player.playerx > mapwidth or player.playerx <= 0) or (player.playery > mapheight or player.playery <= 0) or tiles[player.playerx][player.playery]["block"] ~= 0 then
		player.playerx,player.playery = oldposx,oldposy
	end
	
end

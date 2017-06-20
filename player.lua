--the player library
player = {}
player.playerx,player.playery = 1,1

--controls

function love.keypressed( key, scancode, isrepeat )
	local oldposx,oldposy = player.playerx,player.playery
	
	if key == "left" then
      player.playerx = player.playerx - 1
	end
	if key == "right" then
      player.playerx = player.playerx + 1
	end
	
	if key == "up" then
      player.playery = player.playery - 1
	end
	if key == "down" then
      player.playery = player.playery + 1
	end
	collision(oldposx,oldposy)
	--player.playerx,player.playery = oldposx,oldposy
end


function player.draw()
	love.graphics.setFont(font)
	love.graphics.setColor(255,0,0,255)
    love.graphics.print("8", player.playerx*scale, player.playery*scale)
end

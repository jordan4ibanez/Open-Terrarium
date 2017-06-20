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
	
	mine(key)
	
end


--mining
function mine(key)
	local x,y = 0,0
	if key == "a" then
		if player.playerx > 1 then
			x = -1
		end
	elseif key == "d" then
		if player.playerx < mapwidth then
			x = 1
		end
	elseif key == "w" then
		if player.playery > 1 then
			y = -1
		end
	elseif key == "s" then
		if player.playery < mapheight then
			y = 1
		end
	end
	
	--play sound and remove tile
	if tiles[player.playerx+x][player.playery+y]["block"] ~= 0 then
		minesound:setPitch(love.math.random(50,100)/100)
		minesound:stop()
		minesound:play()
		tiles[player.playerx+x][player.playery+y]["block"] = 0
	end

end

function player.draw()
	love.graphics.setFont(font)
	love.graphics.setColor(255,0,0,255)
    love.graphics.print("8", player.playerx*scale, player.playery*scale)
end

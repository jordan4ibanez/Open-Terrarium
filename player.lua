--the player library
player = {}
player.playerx,player.playery = 1,1

player.mining = true

--controls

function love.keypressed( key, scancode, isrepeat )

	--quit
	if key == "escape" then
		love.event.push('quit')
	end

	local oldposx,oldposy = player.playerx,player.playery
	
	if key == "a" then
      player.playerx = player.playerx - 1
	end
	if key == "d" then
      player.playerx = player.playerx + 1
	end
	
	if key == "w" then
      player.playery = player.playery - 1
	end
	if key == "s" then
      player.playery = player.playery + 1
	end
	collision(oldposx,oldposy)
	
	if key == "space" then
		player.mining = not player.mining
	end
	
	
	
end


--mining
function mine(key)
	--left mouse button (mine)
	local left = love.mouse.isDown(1)
	local right = love.mouse.isDown(2)

	if mx ~= -1 and my ~= -1 then
		--play sound and remove tile
		if left then
			if tiles[mx][my]["block"] ~= 0 then
				minesound:setPitch(love.math.random(50,100)/100)
				minesound:stop()
				minesound:play()
				tiles[mx][my]["block"] = 0
			end
		elseif right then
			if tiles[mx][my]["block"] == 0 and (mx ~= player.playerx or my ~= player.playery) then
				placesound:setPitch(love.math.random(50,100)/100)
				placesound:stop()
				placesound:play()
				tiles[mx][my]["block"] = 1
			end
		end
	end

    --[[
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
	--cancel if nothing
	if x == 0 and y == 0 then
		return
	end
	

	]]--
end

function player.draw()
	love.graphics.setFont(font)
	love.graphics.setColor(255,0,0,255)
    love.graphics.print("8", player.playerx*scale, player.playery*scale)
end

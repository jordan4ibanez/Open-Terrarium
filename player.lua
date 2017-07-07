--the player library
player = {}
player.playerx,player.playery = math.random(1,map_max),math.random(1,map_max)

offsetx,offsety = 0,0

player.mining = true

player.selected = 2

score = 0

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
		jump()
	end
	
	local collide = maplib.new_block()
	
	--debug
	if key == "f5" then
		chunkx,chunky = math.random(-1000,1000),math.random(0,3)
		maplib.createmap()
		--print("generate random block")
		
	--this creates a new map
	elseif key == "f4" then
		local depth = 0
		if love.filesystem.isDirectory("map") then
            for _, child in pairs(love.filesystem.getDirectoryItems("map")) do
                love.filesystem.remove("map/" .. child);
            end
        elseif love.filesystem.isFile(item) then
            love.filesystem.remove("map");
        end
        
		print("generating new map")
		chunkx,chunky = math.random(-1000,1000),math.random(0,3)
		maplib.createmap()
	end
	
	
	--footsteps
	
	--fix every button causing sound
	--fix every button causing sound
	
	if oldposx ~= player.playerx or oldposy ~= player.playery then
	if collide == true and collision(oldposx,oldposy) ~= true and oldposy < map_max and tiles[oldposx][oldposy+1]["block"] ~= 0 then
		stepsound:setPitch(love.math.random(50,100)/100)
		stepsound:stop()
		stepsound:play()
	end
	end
	
	if key == "1" then
		player.selected = 2
	elseif key == "2" then
		player.selected = 3
	end
		

end

--try to jump
function jump()
	if (player.playery < map_max and loaded_chunks[0][0][player.playerx][player.playery+1]["block"] ~= 1) then
		player.playery = player.playery - 1
	elseif player.playery == map_max and loaded_chunks[0][-1][player.playerx][1]["block"] ~= 1 then
		player.playery = player.playery - 1
	end

end

--mining and placing
function mine(key)
	--left mouse button (mine)
	local left = love.mouse.isDown(1)
	local right = love.mouse.isDown(2)

	if mx ~= -1 and my ~= -1 then
		--play sound and remove tile
		if left then
			--print(mx,my)
			if loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"] ~= 1 then
				minesound:setPitch(love.math.random(50,100)/100)
				minesound:stop()
				minesound:play()
				loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"] = 1
				player.mining = true
				love.filesystem.write( "/map/"..chunkx+selected_chunkx.."_"..chunky+selected_chunky..".txt", TSerial.pack(loaded_chunks[selected_chunkx][selected_chunky]))
				
				score = score + 1
			end
		elseif right then
			if loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"] == 1 and (mx ~= player.playerx or my ~= player.playery) then
				placesound:setPitch(love.math.random(50,100)/100)
				placesound:stop()
				placesound:play()
				loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"] = player.selected
				player.mining = false
				love.filesystem.write( "/map/"..chunkx+selected_chunkx.."_"..chunky+selected_chunky..".txt", TSerial.pack(loaded_chunks[selected_chunkx][selected_chunky]))
					score = score + 1
			end
		end
	end
end

function player.move_camera(dt)

	--x axis
	if love.keyboard.isDown("left") then
        offsetx = offsetx + 3
    elseif love.keyboard.isDown("right") then
		offsetx = offsetx - 3
    end
    
    --y axis
   	if love.keyboard.isDown("up") then
        offsety = offsety + 3
    elseif love.keyboard.isDown("down") then
		offsety = offsety - 3
    end
    
end



player_drawnx,player_drawny = 0,0

function player.draw()
	love.graphics.setFont(font)
	love.graphics.setColor(255,0,0,255)
	player_drawnx,player_drawny = ((scale*map_max)/2)+offsetx,((scale*map_max)/2)+offsety
    love.graphics.print("8", player_drawnx,player_drawny  )
end

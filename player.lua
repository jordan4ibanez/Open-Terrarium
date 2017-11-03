--the player library
player = {}
player.playerx,player.playery = math.random(1,map_max),math.random(1,map_max)

offsetx,offsety = 0,0

player.mining = true

player.selected = 2

score = 0

health = 10

deaths = 0

magnet_radius = 2

add_inventory_radius = 0.35

time_before_add = 2

radius_of_selection = 10

function move(dt)	
	--debug - stresstest
	--if love.keyboard.isDown("f5") then
	--	chunkx,chunky = math.random(-1000,1000),math.random(2,3)
	--	maplib.createmap()
		--print("generate random block")
	--end
	
	--local oldposx,oldposy = player.playerx,player.playery
	local oldposx,oldposy
	--if love.keyboard.isDown("a","d","w") then
		--print("gude")
		--oldposx,oldposy = player.playerx,player.playery
	--end
	
	if love.keyboard.isDown("w") then
		--jump()
		physics.player_mod_y(-0.15)
	end
	if love.keyboard.isDown("s") then
		physics.player_mod_y(0.01)
	end
	
	
	
	if love.keyboard.isDown("a") then
	  --player.playerx = player.playerx - 0.1
	  physics.player_mod_x(-0.01)
	end
	if love.keyboard.isDown("d") then
	  physics.player_mod_x(0.01)
	end
	
	if love.keyboard.isDown("=") and scale < 150 then
		scale = scale + 1
	elseif love.keyboard.isDown("-") and scale > 15 then --15
		scale = scale - 1
	end
	
end
--restore stuff
function player_restore()
	local file = love.filesystem.read("/map/player.txt")
	
	if file then
		local data =  TSerial.unpack(file)
		if  data then
			for i,t in pairs(data) do
				--print(i,t)
			end
			inventory = data[1]
			chunkx = data[2]
			chunky = data[3]
			player.playerx = data[4]
			player.playery = data[5]
		end
	end

end

function love.keypressed( key, scancode, isrepeat )

	globalkey = key

	--quit
	if key == "escape" then
		--maplib.save_chunks()
		--love.filesystem.write( "/map/player.txt", TSerial.pack({inventory,chunkx,chunky,player.playerx,player.playery}))
		
		--love.timer.sleep(3)
		
		--love.event.push('quit')
		pause = not pause
		if pause == false then
			--wonder_music:play()
		else
			--wonder_music:stop()
		end
	end
	--screenshot
	if key == "f1" then
		local screenshot = love.graphics.newScreenshot();
		screenshot:encode('png', os.time() .. '.png');
	end
	
	--debug
	if key == "f5" then
		maplib.save_chunks()
		chunkx,chunky = math.random(-1000,1000),1
		maplib.createmap()
		--print("generate random block")
		
	--this creates a new map
	elseif key == "f4" then
		--local depth = 0
		maplib.delete_map()
		
		
		
	--resets the offset
	elseif key == "f3" then
		offsetx, offsety = 0,0
		print("resetting offset")
	end
	
	if key == "f6" then
		debugger = not debugger
	end
	
	--if key == "n" then
	--	entity.create_entity("item",0.4,0.4,texture_table[2],chunkx,chunky,player.playerx,player.playery,0,0,nil,0)
	--end
	
	--throw stuff
	if key == "q" then
		throw_item()
	end
	
	--open inventory
	if key == "e" then
		crafting_open = not crafting_open
	end
	
	--open terminal
	if key == "`" or key == "/" then
		terminal = not terminal
	end
			

	--trick to get input as inventory change
	--greater than 1 to not select air
	if tonumber(key) and tonumber(key) > 0 and tonumber(key) <= table.getn(inventory) then
		inventory_selection = tonumber(key)
	end
	

end



--try to jump
function jump()
	--[[
	if player.playerx <= map_max and player.playerx >= 1 and (player.playery < map_max and loaded_chunks[0][0][player.playerx][player.playery+1]["block"] ~= 1) then
		player.playery = player.playery - 1
	elseif player.playerx <= map_max and player.playerx >= 1 and player.playery == map_max and loaded_chunks[0][-1][player.playerx][1]["block"] ~= 1 then
		player.playery = player.playery - 1
	end
	]]--
end

--mining and placing

function load_mining_textured()
	mining_texture = {}
	
	for i = 1,10 do
		mining_texture[i] = love.graphics.newImage("textures/mining_"..tostring(i)..".png")
	end

end

mine_process = 0

old_mine_process = 0

function mine(key,dt)
	if crafting_open == false then
		--left mouse button (mine)
		local left = love.mouse.isDown(1)
		local right = love.mouse.isDown(2)
		mx = math.floor(mx+0.5)
		my = math.floor(my+0.5)
		if mx ~= -1 and my ~= -1 and mx >= 1 and mx <= map_max and my >= 1 and my <= map_max then
			--print(mine_process)
			--play sound and remove tile
			if left then
				--print(mx,my)
				if loaded_chunks[selected_chunkx] and loaded_chunks[selected_chunkx][selected_chunky] and loaded_chunks[selected_chunkx][selected_chunky][mx] and loaded_chunks[selected_chunkx][selected_chunky][mx][my] then
					if loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"] ~= 1 and blocks[loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"]]["mineable"] ~= false then
						
						player.mining = true
						
						mine_process = mine_process + 0.1--0.5
						
						--[[
						
						NOTE: 
						change minesound to the sound that the block makes when dug
						
						]]--
						
						--mining
						if math.ceil(mine_process) > math.ceil(old_mine_process) then
							sound_play(minesound,70,80)	
						end
						
						old_mine_process = mine_process
						--breaking
						if mine_process >= 10 then
							mine_process = 0
							
							sound_play(minesound,90,100)
							
							particle.create_particle(type,5,0.1,0.1,nil,selected_chunkx,selected_chunky,mx+0.5,my+0.5,-350,350, -100,-140,loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"],3)
							
							--THIS
							--inventory_add(loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"])
							
							--print(math.random(10,50)/1000)
							local drop
							local amount = 1
							if blocks[loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"]]["drop"] then
								drop = blocks[loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"]]["drop"]
								if blocks[loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"]]["drop_amount"] then
									amount = blocks[loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"]]["drop_amount"]
								end
							else
								drop = loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"]
							end
							for ii = 1,amount do
								entity.create_entity("item",0.4,0.4,nil,selected_chunkx,selected_chunky,mx+0.5,my+0.5,math.random(-100,100)/1000,math.random(-100,-140)/1000,drop,time_before_add)
							end
							
							loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"] = 1
							
							--love.filesystem.write( "/map/"..chunkx+selected_chunkx.."_"..chunky+selected_chunky..".txt", TSerial.pack(loaded_chunks[selected_chunkx][selected_chunky]))
							
							score = score + 1
						end
					end
				end
			elseif right then
				mine_process = 0
				old_mine_process = 0
				if loaded_chunks[selected_chunkx] and loaded_chunks[selected_chunkx][selected_chunky] and loaded_chunks[selected_chunkx][selected_chunky][mx] and loaded_chunks[selected_chunkx][selected_chunky][mx][my] then
					if blocks[loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"]]["placeable"] == true or  loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"] == 1 then
						
						if inventory[inventory_selection]["id"] then
						
							--if inventory[inventory_selection]["tabler"] == "ore" then
							loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"] = inventory[inventory_selection]["id"]
							
							inventory_remove(inventory_selection,inventory[inventory_selection]["id"])
														
							--NOTE: Placeholder "placement" sound
							sound_play(minesound,20,30)
							
							score = score + 1
							player.mining = false
							--end
							
							--love.filesystem.write( "/map/"..chunkx+selected_chunkx.."_"..chunky+selected_chunky..".txt", TSerial.pack(loaded_chunks[selected_chunkx][selected_chunky]))
						end
					end
				end
			else 
				mine_process = 0
				old_mine_process = 0
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



function player.draw_health()
	love.graphics.setFont(font)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Health:", 4,screenheight-32)
	for i = 1,health do
		love.graphics.draw(heart,  (i-1)*16, screenheight-16,0, 1,1)
	end
end


--render player with animation

--load up the player's character textures
function load_player_textures()

	
	player_head_right = love.graphics.newImage("textures/player_head_right.png")
	player_head_left = love.graphics.newImage("textures/player_head_left.png")
	player_arm = love.graphics.newImage("textures/player_arm.png")
	player_body = love.graphics.newImage("textures/player_body.png")
	player_leg = love.graphics.newImage("textures/player_leg.png")
	
end

player_drawnx,player_drawny = 0,0

leg_animation = 0
leg_animation_up = true
old_leg_animation = 0

arm_animation = 0
arm_animation_up = true


mining_animation = 0
mining_animation_up = false



function player.draw()
	--love.graphics.setFont(font)
	--love.graphics.setColor(255,0,0,255)
	player_drawnx,player_drawny = screenwidth/2-(scale/32)+offsetx,screenheight/2-(scale/32)+offsety--((scale*map_max)/2)+offsetx,((scale*map_max)/2)+offsety
    --love.graphics.print("8", player_drawnx,player_drawny  )
    
    --[[
    NOTE, THE MULTIPLIER BY X AND Y IS HOW MANY PIXELS
    
    x is how many pixels, subtracting from drawn x is left, adding is to the right
    
    player_drawnx-((scale/32)*x)
    
    ]]--
    
    --leg animation
    if pause ~= true then
		if player.inertiax ~= 0 then
			if leg_animation_up == true then
				leg_animation = leg_animation + math.abs(player.inertiax)

				if leg_animation >= 1 then
					leg_animation_up = false
				end
			elseif leg_animation_up == false then
				leg_animation = leg_animation - math.abs(player.inertiax)

				if leg_animation <= -1 then
					leg_animation_up = true
				end
			end
		else --return animation to normal
			--return to 0 
			if leg_animation > -0.05 and leg_animation < 0.05 then
				leg_animation = 0
			end
		
			--push back
			if leg_animation > 0 then
				--print("animation down")
				leg_animation = leg_animation - 0.05
			elseif leg_animation < 0 then
				--print("animation up")
				leg_animation = leg_animation + 0.05
			end
		end
		
		if (leg_animation > -0.1 and leg_animation < 0.1) and not (old_leg_animation > -0.1 and old_leg_animation < 0.1) then
			sound_play(stepsound,80,100)
		end
		
		old_leg_animation = leg_animation
		
		--arm animation
		if player.inertiax ~= 0 then
			if arm_animation_up == true then
				arm_animation = arm_animation + math.abs(player.inertiax)

				if arm_animation >= 1 then
					arm_animation_up = false
				end
			elseif arm_animation_up == false then
				arm_animation = arm_animation - math.abs(player.inertiax)

				if arm_animation <= -1 then
					arm_animation_up = true
				end
			end
		else --return animation to normal
			--return to 0 
			if arm_animation > -0.05 and arm_animation < 0.05 then
				arm_animation = 0
			end
		
			--push back
			if arm_animation > 0 then
				--print("animation down")
				arm_animation = arm_animation - 0.05
			elseif leg_animation < 0 then
				--print("animation up")
				arm_animation = arm_animation + 0.05
			end
		end
		
		--mining animation
		--get to -1.5
		
		if mine_process ~= 0 then
			if mining_animation_up == true then
				mining_animation = mining_animation + 0.4

				if mining_animation >= -0.8 then
					mining_animation_up = false
				end
			elseif mining_animation_up == false then
				mining_animation = mining_animation - 0.4

				if mining_animation <= -2.2 then
					mining_animation_up = true
				end
			end
		else --return animation to normal
			--print("return to normal "..mining_animation)
			--return to 0 
			if mining_animation > -0.05 and mining_animation < 0.05 then
				mining_animation = 0
			end
		
			--push back
			if mining_animation > 0 then
				--print("animation down")
				mining_animation = mining_animation - 0.05
			elseif mining_animation < 0 then
				--print("animation up")
				mining_animation = mining_animation + 0.05
			end
		end
	end
		
	
	--left leg
	love.graphics.draw(player_leg,  player_drawnx, player_drawny+((scale/17.7)*2),leg_animation, scale/17.7, scale/17.7,2,0)
	
	--right leg
	love.graphics.draw(player_leg,  player_drawnx, player_drawny+((scale/17.7)*2),-leg_animation, scale/17.7, scale/17.7,2,0)
	
	
	
	--left arm
	love.graphics.draw(player_arm,  player_drawnx, player_drawny-((scale/17.7)*8),arm_animation, scale/17.7, scale/17.7,2,0)
	
	--body
	love.graphics.draw(player_body,  player_drawnx, player_drawny-((scale/17.7)*8),0, scale/17.7, scale/17.7,2,0)
	
	--mining animation
	if mine_process == 0 and mining_animation == 0 then
		--right arm
		love.graphics.draw(player_arm,  player_drawnx, player_drawny-((scale/17.7)*8),-arm_animation, scale/17.7, scale/17.7,2,0)
	else
		love.graphics.draw(player_arm,  player_drawnx, player_drawny-((scale/17.7)*8),mining_animation, scale/17.7, scale/17.7,2,0)
	end
	
	
	--2d vector
	local xor, yor = love.mouse.getPosition( )
	local vec = {x=player_drawnx-xor, y= player_drawny-((scale/17.7)*12)-yor}
	
	local yaw = math.atan(vec.y/vec.x)
	
	
	--head
	if player_drawnx > xor then
		love.graphics.draw(player_head_left,  player_drawnx, player_drawny-((scale/17.7)*12),yaw, scale/17.7, scale/17.7,4,4)
	else
		love.graphics.draw(player_head_right,  player_drawnx, player_drawny-((scale/17.7)*12),yaw, scale/17.7, scale/17.7,4,4)
	end
	
	
	
	
	--wielded item
	-- block loaded_chunks[selected_chunkx][selected_chunky][mx][my]["block"]
	-- render texture_table[inventory[i]["id"]]
	if inventory[inventory_selection]["id"] then
		--mining animation
		if mine_process == 0 and mining_animation == 0 then
			love.graphics.draw(texture_table[inventory[inventory_selection]["id"]],  player_drawnx, player_drawny-((scale/17.7)*8),-arm_animation, scale/45, scale/45,-5,-15)
		else
			love.graphics.draw(texture_table[inventory[inventory_selection]["id"]],  player_drawnx, player_drawny-((scale/17.7)*8),mining_animation, scale/45, scale/45,-5,-15)
		end
	end
	
	
	--THIS IS DEBUG INFO FOR THE COLLISION DETECTION
	
    --love.graphics.rectangle( "line", player_drawnx-(scale/5), player_drawny-(scale/1.1), 0.4*scale,1.71*scale )
    
	--love.graphics.circle( "fill", player_drawnx, player_drawny, 3 ) --center
end



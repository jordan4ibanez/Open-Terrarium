--the particles library


--hold the library
particle = {}

--store all the entities
particle_table = {}
particle_count = 0


--create entities
function particle.create_particle(type,amount,sizex,sizey,texture,chunkx,chunky,posx,posy,min_velx,max_velx,min_vely,max_vely,item,max_life)
	for i = 1,amount do
		particle_count = particle_count + 1
		particle_table[particle_count] = {}
		particle_table[particle_count]["sizex"] = sizex
		particle_table[particle_count]["sizey"] = sizey
		particle_table[particle_count]["chunkx"] = chunkx
		particle_table[particle_count]["chunky"] = chunky
		particle_table[particle_count]["posx"] = posx
		particle_table[particle_count]["posy"] = posy
		particle_table[particle_count]["inertiax"] = math.random(min_velx,max_velx)/1000
		particle_table[particle_count]["inertiay"] = math.random(min_vely,max_vely)/1000
		particle_table[particle_count]["on_block"] = false
		particle_table[particle_count]["particle_in_unloaded_chunk"] = false
		particle_table[particle_count]["item"] = item
		particle_table[particle_count]["timer"] = 0
		particle_table[particle_count]["max_life"] = max_life
		
		
		if item then
			particle_table[particle_count]["texture"] = texture_table[item]
		else
			particle_table[particle_count]["texture"] = texture
		end
	end
	
end

--draw entities
function particle.render_particle()
	if table.getn(particle_table) > 0 then
		--print(table.getn(particle_table))
		for i = 1,table.getn(particle_table) do
			--print(i,particle_table[i])
			if particle_table[i] then
				local drawx = (player_drawnx+(particle_table[i]["posx"]*scale)+(map_max*scale*(particle_table[i]["chunkx"]-chunkx))-(player.playerx*scale))-((particle_table[i]["sizex"]/2)*scale)
				local drawy = (player_drawny+(particle_table[i]["posy"]*scale)+(map_max*scale*(chunky-particle_table[i]["chunky"]))-(player.playery*scale))-((particle_table[i]["sizey"]/2)*scale)
				love.graphics.draw(particle_table[i]["texture"],  drawx,drawy,0, scale*particle_table[i]["sizex"]/21, scale*particle_table[i]["sizey"]/21)--,scale*(particle_table[i]["sizex"]),scale*(particle_table[i]["sizey"]))
				--love.graphics.circle( "fill", drawx+((particle_table[i]["sizex"]/2)*scale), drawy+((particle_table[i]["sizey"]/2)*scale), 3 )
			end
		end
	end
end


--particle gravity
function particle.gravity()
	if table.getn(particle_table) > 0 then
		for i = 1,table.getn(particle_table) do
			if particle_table[i] then
				--if particle_table[i]["magnetized"] == false then
					if particle_table[i]["particle_in_unloaded_chunk"] == false then
						--print(particle_table[i]["on_block"])
						if particle_table[i]["on_block"] == true then
							particle_table[i]["inertiay"] = 0
							--lastheight = math.floor(((map_max-player.playery)+(chunky*map_max)))
							--print(lastheight)
							--player.on_block = false
						else
							if particle_table[i]["inertiay"] < 0.3 then
								particle_table[i]["inertiay"] = particle_table[i]["inertiay"] + 0.01
								--print(particle_table[i]["inertiay"])
							end
						end
					else
						--print("particle "..i.." in unloaded chunk")
						particle_table[i]["inertiax"] = 0
						particle_table[i]["inertiay"] = 0
					end
				--end
			end
		end
	end
end

--applying the particle physics
function particle.physics_apply(dt)
	--local oldposx,oldposy = player.playerx,player.playery
	
	
	if table.getn(particle_table) > 0 then
		for i = 1,table.getn(particle_table) do


			if particle_table[i] then

				particle.collision(i,particle_table[i].posx,particle_table[i].posy)

				particle.new_chunk(i,particle_table[i].posx,particle_table[i].posy)
				
				

				--collisionx(oldposx)
				--print(particle_table[i].inertiax)
				if math.abs(particle_table[i].inertiax) <= 0.005 then
					particle_table[i].inertiax = 0
				elseif particle_table[i].inertiax < 0 then
					particle_table[i].inertiax = particle_table[i].inertiax + 0.005
				elseif particle_table[i].inertiax > 0 then
					particle_table[i].inertiax = particle_table[i].inertiax - 0.005
				else
					particle_table[i].inertiax = particle_table[i].inertiax 
				end
				
				
				particle_table[i]["timer"] = particle_table[i]["timer"] + dt
				
				if particle_table[i]["timer"] > particle_table[i]["max_life"] then
					table.remove(particle_table,i)
					particle_count = particle_count - 1
				end
				
			end
		end
	end
		
end



--
function particle.collision(i,oldposx,oldposy)

	particle_table[i]["particle_in_unloaded_chunk"] = false
	
	
	
	local xer = {-particle_table[i]["sizex"]/4,particle_table[i]["sizex"]/4}
	local yer = {-particle_table[i]["sizey"]/4,particle_table[i]["sizey"]/4}
	local fall = true
	
	--check the corners (y)
	particle_table[i]["posy"] = particle_table[i]["posy"] + particle_table[i]["inertiay"]
	for q = 1,2 do
		for r = 1,2 do
			local squarex = math.floor(particle_table[i]["posx"]+xer[q])
			local squarey = math.floor(particle_table[i]["posy"]+yer[r])
			
			--use this to detect outside chunk 00
			local chunkerx = 0
			local chunkery = 0
			
			if squarex < 1 then
				chunkerx = -1
				squarex = map_max
				--print("adjusting x -1")
			elseif squarex > map_max then
				chunkerx = 1
				squarex = 1
				--print("adjusting x +1")
			end
			if squarey < 1 then
				chunkery = 1
				squarey = map_max
				--print("adjusting y +1")
			elseif squarey > map_max then
				chunkery = -1
				squarey = 1
				--print("adjusting y -1")
			end
			--print(chunkerx, chunkery, "|", squarex,squarey)
			--print( loaded_chunks[chunkerx][chunkery][squarex][squarey]["block"])
			--if (squarex1 > map_max or squarex1 <= 0) or (squarey1 > map_max or squarey1 <= 0) or blocks[loaded_chunks[0][0][squarex1][squarey1]["block"]]["collide"] ~= false then
			local particle_chunkx = particle_table[i]["chunkx"]
			local particle_chunky = particle_table[i]["chunky"]
			
			
			if loaded_chunks[particle_chunkx+chunkerx] and loaded_chunks[particle_chunkx+chunkerx][chunkery+particle_chunky] and loaded_chunks[particle_chunkx+chunkerx][chunkery+particle_chunky][squarex] and loaded_chunks[particle_chunkx+chunkerx][chunkery+particle_chunky][squarex][squarey] then
				if blocks[loaded_chunks[particle_chunkx+chunkerx][chunkery+particle_chunky][squarex][squarey]["block"]]["collide"] ~= false then
				
					---print("PUTTING BACK TO OLD")
					particle_table[i]["posy"] = oldposy
					
					if r == 2 then
						particle_table[i]["on_block"] = true
						--print("IT'S ON THE BLOCK")
						fall = false
					end
					if r == 1 then
						particle_table[i]["on_block"] = false
					end
				end
			else
				particle_table[i]["particle_in_unloaded_chunk"] = true
			end
		end
	end
	if fall == true then
		particle_table[i]["on_block"] = false
	end
	
	
	--check the corners(x)
	particle_table[i]["posx"] = particle_table[i]["posx"] + particle_table[i]["inertiax"]
	for q = 1,2 do
		for r = 1,3 do
			local squarex = math.floor(particle_table[i]["posx"]+xer[q])
			
			local squarey
			
			if r < 3 then
				 squarey = math.floor(particle_table[i]["posy"]+yer[r])
				 
			else
				squarey = math.floor(particle_table[i]["posy"])
			end
				
			
			--print(squarex)
			--use this to detect outside chunk 00
			local chunkerx = 0
			local chunkery = 0
			
			if squarex < 1 then
				chunkerx = -1
				squarex = map_max
				--print("adjusting x -1")
			elseif squarex > map_max then
				chunkerx = 1
				squarex = 1
				--print("adjusting x +1")
			end
			if squarey < 1 then
				chunkery = 1
				squarey = map_max
				--print("adjusting y +1")
			elseif squarey > map_max then
				chunkery = -1
				squarey = 1
				--print("adjusting y -1")
			end
			local particle_chunkx = particle_table[i]["chunkx"]
			local particle_chunky = particle_table[i]["chunky"]
			
			
			--if (squarex1 > map_max or squarex1 <= 0) or (squarey1 > map_max or squarey1 <= 0) or blocks[loaded_chunks[0][0][squarex1][squarey1]["block"]]["collide"] ~= false then
			if loaded_chunks[particle_chunkx+chunkerx] and loaded_chunks[particle_chunkx+chunkerx][chunkery+particle_chunky] and loaded_chunks[particle_chunkx+chunkerx][chunkery+particle_chunky][squarex] and loaded_chunks[particle_chunkx+chunkerx][chunkery+particle_chunky][squarex][squarey] then
				if blocks[loaded_chunks[particle_chunkx+chunkerx][chunkery+particle_chunky][squarex][squarey]["block"]]["collide"] ~= false then
					particle_table[i]["inertiax"] = 0
					particle_table[i]["posx"] = oldposx
					--print("stopping x inertia and pos")
				end
			else
				particle_table[i]["particle_in_unloaded_chunk"] = true
			end
		end
	end
end


--move particle into new chunk
function particle.new_chunk(i,posx,posy)
	--print(math.floor(player.playerx))
	if math.floor(posx) < 1 then
	
			particle_table[i]["chunkx"] = particle_table[i]["chunkx"] - 1
			particle_table[i]["posx"]   = particle_table[i]["posx"] + map_max -- put particle on other side of screen		
			--print(" block x -1")
			return false
	elseif math.floor(posx) > map_max then

			particle_table[i]["chunkx"] = particle_table[i]["chunkx"] + 1
			particle_table[i]["posx"]   = particle_table[i]["posx"] - map_max -- put particle on other side of screen
			--print("block x +1")
			return false
	
	elseif math.floor(posy) < 1 then
			particle_table[i]["chunky"] = particle_table[i]["chunky"] + 1
			particle_table[i]["posy"]   = particle_table[i]["posy"] + map_max  -- put particle on other side of screen
			--print(" block y -1")
			return false
	elseif math.floor(posy) > map_max then
			particle_table[i]["chunky"] = particle_table[i]["chunky"] - 1
			particle_table[i]["posy"]   = particle_table[i]["posy"] - map_max -- put particle on other side of screen
			--print("block y +1")
			return false
	end
	
	return true
end


--magnetize items towards player
--taken from sfan5's nuke mod in Minetest - https://forum.minetest.net/viewtopic.php?id=638
--use this for magic
--[[
function particle.particle_magnet(i)
	local x = player.playerx - particle_table[i]["posx"]
	local y = player.playery - particle_table[i]["posy"]
	
	--adjust for chunk border
	if chunkx ~= particle_table[i]["chunkx"] then
		x = ((particle_table[i]["chunkx"]-chunkx)*map_max-x)*-1
	end
	if chunky ~= particle_table[i]["chunky"] then
		y = ((chunky-particle_table[i]["chunky"])*map_max-y)*-1
	end
	
	local calc1 = x*x+y*y --optimize
	
	particle_table[i]["magnetized"] = false
	
	--item magnet
	if particle_table[i]["timer"] > time_before_add and calc1 <= magnet_radius * magnet_radius + magnet_radius then
		local normalx,normaly,length = math.normalize(x,y)
		normalx,normaly = normalx*0.05,normaly*0.05
		particle_table[i]["inertiax"] = particle_table[i]["inertiax"] + normalx
		particle_table[i]["inertiay"] = particle_table[i]["inertiay"] + normaly
		particle_table[i]["magnetized"] = true
	end
	
	--inventory magnet add
	if particle_table[i]["timer"] > time_before_add and  calc1 <= add_inventory_radius * add_inventory_radius + add_inventory_radius then
		inventory_add(particle_table[i]["item"])
		--particle_table[i] = nil
		table.remove(particle_table,i)
		particle_count = particle_count - 1
		--print("add to inventory")
		item_magnet_pickup:setPitch(love.math.random(80,120)/100)
		item_magnet_pickup:stop()
		item_magnet_pickup:play()
	end
end
]]--

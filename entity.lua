--the entity library


--hold the library
entity = {}

--store all the entities
entity_table = {}
entity_count = 0


--create entities
function entity.create_entity(type,sizex,sizey,texture,chunkx,chunky,posx,posy,inertiax,inertiay,item)
	entity_count = entity_count + 1
	entity_table[entity_count] = {}
	entity_table[entity_count]["sizex"] = sizex
	entity_table[entity_count]["sizey"] = sizey
	entity_table[entity_count]["chunkx"] = chunkx
	entity_table[entity_count]["chunky"] = chunky
	entity_table[entity_count]["posx"] = posx
	entity_table[entity_count]["posy"] = posy
	entity_table[entity_count]["inertiax"] = inertiax
	entity_table[entity_count]["inertiay"] = inertiay
	entity_table[entity_count]["on_block"] = false
	entity_table[entity_count]["entity_in_unloaded_chunk"] = false
	entity_table[entity_count]["item"] = item
	
	
	if item then
		entity_table[entity_count]["texture"] = texture_table[item]
		entity_table[entity_count]["magnetized"] = false
	else
		entity_table[entity_count]["texture"] = texture
	end
	
	--print(entity_count)
	
end

--draw entities
function entity.render_entity()
	if table.getn(entity_table) > 0 then
		for i = 1,table.getn(entity_table) do
			--print(i,entity_table[i])
			if entity_table[i] then
				local drawx = (player_drawnx+(entity_table[i]["posx"]*scale)+(map_max*scale*(entity_table[i]["chunkx"]-chunkx))-(player.playerx*scale))-((entity_table[i]["sizex"]/2)*scale)
				local drawy = (player_drawny+(entity_table[i]["posy"]*scale)+(map_max*scale*(chunky-entity_table[i]["chunky"]))-(player.playery*scale))-((entity_table[i]["sizey"]/2)*scale)
				love.graphics.draw(entity_table[i]["texture"],  drawx,drawy,0, scale*entity_table[i]["sizex"]/21, scale*entity_table[i]["sizey"]/21)--,scale*(entity_table[i]["sizex"]),scale*(entity_table[i]["sizey"]))
				--love.graphics.circle( "fill", drawx+((entity_table[i]["sizex"]/2)*scale), drawy+((entity_table[i]["sizey"]/2)*scale), 3 )
			end
		end
	end
end


--entity gravity
function entity.gravity()
	if table.getn(entity_table) > 0 then
		for i = 1,table.getn(entity_table) do
			if entity_table[i] then
				if entity_table[i]["magnetized"] == false then
					if entity_table[i]["entity_in_unloaded_chunk"] == false then
						--print(entity_table[i]["on_block"])
						if entity_table[i]["on_block"] == true then
							entity_table[i]["inertiay"] = 0
							--lastheight = math.floor(((map_max-player.playery)+(chunky*map_max)))
							--print(lastheight)
							--player.on_block = false
						else
							if entity_table[i]["inertiay"] < 0.3 then
								entity_table[i]["inertiay"] = entity_table[i]["inertiay"] + 0.01
								--print(entity_table[i]["inertiay"])
							end
						end
					else
						--print("entity "..i.." in unloaded chunk")
						entity_table[i]["inertiax"] = 0
						entity_table[i]["inertiay"] = 0
					end
				end
			end
		end
	end
end

--applying the entity physics
function entity.physics_apply(dt)
	--local oldposx,oldposy = player.playerx,player.playery
	
	
	if table.getn(entity_table) > 0 then
		for i = 1,table.getn(entity_table) do


			if entity_table[i] then

				entity.collision(i,entity_table[i].posx,entity_table[i].posy)

				entity.new_chunk(i,entity_table[i].posx,entity_table[i].posy)

				--collisionx(oldposx)
				--print(entity_table[i].inertiax)
				if math.abs(entity_table[i].inertiax) <= 0.005 then
					entity_table[i].inertiax = 0
				elseif entity_table[i].inertiax < 0 then
					entity_table[i].inertiax = entity_table[i].inertiax + 0.005
				elseif entity_table[i].inertiax > 0 then
					entity_table[i].inertiax = entity_table[i].inertiax - 0.005
				else
					entity_table[i].inertiax = entity_table[i].inertiax 
				end
				
				entity.item_magnet(i)
			end
		end
	end
		
end



--
function entity.collision(i,oldposx,oldposy)

	entity_table[i]["entity_in_unloaded_chunk"] = false
	
	
	
	local xer = {-entity_table[i]["sizex"]/4,entity_table[i]["sizex"]/4}
	local yer = {-entity_table[i]["sizey"]/4,entity_table[i]["sizey"]/4}
	local fall = true
	
	--check the corners (y)
	entity_table[i]["posy"] = entity_table[i]["posy"] + entity_table[i]["inertiay"]
	for q = 1,2 do
		for r = 1,2 do
			local squarex = math.floor(entity_table[i]["posx"]+xer[q])
			local squarey = math.floor(entity_table[i]["posy"]+yer[r])
			
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
			local entity_chunkx = entity_table[i]["chunkx"]
			local entity_chunky = entity_table[i]["chunky"]
			
			
			if loaded_chunks[entity_chunkx+chunkerx] and loaded_chunks[entity_chunkx+chunkerx][chunkery+entity_chunky] and loaded_chunks[entity_chunkx+chunkerx][chunkery+entity_chunky][squarex] and loaded_chunks[entity_chunkx+chunkerx][chunkery+entity_chunky][squarex][squarey] then
				if blocks[loaded_chunks[entity_chunkx+chunkerx][chunkery+entity_chunky][squarex][squarey]["block"]]["collide"] ~= false then
				
					---print("PUTTING BACK TO OLD")
					entity_table[i]["posy"] = oldposy
					
					if r == 2 then
						entity_table[i]["on_block"] = true
						--print("IT'S ON THE BLOCK")
						fall = false
					end
					if r == 1 then
						entity_table[i]["on_block"] = false
					end
				end
			else
				entity_table[i]["entity_in_unloaded_chunk"] = true
			end
		end
	end
	if fall == true then
		entity_table[i]["on_block"] = false
	end
	
	
	--check the corners(x)
	entity_table[i]["posx"] = entity_table[i]["posx"] + entity_table[i]["inertiax"]
	for q = 1,2 do
		for r = 1,3 do
			local squarex = math.floor(entity_table[i]["posx"]+xer[q])
			
			local squarey
			
			if r < 3 then
				 squarey = math.floor(entity_table[i]["posy"]+yer[r])
				 
			else
				squarey = math.floor(entity_table[i]["posy"])
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
			local entity_chunkx = entity_table[i]["chunkx"]
			local entity_chunky = entity_table[i]["chunky"]
			
			
			--if (squarex1 > map_max or squarex1 <= 0) or (squarey1 > map_max or squarey1 <= 0) or blocks[loaded_chunks[0][0][squarex1][squarey1]["block"]]["collide"] ~= false then
			if loaded_chunks[entity_chunkx+chunkerx] and loaded_chunks[entity_chunkx+chunkerx][chunkery+entity_chunky] and loaded_chunks[entity_chunkx+chunkerx][chunkery+entity_chunky][squarex] and loaded_chunks[entity_chunkx+chunkerx][chunkery+entity_chunky][squarex][squarey] then
				if blocks[loaded_chunks[entity_chunkx+chunkerx][chunkery+entity_chunky][squarex][squarey]["block"]]["collide"] ~= false then
					entity_table[i]["inertiax"] = 0
					entity_table[i]["posx"] = oldposx
					--print("stopping x inertia and pos")
				end
			else
				entity_table[i]["entity_in_unloaded_chunk"] = true
			end
		end
	end
end


--move entity into new chunk
function entity.new_chunk(i,posx,posy)
	--print(math.floor(player.playerx))
	if math.floor(posx) < 1 then
	
			entity_table[i]["chunkx"] = entity_table[i]["chunkx"] - 1
			entity_table[i]["posx"]   = entity_table[i]["posx"] + map_max -- put entity on other side of screen		
			--print(" block x -1")
			return false
	elseif math.floor(posx) > map_max then

			entity_table[i]["chunkx"] = entity_table[i]["chunkx"] + 1
			entity_table[i]["posx"]   = entity_table[i]["posx"] - map_max -- put entity on other side of screen
			--print("block x +1")
			return false
	
	elseif math.floor(posy) < 1 then
			entity_table[i]["chunky"] = entity_table[i]["chunky"] + 1
			entity_table[i]["posy"]   = entity_table[i]["posy"] + map_max  -- put entity on other side of screen
			--print(" block y -1")
			return false
	elseif math.floor(posy) > map_max then
			entity_table[i]["chunky"] = entity_table[i]["chunky"] - 1
			entity_table[i]["posy"]   = entity_table[i]["posy"] - map_max -- put entity on other side of screen
			--print("block y +1")
			return false
	end
	
	return true
end


--magnetize items towards player
--taken from sfan5's nuke mod in Minetest - https://forum.minetest.net/viewtopic.php?id=638
function entity.item_magnet(i)
	local realx = player.playerx - entity_table[i]["posx"]
	local realy = player.playery - entity_table[i]["posy"]
	local x = realx--math.abs(realx)
	local y = realy--math.abs(realy)
	
	local calc1 = x*x+y*y --optimize
	
	entity_table[i]["magnetized"] = false
	
	if calc1 <= magnet_radius * magnet_radius + magnet_radius then
		local normalx,normaly,length = math.normalize(player.playerx-entity_table[i]["posx"],player.playery-entity_table[i]["posy"])
		normalx,normaly = normalx*0.05,normaly*0.05
		entity_table[i]["inertiax"] = entity_table[i]["inertiax"] + normalx
		entity_table[i]["inertiay"] = entity_table[i]["inertiay"] + normaly
		entity_table[i]["magnetized"] = true
	end
	
	if calc1 <= add_inventory_radius * add_inventory_radius + add_inventory_radius then
		inventory_add(entity_table[i]["item"])
		--entity_table[i] = nil
		table.remove(entity_table,i)
		entity_count = entity_count - 1
		print("add to inventory")
		item_magnet_pickup:setPitch(love.math.random(80,120)/100)
		item_magnet_pickup:stop()
		item_magnet_pickup:play()
	end
end

--basic grid based collision detection

--{-x,+x,-y,+y}
player_collision_box = {-0.2,0.2,-0.9,0.8}

		
--squared collision detection
player.on_block = false
function collision(oldposx,oldposy)
	--do stairs
	player_in_unloaded_chunk = false
	
	
	
	local xer = {player_collision_box[1],player_collision_box[2]}
	local yer = {player_collision_box[3],player_collision_box[4]}
	local fall = true
	
	--check the corners (y)
	player.playery = player.playery + player.inertiay
	for q = 1,2 do
		for r = 1,2 do
			local squarex = math.floor(player.playerx+xer[q])
			local squarey = math.floor(player.playery+yer[r])
			
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
			if loaded_chunks[chunkx+chunkerx] and loaded_chunks[chunkx+chunkerx][chunkery+chunky] and loaded_chunks[chunkx+chunkerx][chunkery+chunky][squarex] and loaded_chunks[chunkx+chunkerx][chunkery+chunky][squarex][squarey] then
				if blocks[loaded_chunks[chunkx+chunkerx][chunkery+chunky][squarex][squarey]["block"]]["collide"] ~= false then
				
					player.playery = oldposy
					
					if r == 2 then
						player.on_block = true
						fall = false
					end
					if r == 1 then
						player.on_block = false
					end
				end
			else
				player_in_unloaded_chunk = true
			end
		end
	end
	if fall == true then
		player.on_block = false
	end
	
	
	--check the corners(x)
	player.playerx = player.playerx + player.inertiax
	for q = 1,2 do
		for r = 1,3 do
			local squarex = math.floor(player.playerx+xer[q])
			
			local squarey
			
			if r < 3 then
				 squarey = math.floor(player.playery+yer[r])
				 
			else
				squarey = math.floor(player.playery)
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
			
			--if (squarex1 > map_max or squarex1 <= 0) or (squarey1 > map_max or squarey1 <= 0) or blocks[loaded_chunks[0][0][squarex1][squarey1]["block"]]["collide"] ~= false then
			if loaded_chunks[chunkx+chunkerx] and loaded_chunks[chunkx+chunkerx][chunkery+chunky] and loaded_chunks[chunkx+chunkerx][chunkery+chunky][squarex] and loaded_chunks[chunkx+chunkerx][chunkery+chunky][squarex][squarey] then
				if blocks[loaded_chunks[chunkx+chunkerx][chunkery+chunky][squarex][squarey]["block"]]["collide"] ~= false then
					player.inertiax = 0
					player.playerx = oldposx
					--print("stopping x inertia and pos")
				end
			else
				player_in_unloaded_chunk = true
			end
		end
	end
end



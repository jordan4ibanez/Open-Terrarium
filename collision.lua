--basic grid based collision detection

		
--squared collision detection
player.on_block = false
function collision(oldposx,oldposy)
	--do stairs
	
	
	
	local xer = {-0.2,0.2}
	local yer = {0,1}
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
			--if (squarex1 > map_max or squarex1 <= 0) or (squarey1 > map_max or squarey1 <= 0) or ore[loaded_chunks[0][0][squarex1][squarey1]["block"]]["collide"] ~= false then
			if loaded_chunks[chunkerx] and loaded_chunks[chunkerx][chunkery] and loaded_chunks[chunkerx][chunkery][squarex] and loaded_chunks[chunkerx][chunkery][squarex][squarey] then
				if ore[loaded_chunks[chunkerx][chunkery][squarex][squarey]["block"]]["collide"] ~= false then
					player.playery = oldposy
					if r == 2 then
						player.on_block = true
						fall = false
					end
					if r == 1 then
						player.on_block = false
					end
				end
			end
		end
	end
	if fall == true then
		player.on_block = false
	end
	
	
	--check the corners(x)
	player.playerx = player.playerx + player.inertiax
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
			
			--if (squarex1 > map_max or squarex1 <= 0) or (squarey1 > map_max or squarey1 <= 0) or ore[loaded_chunks[0][0][squarex1][squarey1]["block"]]["collide"] ~= false then
			if loaded_chunks[chunkerx] and loaded_chunks[chunkerx][chunkery] and loaded_chunks[chunkerx][chunkery][squarex] and loaded_chunks[chunkerx][chunkery][squarex][squarey] then
				if ore[loaded_chunks[chunkerx][chunkery][squarex][squarey]["block"]]["collide"] ~= false then
					player.inertiax = 0
					player.playerx = oldposx
					--print("stopping x inertia and pos")
				end
			end
		end
	end
end


--make the player fall when in air
gravtimer = 0

function gravity(dt)
	--don't apply gravity if at bottom
	--if player.playery == map_max then
	--	player.playery = player.playery + 1
	--	maplib.new_block()
	--	return
	--end
	gravtimer = gravtimer + dt
	--reverse gravity in water
	if player.playery ~= 1 and ore[loaded_chunks[0][0][player.playerx][player.playery]["block"]]["float"] == true then
		if gravtimer >= 0.2 then
			local oldposx,oldposy = player.playerx,player.playery
			
			player.playery = player.playery - 1
			
			--collision(oldposx,oldposy)
			
			gravtimer = 0
		end
	elseif player.playery == 1 and ore[loaded_chunks[0][1][player.playerx][map_max]["block"]]["float"] == true then
		if gravtimer >= 0.2 then
			player.playery = player.playery - 1
			maplib.new_block()
		end
	--else apply normal gravity
	elseif player.playery ~= map_max and ore[loaded_chunks[0][0][player.playerx][player.playery+1]["block"]]["collide"] == false then
		
		if gravtimer >= 0.2 then
			local oldposx,oldposy = player.playerx,player.playery
			
			player.playery = player.playery + 1
			
			--collision(oldposx,oldposy)
			
			gravtimer = 0
		end
	elseif player.playery == map_max and ore[loaded_chunks[0][-1][player.playerx][1]["block"]]["collide"] == false then
		--print("applying new chunk gravity")
		if gravtimer >= 0.2 then
			player.playery = player.playery + 1
			maplib.new_block()
		end
	else
		--print("failure")
		gravtimer = 0
	end

end

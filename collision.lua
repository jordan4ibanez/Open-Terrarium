--basic grid based collision detection

		
--squared collision detection
player.on_block = false
function collisiony(oldposy)
	--stairs
	--if (player.playerx <= map_max and player.playerx > 1) and 
	--	(player.playery < map_max and player.playery > 1) and 
	--	loaded_chunks[0][0][player.playerx][player.playery]["block"] == 3 then
	--	player.playery = player.playery - 1
	local xer = {0.3,0.7}
	local yer = {0,1}
	local fall = true
	
	--check the corners
	for q = 1,2 do
		for r = 1,2 do
			local squarex1 = math.floor(player.playerx+xer[q])
			local squarey1 = math.floor(player.playery+yer[r])
			--if (squarex1 > map_max or squarex1 <= 0) or (squarey1 > map_max or squarey1 <= 0) or ore[loaded_chunks[0][0][squarex1][squarey1]["block"]]["collide"] ~= false then
			if (player.playerx <= map_max and player.playerx > 1) and (player.playery < map_max and player.playery > 1) and ore[loaded_chunks[0][0][squarex1][squarey1]["block"]]["collide"] ~= false then
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
	if fall == true then
		player.on_block = false
	end
end
function collisionx(oldposx)
	--stairs
	--if (player.playerx <= map_max and player.playerx > 1) and 
	--	(player.playery < map_max and player.playery > 1) and 
	--	loaded_chunks[0][0][player.playerx][player.playery]["block"] == 3 then
	--	player.playery = player.playery - 1
	local xer = {0.3,0.7}
	local yer = {0,1}
	local fall = true
	
	--check the corners
	for q = 1,2 do
		for r = 1,2 do
			local squarex1 = math.floor(player.playerx+xer[q])
			local squarey1 = math.floor(player.playery+yer[r])
			--if (squarex1 > map_max or squarex1 <= 0) or (squarey1 > map_max or squarey1 <= 0) or ore[loaded_chunks[0][0][squarex1][squarey1]["block"]]["collide"] ~= false then
			if (player.playerx <= map_max and player.playerx > 1) and (player.playery < map_max and player.playery > 1) and ore[loaded_chunks[0][0][squarex1][squarey1]["block"]]["collide"] ~= false then
				player.inertiax = 0
				player.playerx = oldposx
				print("stopping x inertia and pos")
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

--the map library
maplib = {}


chunkx,chunky = math.random(-1000,1000),math.random(0,-3)

--tile size
map_max = 35

--ore generation
ore_min = 0 -- the minimum amount of ore that'll be generated in a map block
ore_max = 5 -- the max

--cave generation
cave_min = 150
cave_max = 200

--the chunk y which the rock starts
underground = 0

--the top of the dirt layer
earth_max = 2

--max chunks loaded ( chunk x chunk )
max_chunks = 3

--makes player move to next map section
function maplib.new_block(oldposx,oldposy)
	if player.playerx < 1 then
		if loaded_chunks[-1][0][map_max][player.playery]["block"] == 1 then
			chunkx = chunkx - 1
			maplib.createmap() -- create a new block
			player.playerx = map_max -- put player on other side of screen		
			print(" block x -1")
			return false
		else
			print("something blocking -1 x")
		end
	elseif player.playerx > map_max then
		if loaded_chunks[1][0][1][player.playery]["block"] == 1 then
			chunkx = chunkx + 1
			maplib.createmap() -- create a new block
			player.playerx = 1 -- put player on other side of screen
			print("block x +1")
			return false
		else
			print("something blocking 1 x")
		end
	
	elseif player.playery < 1 then
		if loaded_chunks[0][1][player.playerx][map_max]["block"] == 1 then
			chunky = chunky + 1
			maplib.createmap() -- create a new block
			player.playery = map_max -- put player on other side of screen
			print(" block y -1")
			return false
		else
			print("something blocking 1 y")
		end
	elseif player.playery > map_max then
		if loaded_chunks[0][-1][player.playerx][1]["block"] == 1 then
			chunky = chunky - 1
			maplib.createmap() -- create a new block
			player.playery = 1 -- put player on other side of screen
			print("block y +1")
			return false
		else
			print("something blocking -1 y")
		end
	end
	
	return true
end

--generates ore
function maplib.generate_ore(tiles)

	local limit = math.random(ore_min, ore_max)
	
	
	if limit ~= 0 then
		for limit = 1,limit do
			local x,y = math.random(1,map_max),math.random(1,map_max)
			
			--add this to the x,y
			for w = -3,-1 do
				for z = 1,3 do
					--stay within map boundaries
					if x + w >= 1 and y + z <= map_max then
						tiles[x+w][y+z]["block"] = 3
					end
					
				end
			end
		
		
		end
	end

end

--generates caves
function maplib.generate_cave(tiles)

	local limit = math.random(cave_min, cave_max)
	
	
	if limit ~= 0 then
		for limit = 1,limit do
			local x,y = math.random(1,map_max),math.random(1,map_max)
			
			--add this to the x,y
			for w = -3,-1 do
				for z = 1,3 do
					--stay within map boundaries
					if x + w >= 1 and y + z <= map_max then
						tiles[x+w][y+z]["block"] = 1
					end
					
				end
			end
		end
	end

end


--[[
when walking around seemlessly generate chunks

unload chunks that are not visible <-
or
keep all chunks loaded, just do not render them off screen

create a x * x table, set max loaded chunks (x)

render, and modify everything to work correctly with all loaded chunks

]]--

max_chunks = 1 --x * x chunks loaded --does -1 - 1 (-x to x) -- (x * 2) + 1 to get max chunks in memory



--generates tile blocks
function maplib.createmap()

	loaded_chunks = {} --chunks in mememory
	
	for xx  = -max_chunks,max_chunks do
		loaded_chunks[xx] = {}
		for yy  = -max_chunks,max_chunks do 
		
			
			if not love.filesystem.exists("map") then
				love.filesystem.createDirectory( "map" )
			end
			
			local block_exists = love.filesystem.exists("/map/"..chunkx+xx.."_"..chunky+yy..".txt")
			
			
			local number = 0
			local val = 0
			tiles = {}
			--generate map block
			if not block_exists then
				--print(chunky)
				--generate underground
				if chunky+yy <= underground then
					for x = 1,map_max do
						tiles[x] = {}
						for y = 1,map_max do
							tiles[x][y] =  {}
							tiles[x][y]["block"] = 2
										
						end
					end
					maplib.generate_ore(tiles)
					
					maplib.generate_cave(tiles)
				--generate the grass top
				elseif chunky+yy == earth_max then
					local yer = math.random(1,map_max)
					for x = 1,map_max do
						tiles[x] = {}
						yer =  yer + math.random(-1,1)
						for y = 1,map_max do
							tiles[x][y] =  {}
							--generate dirt as debug
							if y == yer then
								tiles[x][y]["block"] = 4
							elseif y < yer then
								tiles[x][y]["block"] = 1
							else
								tiles[x][y]["block"] = 3
							end								
						end
					end
				--generate dirt under grass
				elseif chunky+yy < earth_max and chunky+yy > underground then
					--print("test")
					for x = 1, map_max do
						tiles[x] = {}
						for y = 1,map_max do
							tiles[x][y] =  {}
							tiles[x][y]["block"] = 3
										
						end
					end
				else
					--print("generate air")
					for x = 1,map_max do
						tiles[x] = {}
						for y = 1,map_max do
							tiles[x][y] =  {}
							tiles[x][y]["block"] = 1
										
						end
					end
				end
				
				--save
				love.filesystem.write( "/map/"..chunkx+xx.."_"..chunky+yy..".txt", TSerial.pack(tiles))
				loaded_chunks[xx][yy] = tiles
			else
				
				tiles = TSerial.unpack(love.filesystem.read("/map/"..chunkx+xx.."_"..chunky+yy..".txt"))
				loaded_chunks[xx][yy] = tiles
			end
		end
	end
	--for xx  = -max_chunks,max_chunks do
	--	for yy  = -max_chunks,max_chunks do 
	--		print(loaded_chunks[xx][yy])
	--	end
	--end
end

--executed in love.draw to draw map

--function maplib.draw()
--	love.graphics.setFont(font)
--	
--	for x = 1,map_max do
--		for y = 1,map_max do
--			love.graphics.setColor(ore[tiles[x][y]["block"]]["rgb"][1],ore[tiles[x][y]["block"]]["rgb"][2],ore[tiles[x][y]["block"]]["rgb"][3],255)
--			love.graphics.print(ore[tiles[x][y]["block"]]["image"], x*scale, y*scale)
--			if x == math.floor(map_max / 2) and y == math.floor(map_max / 2) then
--				love.graphics.print("X", x*scale, y*scale)
--			end
--		end
--	end
--	
--end
function maplib.draw()
	love.graphics.setFont(font)
	for xx  = -max_chunks,max_chunks do
		for yy  = -max_chunks,max_chunks do
			for x = 1,map_max do
				for y = 1,map_max do
					--love.graphics.setColor(ore[loaded_chunks[xx][-yy][x][y]["block"]]["rgb"][1],ore[loaded_chunks[xx][-yy][x][y]["block"]]["rgb"][2],ore[loaded_chunks[xx][-yy][x][y]["block"]]["rgb"][3],255)
					--print(loaded_chunks[xx][-yy][x][y]["block"])
					local drawx = (((x*scale)-(player.playerx*scale))+((scale*map_max)/2))+(map_max*scale*xx)+offsetx
					local drawy =  (((y*scale)-(player.playery*scale))+((scale*map_max)/2))+(map_max*scale*yy)+offsety-4
					
					if drawx >= -scale and drawx < screenwidth and drawy >= -scale and drawy < screenheight then
						love.graphics.draw(texture_table[loaded_chunks[xx][-yy][x][y]["block"]],  drawx,drawy,0, scale/16, scale/16)
					end
					--love.graphics.print(,, )
					--if x == math.floor(map_max / 2) and y == math.floor(map_max / 2) then
					--	love.graphics.print("X", x*scale, y*scale)
					--end
				end
			end
		end
	end
end

flowtimer = 0

--make liquids flow
function maplib.liquid_flow(dt)
	flowtimer = flowtimer + dt
	
	local after_table = {}
	if flowtimer > 0.5 then
		flowtimer = 0
		for xx  = -max_chunks,max_chunks do
			after_table[xx] = {}
			for yy  = -max_chunks,max_chunks do
				after_table[xx][yy] = {}
				for x = 1,map_max do
					after_table[xx][yy][x] = {}
					for y = 1,map_max do
						after_table[xx][yy][x][y] = {}
						local block = loaded_chunks[xx][-yy][x][y]["block"]
						--downward flow
						if ore[block]["prop"] == "liquid"  and y + 1 <= map_max and loaded_chunks[xx][-yy][x][y+1]["block"] == 1  then
							after_table[xx][yy][x][y]["block"] = block
							after_table[xx][yy][x][y]["down"] = "down"
						end
						--rightward flow
						if ore[block]["prop"] == "liquid"  and x + 1 <= map_max and loaded_chunks[xx][-yy][x+1][y]["block"] == 1  then
							after_table[xx][yy][x][y]["block"] = block
							after_table[xx][yy][x][y]["right"] = "right"
						end
						--leftward flow
						if ore[block]["prop"] == "liquid"  and x - 1 >= 1 and loaded_chunks[xx][-yy][x-1][y]["block"] == 1  then
							after_table[xx][yy][x][y]["block"] = block
							after_table[xx][yy][x][y]["left"] = "left"
						end
						--love.graphics.draw(texture_table[loaded_chunks[xx][-yy][x][y]["block"]],  (((x*scale)-(player.playerx*scale))+((scale*map_max)/2))+(map_max*scale*xx)+offsetx, (((y*scale)-(player.playery*scale))+((scale*map_max)/2))+(map_max*scale*yy)+offsety-4,0, scale/16, scale/16)
					end
				end
			end
		end
	end
	--a hack to delay water flow
	for keyxx,valuexx in pairs(after_table) do
		for keyyy,valueyy in pairs(valuexx) do
			for keyx, valuex in pairs(valueyy) do
				for keyy,valuey in pairs(valuex) do
					if valuey["block"] ~= nil then
						--don't elseif, or will bug out
						if valuey["down"] == "down" then
							loaded_chunks[keyxx][-keyyy][keyx][keyy+1]["block"] = valuey["block"]
						end
						if valuey["right"] == "right" then
							loaded_chunks[keyxx][-keyyy][keyx+1][keyy]["block"] = valuey["block"]
						end
						if valuey["left"] == "left" then
							loaded_chunks[keyxx][-keyyy][keyx-1][keyy]["block"] = valuey["block"]
						end
					end
				end
			end
		end
	end
end
--[[ a test
for x = 1,10 do
	local line = ""
	for y = 1,10 do
		line = line..tiles.x.y
	end
	print(line.."\n")
end

]]--

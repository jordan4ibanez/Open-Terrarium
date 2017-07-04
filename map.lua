--the map library
maplib = {}


chunkx,chunky = math.random(-1000,1000),math.random(-1000,1000)

--create tiles
map_max = 25

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
function maplib.new_block()
	if player.playerx < 1 then
		chunkx = chunkx - 1
		maplib.createmap() -- create a new block
		player.playerx = map_max -- put player on other side of screen
		print(" block x -1")
		return false
	elseif player.playerx > map_max then
		chunkx = chunkx + 1
		maplib.createmap() -- create a new block
		player.playerx = 1 -- put player on other side of screen
		print("block x +1")
		return false
	
	elseif player.playery < 1 then
		chunky = chunky + 1
		maplib.createmap() -- create a new block
		player.playery = map_max -- put player on other side of screen
		print(" block y -1")
		return false
	elseif player.playery > map_max then
		chunky = chunky - 1
		maplib.createmap() -- create a new block
		player.playery = 1 -- put player on other side of screen
		print("block y +1")
		return false
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


--generates tile blocks
function maplib.createmap()
	
	if not love.filesystem.exists("map") then
		love.filesystem.createDirectory( "map" )
	end
	
	local block_exists = love.filesystem.exists("/map/"..chunkx.."_"..chunky..".txt")
	
	
	local number = 0
	local val = 0
	tiles = {}
	--generate map block
	if not block_exists then
		print(chunky)
		--generate underground
		if chunky <= underground then
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
		elseif chunky == earth_max then
			local yy = math.random(1,map_max)
			for x = 1,map_max do
				tiles[x] = {}
				yy =  yy + math.random(-1,1)
				for y = 1,map_max do
					tiles[x][y] =  {}
					--generate dirt as debug
					if y == yy then
						tiles[x][y]["block"] = 4
					elseif y < yy then
						tiles[x][y]["block"] = 1
					else
						tiles[x][y]["block"] = 3
					end								
				end
			end
		--generate dirt under grass
		elseif chunky < earth_max and chunky > underground then
			print("test")
			for x = 1, map_max do
				tiles[x] = {}
				for y = 1,map_max do
					tiles[x][y] =  {}
					tiles[x][y]["block"] = 3
								
				end
			end
		else
			print("generate air")
			for x = 1,map_max do
				tiles[x] = {}
				for y = 1,map_max do
					tiles[x][y] =  {}
					tiles[x][y]["block"] = 1
								
				end
			end
		end
		
		--save
		love.filesystem.write( "/map/"..chunkx.."_"..chunky..".txt", TSerial.pack(tiles))
	else
		
		tiles = TSerial.unpack(love.filesystem.read("/map/"..chunkx.."_"..chunky..".txt"))
	end
end

--executed in love.draw to draw map
function maplib.draw()
	love.graphics.setFont(font)
	
	for x = 1,map_max do
		for y = 1,map_max do
			love.graphics.setColor(ore[tiles[x][y]["block"]]["rgb"][1],ore[tiles[x][y]["block"]]["rgb"][2],ore[tiles[x][y]["block"]]["rgb"][3],255)
			love.graphics.print(ore[tiles[x][y]["block"]]["image"], x*scale, y*scale)
			if x == math.floor(map_max / 2) and y == math.floor(map_max / 2) then
				love.graphics.print("X", x*scale, y*scale)
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

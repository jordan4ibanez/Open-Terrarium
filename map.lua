--the map library
maplib = {}


chunkx,chunky = math.random(-1000,1000),math.random(-1000,1000)

--create tiles
mapheight = 48
mapwidth  = 30

ore_min = 0 -- the minimum amount of ore that'll be generated in a map block
ore_max = 5 -- the max

--makes player move to next map section
function maplib.new_block()
	if player.playerx < 1 then
		chunkx = chunkx - 1
		maplib.createmap() -- create a new block
		player.playerx = mapwidth -- put player on other side of screen
		print(" block x -1")
		return false
	elseif player.playerx > mapwidth then
		chunkx = chunkx + 1
		maplib.createmap() -- create a new block
		player.playerx = 1 -- put player on other side of screen
		print("block x +1")
		return false
	
	elseif player.playery < 1 then
		chunky = chunky - 1
		maplib.createmap() -- create a new block
		player.playery = mapheight -- put player on other side of screen
		print(" block y -1")
		return false
	elseif player.playery > mapheight then
		chunky = chunky + 1
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
			local x,y = math.random(1,mapwidth),math.random(1,mapheight)
			
			--add this to the x,y
			for w = -3,-1 do
				for z = 1,3 do
					--stay within map boundaries
					print(w+x,y+z)
					if x + w >= 1 and y + z <= mapheight then
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
		for x = 1,mapwidth do
			tiles[x] = {}
			for y = 1,mapheight do
				tiles[x][y] =  {}
				tiles[x][y]["block"] = 2
							
			end
		end
		
		maplib.generate_ore(tiles)
		
		--save
		love.filesystem.write( "/map/"..chunkx.."_"..chunky..".txt", TSerial.pack(tiles))
	else
		
		tiles = TSerial.unpack(love.filesystem.read("/map/"..chunkx.."_"..chunky..".txt"))
	end
end

--executed in love.draw to draw map
function maplib.draw()
	love.graphics.setFont(font)
	love.graphics.setColor(255,255,255,255)
	for x = 1,mapwidth do
		for y = 1,mapheight do
			love.graphics.print(ore[tiles[x][y]["block"]]["image"], x*scale, y*scale)
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

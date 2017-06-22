--the map library
maplib = {}


chunkx,chunky = 0,0

--create tiles
mapheight = 48
mapwidth  = 30
tiles = {}

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



--generates tile blocks
function maplib.createmap()
	
	if not love.filesystem.exists("map") then
		love.filesystem.createDirectory( "map" )
	end
	
	local block_exists = love.filesystem.exists("/map/"..chunkx.."_"..chunky..".txt")

	if not block_exists then
		for x = 1,mapwidth do
			tiles[x] = {}
			for y = 1,mapheight do
				local value = love.math.noise( x/mapwidth, y/mapheight )
				tiles[x][y] =  {}
				if value > 0.5 then
					tiles[x][y]["block"] = 1--love.math.random(0,1)
				else
					tiles[x][y]["block"] = 0
				end
					
			end
		end
		
		
		
		
	
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
			local graphic
			if tiles[x][y]["block"] == 0 then
				graphic = "" --air
			elseif tiles[x][y]["block"] == 1 then
				graphic = "#" --stone
			elseif tiles[x][y]["block"] == 2 then
				graphic = "/" --stairs
			end
			love.graphics.print(graphic, x*scale, y*scale)
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



while true do
	--load old tiles
	print("load old")
	--tiles = TSerial.unpack(love.filesystem.read("/map/"..chunkx+xx.."_"..chunky+yy..".txt"))
	savechannel:push{"load_old","/map/"..chunkx+xx.."_"..chunky+yy..".txt"}
	
	local tiles = loadchannel:pop()
	print(tiles)
	loaded_chunks[xx][yy] = tiles
end

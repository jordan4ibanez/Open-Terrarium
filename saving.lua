--how the map saves and loads

savechannel = love.thread.getChannel("save")
loadchannel = love.thread.getChannel("load")

dofile("tserial.lua")

--note about threads
--when the thread stops doing stuff, it crashed without
--debug info

while true do
	--print("test")
	if savechannel:getCount( ) > 0 then
		local x = savechannel:pop()
		local doing = x[1]
		if doing == "saving_old" then
			print("saving old chunks")
			local max_chunks = x[2]
			local chunkx = x[3]
			local chunky = x[4]
			local loaded_chunks = x[5]
			
			print(max_chunks,chunkx,chunky,loaded_chunks)
					
			for xx  = -max_chunks,max_chunks do
				for yy  = -max_chunks,max_chunks do
					if loaded_chunks[xx] and loaded_chunks[xx][yy] then
						love.filesystem.write( "/map/"..chunkx+xx.."_"..chunky+yy..".txt", TSerial.pack(loaded_chunks[xx][yy]))
						print("saving:"..chunkx+xx.."_"..chunky+yy)
					end
				end
			end
		elseif doing == "load_old" then
				print("load old")
				print("loading old chunks")
				local max_chunks = x[2]
				local chunkx = x[3]
				local chunky = x[4]
				local loaded_chunks = x[5]
				local xx = x[6]
				local yy = x[7]
			
				--print("pushing")
				local file = love.filesystem.read("/map/"..chunkx+xx.."_"..chunky+yy..".txt")
				
				loadchannel:push{TSerial.unpack(file),xx,yy}
				print("succesfully loaded "..chunkx+xx.."_"..chunky+yy)
				--print("file doesn't exist")
		end
		
	end
end
--[[
for xx  = -max_chunks,max_chunks do
	for yy  = -max_chunks,max_chunks do
		love.filesystem.write( "/map/"..chunkx+xx.."_"..chunky+yy..".txt", TSerial.pack(loaded_chunks[xx][yy]))
		print("saving:"..chunkx+xx.."_"..chunky+yy)
	end
end
]]--

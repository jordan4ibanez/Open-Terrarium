savechannel = love.thread.getChannel("save")

dofile("tserial.lua")

--note about threads
--when the thread stops doing stuff, it crashed without
--debug info

while true do
	if savechannel:getCount( ) > 0 then
		print("saving chunks")
		local x = savechannel:pop()
		local max_chunks = x[1]
		local chunkx = x[2]
		local chunky = x[3]
		local loaded_chunks = x[4]
		
		print(max_chunks,chunkx,chunky,loaded_chunks)
				
		for xx  = -max_chunks,max_chunks do
			for yy  = -max_chunks,max_chunks do
				love.filesystem.write( "/map/"..chunkx+xx.."_"..chunky+yy..".txt", TSerial.pack(loaded_chunks[xx][yy]))
				print("saving:"..chunkx+xx.."_"..chunky+yy)
			end
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

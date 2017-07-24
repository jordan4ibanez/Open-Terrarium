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
		--print("failure")
		local x = savechannel:pop()
		local doing = x[1]
		if doing == "saving_old" then
			--print("saving old chunks")
			local max_chunks = x[2]
			local chunkx = x[3]
			local chunky = x[4]
			local loaded_chunks = x[5]
			
			--print(max_chunks,chunkx,chunky,loaded_chunks)
					
			for xx  = chunkx-max_chunks,chunkx+max_chunks do
				for yy  = chunky-max_chunks,chunky+max_chunks do
					if loaded_chunks[xx] and loaded_chunks[xx][yy] then
						love.filesystem.write( "/map/"..xx.."_"..yy..".txt", TSerial.pack(loaded_chunks[xx][yy]))
						--print("saving:"..xx.."_"..yy)
					end
				end
			end
		end
		if doing == "load_old" then
			--print("load old")
			local max_chunks = x[2]
			local loaded_chunks = x[3]
			local xx = x[4]
			local yy = x[5]
			
			--print("pushing")
			--print(xx,yy)
			local file = love.filesystem.read("/map/"..xx.."_"..yy..".txt")
			--print("failure")
			--print(file)
			
			loadchannel:push{TSerial.unpack(file),xx,yy}
			--print("succesfully loaded "..xx.."_"..yy)
			--print("file doesn't exist")
		end
		if doing == "save_new" then
			--print("saving new")
			local data = x[2]
			local xx = x[3]
			local yy = x[4]
			love.filesystem.write( "/map/"..xx.."_"..yy..".txt", TSerial.pack(data))
			
			loadchannel:push{data,xx,yy}
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

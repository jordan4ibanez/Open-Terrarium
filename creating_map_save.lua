savechannel = love.thread.getChannel("save")

dofile("tserial.lua")

while true do
	if savechannel:getCount( ) > 0 then
		love.filesystem.write( "/map/"..chunkx+xx.."_"..chunky+yy..".txt", TSerial.pack(tiles))
end

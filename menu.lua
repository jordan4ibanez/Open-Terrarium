--menu animation and info
menu = {}

mx,my = 1,1

menutitle = {}
menutitle.g = 35
menutitle.a = 35
menutitle.m = 35
menutitle.e = 35

menutimer = 0
pause = false

letter = 1

function menu.animate()
	if pause == false then
		menutimer = menutimer + 1
	end
	if menutimer > 20 then
	
		if letter == 1 then
			menutitle.g = menutitle.g + 2
		elseif letter == 2 then
			menutitle.a = menutitle.a + 2
		elseif letter == 3 then
			menutitle.m = menutitle.m + 2
		elseif letter == 4 then
			menutitle.e = menutitle.e + 2
		end
		if menutimer >= 40 then
			menutimer = 0
			letter = letter + 1
			if letter > 4 then
				letter = 1
			end
		end
	elseif menutimer <= 20 then
		if letter == 1 then
			menutitle.g = menutitle.g - 2
		elseif letter == 2 then
			menutitle.a = menutitle.a - 2
		elseif letter == 3 then
			menutitle.m = menutitle.m - 2
		elseif letter == 4 then
			menutitle.e = menutitle.e - 2
		end
		
	end
end

selected_chunkx,selected_chunky = 0,0

function menu.draw()
	
	menu.cursor()
	--redo this as a table
	--love.graphics.setFont(fontbig)
	--love.graphics.setColor(255,0,0,255)
    --love.graphics.print("D", 400, menutitle.g)
    --love.graphics.print("I", 440, menutitle.a)
    --love.graphics.print("G", 480, menutitle.m)
    --love.graphics.print("!", 520, menutitle.e)
	local xxer = 600
	--score debug
	love.graphics.setFont(font)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Score:"..tostring(score),xxer,12)

	
	--debug mining
	if player.mining == true then
		love.graphics.setColor(255,0,0,255)
		love.graphics.print("Mining", xxer,24)
		love.graphics.setColor(128,128,128,255)
		love.graphics.print("Placing", xxer+80,24)
		
	elseif player.mining == false then		
		love.graphics.setColor(128,128,128,255)
		love.graphics.print("Mining", xxer,24)
		love.graphics.setColor(255,0,0,255)
		love.graphics.print("Placing", xxer+80,24)
		
		--love.graphics.print("PosX:"..player.playerx.." PosY:"..player.playery, 400,150)
	end
	--debug player's pos
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("PosX:"..(player.playerx+(chunkx*map_max)).." PosY:"..((map_max-player.playery)+(chunky*map_max)), 5,5)
	--debug mouse's pos
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("MX:"..mx.." MY:"..my, xxer,36)
	--debug selected item
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("ITEM:", xxer,48) love.graphics.draw(texture_table[player.selected],xxer+60,45,0,0.8,0.8)
	
	love.graphics.print("Chunkx:"..chunkx, xxer,60)
	love.graphics.print("Chunky:"..chunky, xxer,72)
	
	love.graphics.print("Current FPS:"..tostring(love.timer.getFPS( )), xxer, 84)
	
	love.graphics.print("Intx:"..tostring(player.inertiax), xxer, 96)
	love.graphics.print("Inty:"..tostring(player.inertiay), xxer, 108)

end

function menu.cursor()
	local x, y = love.mouse.getPosition( )
	
	
	--love.graphics.circle( "fill", player_drawnx, player_drawny, 4 )
	
	--local xx,yy = math.floor(x/scale),math.floor((y+3)/scale)
	local xx,yy = math.floor((x-player_drawnx)/scale)*scale,math.floor((y-player_drawny)/scale)*scale


	mx,my = player.playerx + (xx/scale),player.playery + (yy/scale)
	
	selected_chunkx,selected_chunky = 0,0
	--only change and draw if in boundaries
	if ((mx >= 1 and mx <= map_max) and (my >= 1 and my <= map_max)) and (math.abs(player.playerx-mx) <=5 and math.abs(player.playery-my) <=5) then
		love.graphics.rectangle("line", player_drawnx+xx, player_drawny+yy, scale, scale )
		
	--reach outside of chunk
	elseif (math.abs(player.playerx-mx) <=5 and math.abs(player.playery-my) <=5) then

		--ocal chunkex,chunkey = math.floor(mx/map_max),math.floor(my/map_max)
		
		--overreach x
		if mx > map_max then
			mx = mx - map_max
			selected_chunkx = 1
		elseif mx < 1 then
			mx = mx + map_max
			selected_chunkx = -1
		else
			--mx = 0
		end
		
		
		--overreach y
		if my < 1 then
			my = my + map_max
			selected_chunky = 1
			--print("up")
		elseif my > map_max then
			my = my - map_max
			selected_chunky = -1
			--print("down")
		--else
			--my = 0
		end
		--print("chunkey:"..chunkey.."|my:"..my)
		
		--print(selected_chunkx, selected_chunky)
		love.graphics.rectangle("line", player_drawnx+xx, player_drawny+yy, scale, scale )
		
	else
		mx,my = -1,-1
	end
	
	

end

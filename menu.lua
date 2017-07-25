--menu animation and info
menu = {}

mx,my = 1,1

menutitle = {"O","p","e","n"," ","T","e","r","r","a","r","i","u","m"," ","0",".","0",".","1"}
menu_char = {}
for i, v in ipairs(menutitle) do
	--print(i)
	menu_char[i] = 0
end
print(menutitle[1])
menutimer = 0
characters = table.getn(menutitle)
pause = false

letter = 1

function menu.animate()
	if pause == false then
		menutimer = menutimer + 1
	end
	if menutimer > 10 then
		--push up
		menu_char[letter] = menu_char[letter] + 2
		if menutimer >= 20 then
			menutimer = 0
			letter = letter + 1
			--skip spaces
			if menutitle[letter] == " " then
				letter = letter + 1
			end
			if letter > characters then
				letter = 1
			end
		end
	elseif menutimer <= 10 then
		--push down
		menu_char[letter] = menu_char[letter] - 2
	end
end

selected_chunkx,selected_chunky = 0,0

function menu.draw()
	
	menu.cursor()
	
	
	
	love.graphics.setFont(font)
	love.graphics.setColor(0,0,120,255)
	for i = 1,characters do
		love.graphics.print(menutitle[i], screenwidth-260+(12*i)-2,screenheight-10+menu_char[i]+2 )
	end
	love.graphics.setColor(255,0,0,255)
	for i = 1,characters do
		love.graphics.print(menutitle[i], screenwidth-260+(12*i),screenheight-10+menu_char[i] )
	end
	if debugger == true then
		love.graphics.setColor(255,255,255,255)
		fpsGraph:draw()
		memGraph:draw()
		dtGraph:draw()
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
		
		love.graphics.print("Deaths:"..tostring(deaths), xxer, 250)
	end

end

function menu.cursor()
	--interact with world
	if crafting_open == false then
		local x, y = love.mouse.getPosition( )
		
		
		--love.graphics.circle( "fill", player_drawnx, player_drawny, 4 )
		
		--local xx,yy = math.floor(x/scale),math.floor((y+3)/scale)
		local xx,yy = ((x-player_drawnx)/scale)*scale,((y-player_drawny)/scale)*scale

			

		mx,my = math.floor(player.playerx + (xx/scale)),math.floor(player.playery + (yy/scale))
		
		--print(mx,my)
		
		
		
		selected_chunkx,selected_chunky = chunkx,chunky
		--only change and draw if in boundaries
		if ((mx >= 1 and mx <= map_max) and (my >= 1 and my <= map_max)) and (math.abs(player.playerx-mx) <=5 and math.abs(player.playery-my) <=5) then
			local draw_selection_x = player_drawnx+(mx*scale)-(player.playerx*scale)
			local draw_selection_y = player_drawny+(my*scale)-(player.playery*scale)
			love.graphics.rectangle("line",draw_selection_x, draw_selection_y, scale, scale )
			if mine_process > 0 then
				love.graphics.draw(mining_texture[math.ceil(mine_process)],  draw_selection_x, draw_selection_y,0, scale/16, scale/16,0,0)
			end
			
		--reach outside of chunk
		elseif (math.abs(player.playerx-mx) <=5 and math.abs(player.playery-my) <=5) then

			--ocal chunkex,chunkey = math.floor(mx/map_max),math.floor(my/map_max)
			
			--overreach x
			if mx > map_max then
				mx = mx - map_max
				selected_chunkx = chunkx + 1
			elseif mx < 1 then
				mx = mx + map_max
				selected_chunkx = chunkx - 1
			else
				--selected_chunkx = chunkx
			end
			
			
			--overreach y
			if my < 1 then
				my = my + map_max
				selected_chunky = chunky + 1
				--print("up")
			elseif my > map_max then
				my = my - map_max
				selected_chunky = chunky - 1
				--print("down")
			else
				--print("current")
				--selected_chunky = chunky
			end
			--print("chunkey:"..chunkey.."|my:"..my)
			
			--print(selected_chunkx, selected_chunky)
			local draw_selection_x = player_drawnx+(mx*scale)+(map_max*scale*(selected_chunkx-chunkx))-(player.playerx*scale)
			local draw_selection_y = player_drawny+(my*scale)+(map_max*scale*(chunky-selected_chunky))-(player.playery*scale)
			
			love.graphics.rectangle("line", draw_selection_x, draw_selection_y, scale, scale )
			if mine_process > 0 then
				love.graphics.draw(mining_texture[math.ceil(mine_process)],  draw_selection_x, draw_selection_y,0, scale/16, scale/16,0,0)
			end
		else
			mx,my = -1,-1
		end
		
		if mine_process ~= 0 and (mx ~= old_mx or my ~= old_my) then
			mine_process = 0
		end
		
		
		old_mx,old_my = mx,my
	--interact with inventory
	else
		local x, y = love.mouse.getPosition( )
		
		
		if x > crafting_x and x < crafting_x + (inventory_size*84) and y > crafting_y and y < crafting_y + (inventory_height*84) then
			crafting_selection_x = math.ceil((x-crafting_x)/84)
			crafting_selection_y = math.ceil((y-crafting_y)/84)
		else
			crafting_selection_x = -1
			crafting_selection_y = -1
		end
		if x > craft_inv_x and x < craft_inv_x + (crafting.craft_size*84) and y > craft_inv_y and y < craft_inv_y + (crafting.craft_size*84) then
			craft_inventory_selection_x = math.ceil((x-craft_inv_x)/84)
			craft_inventory_selection_y = math.ceil((y-craft_inv_y)/84)
		else
			craft_inventory_selection_x = -1
			craft_inventory_selection_y = -1
		end
		if x > craft_output_x and x < craft_output_x + 84 and y > craft_output_y and y < craft_output_y + 84 then
			craft_output_selection_x = math.ceil((x-craft_output_x)/84)
			craft_output_selection_y = math.ceil((y-craft_output_y)/84)
		else
			craft_output_selection_x = -1
			craft_output_selection_y = -1
		end
	end

end

--the crafting library

crafting = {}
crafting_open = false

crafting_x = 120
crafting_y = 270

crafting_selection_x = 1
crafting_selection_y = 1

function crafting.render_crafting()
	if crafting_open == true then
	
		--draw inventory
		local xstep = 0
		local ystep = 0
		local nextline = 0
		for i = 1,table.getn(inventory) do
			love.graphics.draw(inventory_slot,  crafting_x+(xstep*84), crafting_y+(84*ystep),0, 1, 1)
			--move to next step
			nextline = nextline + 1
			xstep = xstep + 1
			if nextline >=inventory_size then
				nextline = 0
				ystep = ystep + 1
				xstep = 0
			end
		end
		--draw selection
		if crafting_selection_x > 0 and crafting_selection_y > 0 then
			love.graphics.draw(inventory_slot_selection,  ((crafting_selection_x-1)*84)+crafting_x, ((crafting_selection_y-1)*84)+crafting_y,0, 1, 1)
		end
		--love.graphics.rectangle("line", ((crafting_selection_x-1)*84)+crafting_x, ((crafting_selection_y-1)*84)+crafting_y, 84, 84 )
		
		--love.graphics.draw(inventory_slot_selection,  crafting_x+(inventory_selection*(inv_slot_width/2)), crafting_y,0, 1/2, 1/2)
		local xstep = 0
		local ystep = 0
		local nextline = 0
		for i = 1,table.getn(inventory) do
			--print(inventory[i]["id"])
			--texture_table[loaded_chunks[xx][yy][x][y]["block"]]
			--love.graphics.draw(texture_table[inventory[i]["id"]],  drawx,drawy,0, scale/16, scale/16)
			if inventory[i]["id"] then
				love.graphics.draw(texture_table[inventory[i]["id"]],  crafting_x+(xstep*84)+10, crafting_y+(84*ystep)+10,0, 4, 4)
				--love.graphics.draw(texture_table[inventory[i]["id"]],  crafting_x+(i*(inv_slot_width))+10, crafting_y,0, 4, 4)
				love.graphics.print( inventory[i]["count"], crafting_x+(xstep*84)+50, crafting_y+(84*ystep)+64, 0, 1, 1)
			end
			--move to next step
			nextline = nextline + 1
			xstep = xstep + 1
			if nextline >=inventory_size then
				nextline = 0
				ystep = ystep + 1
				xstep = 0
			end
		end
		
		
	end
end

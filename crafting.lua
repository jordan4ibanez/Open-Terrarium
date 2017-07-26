--the crafting library

crafting = {}
crafting_open = false

crafting.craft_size = 3 --number x number

crafting_x = 120
crafting_y = 350

craft_inv_x = 120
craft_inv_y = 50

craft_output_x = 380
craft_output_y = 134

crafting_selection_x = 1
crafting_selection_y = 1

craft_inventory_selection_x = 0
craft_inventory_selection_y = 0

craft_output_selection_x = 0
craft_output_selection_y = 0

crafting.craft_inventory = {}

crafting.held_item = {}

--create output inventory
crafting.output_inventory = {}
crafting.output_inventory[1] = {}

--create crafting inventory
for i = 1,crafting.craft_size*crafting.craft_size do
	crafting.craft_inventory[i] = {}
end

--draw entire inventory
function crafting.render_crafting()
	if crafting_open == true then
		--draw output table
		love.graphics.draw(inventory_slot,  craft_output_x, craft_output_y,0, 1, 1)
		
		--draw output selection
		if craft_output_selection_x > 0 and craft_output_selection_y > 0 then
			love.graphics.draw(inventory_slot_selection, craft_output_x, craft_output_y,0, 1, 1)
		end
		
		--draw output item
		if crafting.output_inventory[1]["id"] then
			love.graphics.draw(texture_table[crafting.output_inventory[1]["id"]],  craft_output_x+10, craft_output_y+10,0, 4, 4)
			--love.graphics.draw(texture_table[inventory[i]["id"]],  crafting_x+(i*(inv_slot_width))+10, crafting_y,0, 4, 4)
			love.graphics.print( crafting.output_inventory[1]["count"], craft_output_x+50, craft_output_y+64, 0, 1, 1)
		end
		----------------------------------
		--draw crafting table
		local xstep = 0
		local ystep = 0
		local nextline = 0
		for i = 1,table.getn(crafting.craft_inventory) do
			--print(i)
			love.graphics.draw(inventory_slot,  craft_inv_x+(xstep*84), craft_inv_y+(84*ystep),0, 1, 1)
			--move to next step
			nextline = nextline + 1
			xstep = xstep + 1
			if nextline >=crafting.craft_size then
				nextline = 0
				ystep = ystep + 1
				xstep = 0
			end
		end
		--draw craft selection
		if craft_inventory_selection_x > 0 and craft_inventory_selection_y > 0 then
			love.graphics.draw(inventory_slot_selection,  ((craft_inventory_selection_x-1)*84)+craft_inv_x, ((craft_inventory_selection_y-1)*84)+craft_inv_y,0, 1, 1)
		end
		--draw items
		local xstep = 0
		local ystep = 0
		local nextline = 0
		for i = 1,table.getn(crafting.craft_inventory ) do
			--print(inventory[i]["id"])
			--texture_table[loaded_chunks[xx][yy][x][y]["block"]]
			--love.graphics.draw(texture_table[inventory[i]["id"]],  drawx,drawy,0, scale/16, scale/16)
			if crafting.craft_inventory[i]["id"] then
				love.graphics.draw(texture_table[crafting.craft_inventory[i]["id"]],  craft_inv_x+(xstep*84)+10, craft_inv_y+(84*ystep)+10,0, 4, 4)
				--love.graphics.draw(texture_table[inventory[i]["id"]],  crafting_x+(i*(inv_slot_width))+10, crafting_y,0, 4, 4)
				love.graphics.print( crafting.craft_inventory[i]["count"], craft_inv_x+(xstep*84)+50, craft_inv_y+(84*ystep)+64, 0, 1, 1)
			end
			--move to next step
			nextline = nextline + 1
			xstep = xstep + 1
			if nextline >=crafting.craft_size  then
				nextline = 0
				ystep = ystep + 1
				xstep = 0
			end
		end		
	
	
		--------------------------------
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
		
		--draw items
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

old_left_mouse = false
old_selected_slot = 0
selected_slot = 0
function crafting.move_items()
	local left = love.mouse.isDown(1)
	local right = love.mouse.isDown(2) --split stack in half
	
	--left click
	if crafting_open == true then
		if left and old_left_mouse == false then
			--the full inventory
			if crafting_selection_x > 0 and crafting_selection_y > 0 then
				crafting.left_click(crafting_selection_x,crafting_selection_y,inventory,inventory_size,true)
				
			--the crafting inventory
			elseif craft_inventory_selection_x > 0 and craft_inventory_selection_y > 0 then

				crafting.left_click(craft_inventory_selection_x,craft_inventory_selection_y,crafting.craft_inventory,crafting.craft_size,true)

			
			--only allow grabbing from output
			elseif craft_output_selection_x > 0 and craft_output_selection_y > 0 then
				crafting.left_click(craft_output_selection_x,craft_output_selection_y,crafting.output_inventory,1,false)				
			end
			
			
		--right click
			
		--place 1 or split stack
		elseif right and old_right_mouse == false then
			--the full inventory
			if crafting_selection_x > 0 and crafting_selection_y > 0 then
				--print("full")
				if not crafting.held_item["id"] then
					crafting.held_item["id"] = inventory[crafting_selection_x + ((crafting_selection_y-1) * inventory_size)]["id"]
					crafting.held_item["count"] = math.floor(inventory[crafting_selection_x + ((crafting_selection_y-1) * inventory_size)]["count"]/2)
					
					inventory[crafting_selection_x + ((crafting_selection_y-1) * inventory_size)]["count"] = math.ceil(inventory[crafting_selection_x + ((crafting_selection_y-1) * inventory_size)]["count"]/2)
				else
					if not inventory[crafting_selection_x + ((crafting_selection_y-1) * inventory_size)]["id"] then
						inventory[crafting_selection_x + ((crafting_selection_y-1) * inventory_size)]["id"] = crafting.held_item["id"]
						inventory[crafting_selection_x + ((crafting_selection_y-1) * inventory_size)]["count"] = 1
					
						crafting.held_item["count"] = crafting.held_item["count"] - 1
					end
				end
				
			--the crafting inventory
			elseif craft_inventory_selection_x > 0 and craft_inventory_selection_y > 0 then

				if not crafting.held_item["id"] then
					--print("inventory")
					--print("nothing here: "..(craft_inventory_selection_x + ((craft_inventory_selection_y-1) * crafting.craft_size)))
					crafting.held_item["id"] = crafting.craft_inventory[(craft_inventory_selection_x + ((craft_inventory_selection_y-1) * crafting.craft_size))]["id"]
					crafting.held_item["count"] = math.floor(crafting.craft_inventory[(craft_inventory_selection_x + ((craft_inventory_selection_y-1) * crafting.craft_size))]["count"]/2)
					crafting.craft_inventory[(craft_inventory_selection_x + ((craft_inventory_selection_y-1) * crafting.craft_size))]["count"] = math.ceil(crafting.craft_inventory[(craft_inventory_selection_x + ((craft_inventory_selection_y-1) * crafting.craft_size))]["count"]/2)
				else
					if not crafting.craft_inventory[(craft_inventory_selection_x + ((craft_inventory_selection_y-1) * crafting.craft_size))]["id"] then
						--print("test2")
						crafting.craft_inventory[(craft_inventory_selection_x + ((craft_inventory_selection_y-1) * crafting.craft_size))]["id"] = crafting.held_item["id"]
						crafting.craft_inventory[(craft_inventory_selection_x + ((craft_inventory_selection_y-1) * crafting.craft_size))]["count"] = 1
						
						crafting.held_item["count"] = crafting.held_item["count"] - 1
					end
				end
			
			--only allow grabbing from output
			elseif craft_output_selection_x > 0 and craft_output_selection_y > 0 then
					if not crafting.output_inventory[(craft_output_selection_x + ((craft_output_selection_y-1) * 1))]["id"] then
						--print("test2")
						crafting.output_inventory[(craft_output_selection_x + ((craft_output_selection_y-1) * 1))]["id"] = crafting.held_item["id"]
						crafting.output_inventory[(craft_output_selection_x + ((craft_output_selection_y-1) * 1))]["count"] = crafting.held_item["count"]
						
						crafting.held_item = {}
					end
				--end
				
			end
		end
	end
	
	old_left_mouse  = left
	old_right_mouse = right
end


--left click mechanic
function crafting.left_click(selectionerx,selectionery,inventory,inventory_width,allow_input)
	local i = selectionerx + ((selectionery-1) * inventory_width)
	--taking
	if not crafting.held_item["id"] then
		crafting.held_item["id"] = inventory[i]["id"]
		crafting.held_item["count"] = inventory[i]["count"]
		inventory[i] = {}
	--placing
	elseif allow_input == true then
		--put in blank slot
		if not inventory[i]["id"] then
			inventory[i]["id"] = crafting.held_item["id"]
			inventory[i]["count"] = crafting.held_item["count"]
			crafting.held_item = {}
		--put into existing
		elseif inventory[i]["id"] == crafting.held_item["id"] then
			--add into
			if inventory[i]["id"] + crafting.held_item["id"] + inventory[i]["id"] <= 64 then
				inventory[i]["id"] = inventory[i]["id"] + inventory[i]["id"] + crafting.held_item["id"]
				crafting.held_item = {}
			end
		--switch
		elseif inventory[i]["id"] ~= crafting.held_item["id"] then
			local temp_held = crafting.held_item
			crafting.held_item = inventory[i]
			inventory[i] = temp_held
		end
	end
end

--right click mechanic
function crafting.right_click(selectionerx,selectionery,inventory,inventory_width,allow_input)

end

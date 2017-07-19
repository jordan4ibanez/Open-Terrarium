--the inventory library

inventory_size = 9

inventory = {}

inventory_selection = 1


--function new_inventory()
	for i = 1,inventory_size do
		inventory[i] = {}
		--if i > table.getn(blocks) then
		--	inventory[i] = {id = i-table.getn(blocks),name = blocks[i-table.getn(blocks)]["name"],image = blocks[i-table.getn(blocks)]["image"],count = 1}
		--else
		--	inventory[i] = {id = i,name = blocks[i]["name"],image = blocks[i]["image"],count = 1}
		--end
	end
--end
--new_inventory()

function inventory_add(item)
	--add the item 
	--for slot,table in pairs(inventory) do
	for i = 1,table.getn(inventory) do
		local table = inventory[i]
		if table["id"] == item and table["count"] < 64 then
--			print("HERE")
			inventory[i]["count"] = inventory[i]["count"] + 1
			return
		end
	end
	--else create new slot
	--for slot,table in pairs(inventory) do
	for i = 1,table.getn(inventory) do
		local table = inventory[i]
		if not table["id"] then
			inventory[i] = {id = item, name = blocks[item]["name"], image = blocks[item]["image"], count = 1}
			return
		end
	end
end

function inventory_remove(slot,item)
	if slot and inventory[slot]["count"] then
		
		inventory[slot]["count"] = inventory[slot]["count"] - 1
		
		if inventory[slot]["count"] <= 0 then
			inventory[slot] = {}
		end
	end
	--0for slot,table in pairs(inventory) do
	--	if table["id"] == item then
	--		print("HERE")
	--		inventory[slot]["count"] = inventory[slot]["count"] + 1
	--		break
	--	end
	--end
end

function load_inventory_textures()
	inventory_slot = love.graphics.newImage("textures/inventory.png")
	inventory_slot_selection = love.graphics.newImage("textures/inventory_selection.png")
	inv_slot_width,inv_slot_height = inventory_slot:getDimensions( )
	
	inventory_x = 250
	inventory_y = love.graphics.getHeight( ) - (inv_slot_height/2)
	
end


--scroll through the inventory
function love.wheelmoved(x, y)

	y = -y
	
	inventory_selection = inventory_selection + y
	
	if inventory_selection < 1 then
		inventory_selection = inventory_selection + table.getn(inventory)
	elseif inventory_selection > table.getn(inventory) then
		inventory_selection = inventory_selection - table.getn(inventory)
	end

end


function render_inventory()
	--draw inventory
	for i = 1,table.getn(inventory) do
		love.graphics.draw(inventory_slot,  inventory_x+(i*(inv_slot_width/2)), inventory_y,0, 1/2, 1/2)
	end
	--draw selection
	
	love.graphics.draw(inventory_slot_selection,  inventory_x+(inventory_selection*(inv_slot_width/2)), inventory_y,0, 1/2, 1/2)
	
	for i = 1,table.getn(inventory) do
		--print(inventory[i]["id"])
		--texture_table[loaded_chunks[xx][yy][x][y]["block"]]
		--love.graphics.draw(texture_table[inventory[i]["id"]],  drawx,drawy,0, scale/16, scale/16)
		if inventory[i]["id"] then
			love.graphics.draw(texture_table[inventory[i]["id"]],  inventory_x+(i*(inv_slot_width/2))+5, inventory_y+4,0, 1*2.1, 1*2.1)
			love.graphics.print( inventory[i]["count"], inventory_x+(i*(inv_slot_width/2))+22, inventory_y+28, 0, 1, 1)
		end
	end
	
end

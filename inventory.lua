--the inventory library

inventory_size = 9

inventory = {}

inventory_selection = 1


for i = 1,inventory_size do
	if i > table.getn(ore) then
		inventory[i] = {tabler = "ore",id = i-table.getn(ore),name = ore[i-table.getn(ore)]["name"],image = ore[i-table.getn(ore)]["image"]}
	else
		inventory[i] = {tabler = "ore",id = i,name = ore[i]["name"],image = ore[i]["image"]}
	end
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
		if inventory[i]["tabler"] == "ore" then
			--love.graphics.draw(texture_table[inventory[i]["id"]],  drawx,drawy,0, scale/16, scale/16)
			love.graphics.draw(texture_table[inventory[i]["id"]],  inventory_x+(i*(inv_slot_width/2))+5, inventory_y+4,0, 1*2.1, 1*2.1)
		end
	end
	
end

--the inventory library

inventory_size = 9

inventory = {}

inventory_selection = 1


for i = 1,inventory_size do
	inventory[i] = ""
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
	
end

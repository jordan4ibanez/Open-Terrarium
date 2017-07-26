--block definitions
blocks = {
	{name = "air", image = "air.png", collide = false},   --id 1
	{name = "rock", image = "stone.png"}, --id 2
	{name = "dirt", image = "dirt.png"},    --id 3
	{name = "grass", image = "grass.png"},   --id 4
	{name = "water", image = "water.png", prop = "liquid", collide = false,water = true, placeable = true,mineable = false}, --id 5
	{name = "leaves", image = "leaves.png"},   --id 6
	{name = "tree", image = "tree.png", drop = 7, drop_amount = 1},   --id 7
	{name = "wood", image = "wood.png"},   --id 8
	
}

items = {
	{name = "air", image = "air.png", collide = false},   --id 1
}

--lighting


--schematics
--by hand for now, create utility to make schems, or program it into creative mode

--6 leaves
--7 tree

--hold the library
schematics = {}

--load up schems while generating
function schematics.load(tiles,x,y,schem)
	---print("loading shcematic "..[[schem]])
	xsch = 0
	ysch = 0
	for xerr = x-schem.sizex,x+schem.sizex do
		xsch = xsch + 1
		print(xsch)
		ysch = 0
		for yerr = y-schem.sizey+1,y do
			ysch = ysch + 1
			--print(yerr)
			if xerr >= 1 and xerr <= map_max then
			if yerr >= 1 and yerr <= map_max then
				if not tiles[xerr] then
					tiles[xerr] = {}
				end
				if not tiles[xerr][yerr] then
					tiles[xerr][yerr] = {}
				end
				--print(schem[xsch])
				--print(ysch)
				--print(schem[xsch][ysch]["block"])
				tiles[xerr][yerr]["block"] = schem[xsch][ysch]["block"]
			end
			end
		end
	end
	
	return(tiles)
end

--x6  X  y5
tree_schem = {sizex = 2,sizey = 5,
[1]=
{
[1]={block=6,},
[2]={block=6,},
[3]={block=6,},
[4]={block=1,},
[5]={block=1,},
},

[2]=
{
[1]={block=6,},
[2]={block=6,},
[3]={block=6,},
[4]={block=1,},
[5]={block=1,},
},

[3]=
{
[1]={block=6,},
[2]={block=6,},
[3]={block=7,},
[4]={block=7,},
[5]={block=7,},
},

[4]=
{
[1]={block=6,},
[2]={block=6,},
[3]={block=6,},
[4]={block=1,},
[5]={block=1,},
},

[5]=
{
[1]={block=6,},
[2]={block=6,},
[3]={block=6,},
[4]={block=1,},
[5]={block=1,},
},

}

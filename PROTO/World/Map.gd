
extends TileMap


var Cores = []

var Cells = {}
var Frontiers = []

var FULL = false

var land_mass = 0.75

onready var max_tiles = int(pow((get_parent().WORLD_EXTENTS.y*2)/64,2)*land_mass)
var tiles_filled = 0

func set_cores():
	for p in get_parent().pos:
		var mp = world_to_map(p)
		set_cell(mp.x,mp.y,0)
		Cores.append(mp)
		get_parent().Fiefs.append({'tiles': []})

	var team = 0
	for core in Cores:
		var N = get_neighbors(core)
		for n in N:
			
			claim_land(n,team)
			
		team += 1
	
	get_node('Timer').start()

func grow():
	if tiles_filled >= max_tiles:
		FULL = true
	var R = randi() % Frontiers.size()
	var cell = Frontiers[R]
	
	var N = get_neighbors(cell)
	

	
	for n in N:
		var surround = true
		if not n in Cells:
			if in_bounds(n):
				surround = false
				claim_land(n,Cells[cell])
		else:
			if Cells[cell] != Cells[n] and !cell.distance_to(n) >= 64.1:
				draw_border(cell,n)
		
		if surround:
			if cell in Frontiers:
				Frontiers.remove(Frontiers.find(cell))


func fill_water():
	print("Filling Oceans..")
	var l = get_parent().WORLD_EXTENTS/64
	for x in range(l.x-3,l.y+4):
		for y in range(l.x-3,l.y+4):
			var pos = Vector2(x,y)
			if not pos in Cells:
				claim_water(pos)
	print("DONE!")
	
func clean_borders():
	print("Cleaning Borders..")
	for cell in Cells:
		if Cells[cell] >= 0:
			var N = get_neighbors(cell)
			for n in N:
				if n in Cells:
					if Cells[cell] != Cells[n] and !cell.distance_to(n) >= 64.1:
						draw_border(cell,n)
	print("DONE!")
	

func in_bounds(pos):
	var l = (get_parent().WORLD_EXTENTS/64)+Vector2(-3,3)
	return pos.x > l.x and pos.x < l.y and pos.y > l.x and pos.y < l.y

func get_neighbors(pos):
	return [
		Vector2(pos.x,pos.y-1),
		Vector2(pos.x+1,pos.y-1),
		Vector2(pos.x+1,pos.y),
		Vector2(pos.x+1,pos.y+1),
		Vector2(pos.x,pos.y+1),
		Vector2(pos.x-1,pos.y+1),
		Vector2(pos.x-1,pos.y),
		Vector2(pos.x-1,pos.y-1)]


func claim_land(pos,team):
	set_cell(pos.x,pos.y,1)
	Cells[pos] = team
	get_parent().Fiefs[team].tiles.append(pos)
	if not pos in Frontiers:
		Frontiers.append(pos)
	tiles_filled += 1
	print(tiles_filled,'/',max_tiles)


func claim_water(pos):
	set_cell(pos.x,pos.y,3)
	Cells[pos] = -1

func draw_border(pos1,pos2):
	set_cell(pos1.x,pos1.y,2)
	set_cell(pos2.x,pos2.y,2)

func _ready():
	clear()


func _on_Timer_timeout():
	if not FULL:	grow()
	else:	
		get_node('Timer').stop()
		print('DONE')
		clean_borders()
		fill_water()
		#get_parent().generate_towns()
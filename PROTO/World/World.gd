
extends Node2D

const BLACK = Color(0,0,0)
const GREY = Color(0.5,0.5,0.8)

const NUM_TOWNS = 100

const WORLD_EXTENTS = Vector2(-4000,4000)



var pos = []

var Fiefs = []

var Towns = []

func _ready():
	randomize()
	generate_fiefs()



func generate_fiefs():
	pos.clear()
	var N = 0
	while N < NUM_TOWNS:
		var Rx = rand_range(WORLD_EXTENTS.x, WORLD_EXTENTS.y)
		var Ry = rand_range(WORLD_EXTENTS.x, WORLD_EXTENTS.y)
		var P = Vector2(Rx,Ry)
		var passed = true
		for p in pos:
			if p.distance_to(P) < 256:
				passed = false
		if passed:
			pos.append(P)
			N += 1
	
	get_node('Map').set_cores()

	

func generate_towns():
	for fief in Fiefs:
		var num_tiles = fief.tiles.size()
		var N = clamp(num_tiles/32,4,8)
		while N >= 0:
			var R = randi() % num_tiles
			var cell = fief.tiles[R]
			if not cell in Towns:
				var passed = true
				for pos in Towns:
					if get_node('Map').map_to_world(cell).distance_to(pos) < 128:
						passed = false
				if passed:
					Towns.append(get_node('Map').map_to_world(cell)+Vector2(32,32))
					N -= 1

		for p in Towns:
			var core = preload('res://World/Core.tscn').instance()
			get_node('Cores').add_child(core)
			core.set_pos(p)
	
	for tile in Fiefs[0].tiles:
		get_node('Territory').set_cell(tile.x,tile.y,4)
		
			
func _draw():
	for p in pos:
		draw_circle(p,32,GREY)
		draw_circle(p,16,BLACK)





extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	for fief in get_children():
		if fief.name == 'RAND':
			fief.set('name', NameGen.GetName())
			for town in fief.get_children():
				if town extends Position2D:
					if town.name == 'RAND':
						town.set('name', NameGen.GetName())


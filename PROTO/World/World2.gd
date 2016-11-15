
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	var first_town = get_node('Fiefs/Fief/TownCore4')
	get_node('UI/frame/Info/box').set('town', first_town)
	get_node('Viewer').set_pos(first_town.get_global_pos())
	
	get_node('Players/Player 1').claim_town(first_town)


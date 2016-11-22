
extends Control

signal name_changed(who)

export(String) var name = "This Land" setget _set_name

func _set_name(what):
	if what != name:
		name = what
		emit_signal('name_changed',self)

func _ready():
	var first_town = get_node('Fiefs/Fief/TownCore4')
	get_node('UI/frame/Info/box').set('town', first_town)
	get_node('Viewer').set_pos(first_town.get_global_pos())
	
	get_node('Players/Player 1').claim_town(first_town)



extends Node

signal player_name_changed(who)
signal player_color_changed(who)
signal town_claimed(who,town)



export(String) var player_name = "Player" setget _set_player_name

export(Color, RGB) var player_color = Color(1,0,1) setget _set_player_color


var claimed_towns = []




func _set_player_name(what):
	player_name = what
	emit_signal('player_name_changed', self)

func _set_player_color(what):
	player_color = what
	emit_signal('player_color_changed',self)



func claim_town(town):
	claimed_towns.append(town)
	town.set('claimant', self)
	emit_signal('town_claimed',self,town)

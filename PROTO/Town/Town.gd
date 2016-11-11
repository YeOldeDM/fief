
extends Node2D
tool

signal importing(to,from)
signal exporting(to,from)
signal level_up(from)
signal level_down(from)
signal changed_produced_resource(from)

onready var NameLabel = get_node('Name')
onready var LevelLabel = get_node('Level')
onready var TownButton = get_node('Button')

export (String) var town_name = "SomeName" setget _set_name





export (int,-1,5) var level = 0 setget _set_level

export (String, \
		"FOOD","LABOR",\
		"WOOD","STONE","ORE",\
		"FAITH") var produced_resource = "FOOD" setget _set_produced_resource


var importing = []
var exporting = null

# Public Methods
func set_name(what):
	set('name', what)

func set_resource(what):
	set('resource', what)

func get_available_resources():
	var from_imports = get_imported_resources()
	if can_produce():
		from_imports.append(get_produced_resource())
	
	return from_imports

func get_imported_resources():
	return []

func get_produced_resource():
	return get_node('/root/Resources').get(produced_resource)

func can_produce():
	return not exporting and get_produced_resource().tier <= level


func import_resource(from):
	emit_signal("importing",self,from)

func export_resource(to):
	emit_signal("exporting",to,self)

# Private Methods

func _set_name(text):
	if is_inside_tree():
		town_name = text
		NameLabel.set_text(town_name)

func _set_level(value):
	if is_inside_tree():
		if value < level:
			emit_signal("level_down",self)
		elif value < level:
			emit_signal("level_up",self)
		level = value
		if TownButton:
			TownButton.set_normal_texture(load('res://Town/town_marker_'+str(level)+'.png'))
		if LevelLabel:
			var lvl = str(level)
			if level == -1:
				lvl = "u"
			LevelLabel.set_text(lvl)

func _set_produced_resource(value):
	if is_inside_tree():
		produced_resource = value
		emit_signal("changed_produced_resource",self)


func _ready():
	set('town_name', town_name)
	set('level', level)
	set('produced_resource', produced_resource)

func _enter_tree():
	NameLabel = get_node('Name')
	LevelLabel = get_node('Level')
	TownButton = get_node('Button')
	set('town_name', town_name)
	set('level', level)

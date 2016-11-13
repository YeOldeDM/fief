
extends Control
tool



#################
#	SIGNALS		#
signal name_changed(name)
signal town_added(town)
signal town_removed(town)
signal capitol_set(town)
signal barony_set(town,barony)





#################
#	PARAMETERS	#

# Fief Name
export(String) var name = "RAND" setget _set_name





#################
#	MEMBERS		#

# Towns of the Fief
var towns = []

# Neighboring Fiefs
var neighboring_fiefs = []

# Fiefs reachable by water
var water_lanes = []

# Capitol of the Fief (if one)
var capitol = null setget _set_capitol
var barony = null setget _set_barony






#################
#	SETTERS		#
func _set_name(value):
	if name == value: return
	name = value
	get_node('Label').set_text(name)
	emit_signal('name_changed',name)

func _set_capitol(value):
	if capitol == value: return
	capitol = value
	emit_signal('capitol_set', capitol)

func _set_barony(value):
	if barony == value: return
	barony = value






#################
#	PUBLIC FUNC	#

func add_town(town):
	assert not town in towns
	towns.append(town)
	emit_signal('town_added', town)

func remove_town(town):
	assert town in towns
	towns.remove(towns.find(town))
	emit_signal('town_removed', town)

func set_capitol(town):
	set('capitol',town)

func get_capitol():
	return capitol

func clear_capitol():
	set('capitol', null)

func get_towns():
	return get('towns')

func set_barony(what):
	set('barony', what)
	emit_signal('barony_set',self, what)

func get_barony():
	return get('barony')




func _ready():
	pass
	#set_name(NameGen.GetName())
	
#	for node in get_children():
#		if node extends Position2D:
#			if node.name == 'YeOldeTowne':
#				node.set('name', NameGen.GetName())
#
#			add_town(node)
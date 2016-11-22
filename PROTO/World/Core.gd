
extends Position2D
tool

#################
#	SHORTCUTS	#
onready var UI = get_node('/root/World/UI/frame/Info/box')



#################
#	CONSTANTS	#
const FOOD = 'food.png'
const LABOR = 'labor.png'
const FORESTRY = 'forestry.png'
const FAITH = 'faith.png'
const STONE = 'stone.png'
const ORE = 'mine.png'
const LUMBER = 'lumber.png'
const MASONRY = 'masonry.png'
const METALWORKS = 'metalworks.png'

const upgrade_requirements = [
		[{'special':'food_source'}, {'special': 'labor_source'}],
		[{'special':'food_source'}, {'tier':1}],
		[{'tier':1}, {'tier':2}],
		[{'special':'labor_source'}, {'tier':2}, {'tier':3}],
		[{'tier':1}, {'tier':2}, {'tier':3}, {'tier':4}]
		]



#############
#	SIGNALS	#
signal resources_changed()
signal name_changed()
signal level_changed()
signal production_changed()
signal population_changed()
signal population_full()
signal population_empty()

signal import_changed()
signal export_changed()

signal claimant_changed()





#############
#	PARAMS	#

# Town Name
export (String) var name = "RAND" setget _set_name

# Team Color (testing)
export (Color, RGB) var team_color = Color(0.5,0.5,0.5) setget _set_team_color

# Town Level
export (int, -1, 5) var level = 0 setget _set_level

# Production Resource of this Town
export (String,\
	"FOOD","LABOR","FORESTRY","FAITH","STONE","ORE",\
	"LUMBER", "MASONRY", "METALWORKS"\
	) var produces = "FOOD" setget _set_produces




#############
#	MEMBERS	#

# Importing from towns  dict:{town:resource}
var importing = []

# Exporting (town)
var exporting = null

# Town Population
var population = 1 setget _set_population

# Town Max Population
var max_pop = 10 setget _set_max_pop

# Seconds it takes to gain 1 population
var pop_growth_time = 1.25 setget _set_pop_growth_time

var claimant = null setget _set_claimant





#################
#	CHECKERS	#
func can_colonize():
	return population >= 10

func is_population_full():
	return population == max_pop

func is_overpopulated():
	return population > max_pop

func is_population_empty():
	return population <= 0
#######################








#############
# SETTERS	#


func _set_pop_growth_time(value):
	pop_growth_time = value
	get_node('PopulationTimer').set_wait_time(pop_growth_time)


func _set_population(value):
	population = max(0,value)
	emit_signal('population_changed')
	if population == 0:
		emit_signal('population_empty')
	elif population >= max_pop:
		emit_signal('population_full')
	
	if not is_population_full() or is_overpopulated():
		if not get_node('PopulationTimer').is_active():
			get_node('PopulationTimer').start()
			print(name+" starts growing population!")


func _set_max_pop(value):
	if max_pop != value:
		max_pop = value
		emit_signal('population_changed')


func _set_level(value):
	if value != level:
		level = value
		_set_level_label(level)
		_set_button(level)
		emit_signal('level_changed')
		var Pops = [0,10,30,50,80,100,150]
		set('max_pop', Pops[level+1])


func _set_name(value):
	if value != name:
		name = value
		if has_node('Name'):
			get_node('Name').set_text(name)
		emit_signal('name_changed')


func _set_produces(value):
	if value != produces:
		emit_signal('production_changed')
		produces = value
		if has_node('Product'):
			if produces:
				get_node('Product').set_texture(load('res://resources/'+get(produces)))


func _set_team_color(color):
	team_color = color
	if team_color != null:
		if has_node('Button'):
			get_node('Button').set_modulate(team_color)
		if has_node('Name'):
			get_node('Name').set('custom_colors/font_color', team_color)
		if has_node('Level'):
			get_node('Level').set('custom_colors/font_color', team_color)


func _set_level_label(value):
	if has_node('Level'):
		if value < 0:
			value = "u"
		get_node('Level').set_text(str(value))


func _set_button(value):
	var img_name = 'town_marker_'+str(value)+'.png'
	var img = load('res://Town/'+img_name)
	if img:
		if has_node('Button'):
			get_node('Button').set_normal_texture(img)


func _set_claimant(who):
	claimant = who
	set('team_color', claimant.player_color)
	emit_signal("claimant_changed")
################



#############
#	PUBLIC	#

func add_population(amt):
	set('population', amt+population)


func kill_population(amt):
	set('population', population-amt)


func get_producing_resource():
		var product = get_node('ResourceRef').get(produces)
		product.owner = self
		return product


func can_produce():
	# return OK if all requirements are met, or a list of errors if not
	var product = get_producing_resource()
	var town_lvl = product.tier <= level	#Resource Tier is equal/lower than Town lvl
	var town_pop = product.tier+1 <= population	# Town needs Tier+1 population to produce
	
	if town_lvl:
		return OK
	else:
		var err = []
		if not town_lvl:
			err.append('LowLvl')
		if not town_pop:
			err.append('LowPop')
		
		return err


# Return a list of all resources available to this Town
func get_available_resources():
	
	var list = []
	# Add our resource if available..
	if not exporting:
		if can_produce()==OK:
			list.append(self.get_producing_resource())
	
	# Add resource of all importers (if available)
	for i in importing:
		if i.can_produce()==OK:
			list.append(i.get_producing_resource())
	
	# Return the full list
	return list



func get_requirements(for_lvl=1):
	var list = []
	for i in range(0, for_lvl):
		var reqs = upgrade_requirements[i]
		for r in reqs:
			list.append(r)

	return list


func check_requirements(req_list):
	# Check requirements list against available resources
	# remove met requirements, return modified requirements list
	# if returns empty array, all requirements are met!
	var res = get_available_resources()
	
	# List has

	for r in res:
		if r != null:
			print(name+" HAS "+r.name)
	# List needs

	for r in req_list:
		if r != null:
			print(name+" NEEDS "+str(r))
	
	var req_met = []
	# Check resources against needs
	for r in req_list:
		print("CHECKING FOR "+str(r))
		if 'special' in r:
			for itm in res:
				if itm != null:
					if itm.owner!=self and r.special in itm.special:
						print(name+" FOUND "+itm.name)
						res.remove(res.find(itm))
						req_met.append(r)
						break
		elif 'tier' in r:
			for itm in res:
				if itm != null:
					if itm.owner!=self and r.tier <= itm.tier:
						print(name+" FOUND A TIER "+str(r.tier)+" RESOURCE!")
						res.remove(res.find(itm))
						req_met.append(r)
						break



	for r in req_list:
		if not r in req_met:
			print(name+" STILL NEEDS "+str(r))


	
	for itm in req_met:
		req_list.erase(itm)
	
	return req_list


func check_for_level_change():
	var reqs = check_requirements(get_requirements(level+1))
	if reqs.empty():
		set('level', level+1)
	else:
		var reqs = check_requirements(get_requirements(level))
		if not reqs.empty():
			set('level', max(0,level-1))
	
	if UI.town == self:
		UI.update_info()

##################




#############################
#	IMPORT/EXPORT FUNCTION	#


func add_import(from):
	assert not from in importing
	
	importing.append(from)
	print(name+" begins importing "+from.get_producing_resource().name+" from "+from.name)
	emit_signal('resources_changed')
	emit_signal('import_changed')


func remove_import(from):
	assert from in importing
	
	importing.erase(from)
	print(name+" stops importing "+from.get_producing_resource().name+" from "+from.name)
	emit_signal('resources_changed')
	emit_signal('import_changed')


func set_export(to):
	if exporting:
		exporting.remove_import(self)
	if not exporting:
		emit_signal('resources_changed')
	exporting = to
	to.add_import(self)
	emit_signal('export_changed')

func cancel_export():
	if exporting:
		emit_signal('resources_changed')
		exporting.remove_import(self)
	exporting = null
	emit_signal('export_changed')
##############################




#############		
#	INIT	#
func _ready():
	connect("resources_changed", self, "_on_resources_changed")
	connect("level_changed", self, "_on_level_changed")
	set('population', population)

	
#############







#########################
#	TRADELANE FUNCTIONS	#

# Connect the Lane to a position in space
func set_lane(to_pos):
	if has_node('TradeLane'):
		var A = to_pos.angle_to_point(get_global_pos())
		get_node('TradeLane').set_rot(A)
		var D = get_global_pos().distance_to( to_pos )
		get_node('TradeLane').set_scale(Vector2(0.5,D/128))
		get_node('TradeLane/Animator').set_speed(min(1.0, 1.0/(D/30)))


# Return the Lane to its proper position
func reset_lane():
	if has_node('TradeLane'):
		if exporting:
			set_lane(exporting.get_global_pos())
		else:
			set_lane(get_global_pos())
###########################








#########################
#	SIGNAL CALLBACKS	#
func _on_Button_pressed():
	UI.set('town',self)


func _on_resources_changed():
	check_for_level_change()

	if exporting:
		exporting.check_for_level_change()


func _on_level_changed():
	#if not is_population_full():
	get_node('PopulationTimer').start()


func _on_PopulationTimer_timeout():
	if is_overpopulated():
		kill_population(1)
	else:
		if is_population_full():
			get_node('PopulationTimer').stop()
		else:
			add_population(1)
#########################

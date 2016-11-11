
extends VBoxContainer

var town = null setget _set_town

func _ready():
	pass




#################
#	SETTERS		#
func _set_town(value):
	# disconnect signals to old town
	if town != null:
		town.disconnect("name_changed", self, "_on_town_name_changed")
		town.disconnect("level_changed", self, "_on_town_level_changed")
		town.disconnect("production_changed", self, "_on_town_production_changed")
		town.disconnect("resources_changed", self, "_on_town_resources_changed")
		town.disconnect("population_changed", self, "_on_town_population_changed")
		town.disconnect("import_changed", self, "_on_town_import_changed")
		town.disconnect("export_changed", self, "_on_town_export_changed")
	
	# break if no new town
	if value == null:
		return
	
	# set it
	town = value
	
	# connect signals to new town
	town.connect("name_changed", self, "_on_town_name_changed")
	town.connect("level_changed", self, "_on_town_level_changed")
	town.connect("production_changed", self, "_on_town_production_changed")
	town.connect("resources_changed", self, "_on_town_resources_changed")
	town.connect("population_changed", self, "_on_town_population_changed")
	town.connect("import_changed", self, "_on_town_import_changed")
	town.connect("export_changed", self, "_on_town_export_changed")
	
	# update everything
	update_info()

##################################




#####################
# SIGNAL CALLBACKS	#
func _on_town_name_changed():
	get_node('Name/NameLabel').set_text(town.name)

func _on_town_level_changed():
	get_node('level').set_text("Level "+str(town.level))
	get_node('NeedsLabel').set_text("Resources needed for level "+str(town.level+1))
	draw_needed_resources()

func _on_town_production_changed():
	get_node('produces').set_text("producing "+town.get_producing_resource().name)

func _on_town_resources_changed():
	draw_available_resources()

func _on_town_population_changed():
	var pop = str(town.population*0.1).pad_decimals(1)
	var maxpop = str(town.max_pop*0.1).pad_decimals(1)
	get_node('population').set_text('Pop.: '+pop+'/'+maxpop)

func _on_town_import_changed():
	draw_available_resources()
	var import_txt = ""
	for key in town.importing:
		import_txt += " "+key.name+": "+str(key.get_producing_resource().name)
	get_node('imports').set_text("Importing from: "+import_txt)
	draw_needed_resources()

func _on_town_export_changed():
	draw_available_resources()
	var export_txt = ""
	if town.exporting:
		export_txt = town.exporting.name
	get_node('exports').set_text("Exporting to: "+export_txt)
	draw_needed_resources()

func _on_RenameButton_pressed():
	assert town != null
	if get_node('Name/NameLabel/NameEdit').is_hidden():
		get_node('Name/NameLabel').set_text('')
		get_node('Name/NameLabel/NameEdit').set_text(town.name)
		get_node('Name/NameLabel/NameEdit').show()
		get_node('Name/NameLabel/NameEdit').grab_focus()
	else:
		_on_NameEdit_text_entered(get_node('Name/NameLabel/NameEdit').get_text())

func _on_NameEdit_text_entered( text ):
	assert town != null
	town.set('name',text)
	get_node('Name/NameLabel/NameEdit').hide()

########################################




#####################
#	PUBLIC FUNCS	#

# clear icons to re-draw
func clear_available_grid():
	while get_node('Available').get_child_count() > 0:
		get_node('Available').remove_child(get_node('Available').get_child(0))

# clear icons to re-draw
func clear_needslist():
	while get_node('Needs').get_child_count() > 0:
		get_node('Needs').remove_child(get_node('Needs').get_child(0))




# Draw icon list of Resources needed to advance town to the next level
func draw_needed_resources():
	clear_needslist()
	var res = town.check_requirements(town.get_requirements(town.level+1))
	get_node('NeedsLabel').set_text("Resources needed for level "+str(town.level+1))
	for r in res:
		if r != null:
			# new TextureFrame 
			var new_icon = TextureFrame.new()
			new_icon.set_ignore_mouse(false)
			
			# check for Special requirement
			if 'special' in r:
				# if food source
				if r.special == 'food_source':
					# get food icon
					new_icon.set_texture(load('res://resources/food.png'))
					# tooltip
					
					new_icon.set_tooltip("Import a FOOD source to this town!")
				
				# if labor source
				elif r.special == 'labor_source':
					# get labor icon
					new_icon.set_texture(load('res://resources/labor.png'))
					# tooltip
					new_icon.set_tooltip("Import a LABOR source to this town!")
			
			# check for Tier requirement
			elif 'tier' in r:
				# get roman numeral icon
				var img = 'roman'+str(r.tier)+'.png'
				new_icon.set_texture(load('res://resources/'+img))
				# tooltip
				new_icon.set_tooltip("Import any TIER "+str(r.tier)+" resource to this town!")
			
			# add the child to the grid
			get_node('Needs').add_child(new_icon)





# Draw icon list of all resources available to town
func draw_available_resources():
	clear_available_grid()
	var res = town.get_available_resources()
	

	for r in res:
		if r != null:
			var new_icon = TextureFrame.new()
			new_icon.set_ignore_mouse(false)
			var own_text = r.owner.name
			if own_text == town.name:
				own_text = "here"
			new_icon.set_tooltip(r.name+" from "+own_text)
			new_icon.set_texture(load('res://resources/'+r.icon))
			get_node('Available').add_child(new_icon)




# Master update func. Called when town is first set.
# Recreate all function from _on_town_***_changed callback funcs
func update_info():
	var res = town.get_producing_resource()
	# draw general info
	get_node('Name/NameLabel').set_text(town.name)
	get_node('level').set_text("Level "+str(town.level))
	get_node('produces').set_text("producing "+res.name)
	
	# make importing text
	var import_txt = ""
	for key in town.importing:
		import_txt += " "+key.name+": "+str(key.get_producing_resource().name)
	# make exporting text
	var export_txt = ""
	if town.exporting:
		export_txt = town.exporting.name
	# draw importing/exporting text
	#get_node('imports').set_text("Importing from: "+import_txt)
	get_node('exports').set_text("Exporting to: "+export_txt)
	
	# draw population info
	var pop = str(town.population*0.1).pad_decimals(1)
	var maxpop = str(town.max_pop*0.1).pad_decimals(1)
	get_node('population').set_text('Pop.: '+pop+'/'+maxpop)
	
	# draw resource grids
	draw_available_resources()
	draw_needed_resources()


############################################

	

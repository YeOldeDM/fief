

extends TextureButton





# All drag data is taken from the parent
onready var me = get_parent()





#############################
#	DRAG-N-DROP FUNCTION	#
func get_drag_data(pos):
	
	# start lane following mouse
	set_process(true)
	# create drag preview object (a copy of produced resource icon)
	var drag_itm = TextureFrame.new()
	if get_parent().produces:
		drag_itm.set_texture(load('res://resources/'+get_parent().get_producing_resource().icon))
	set_drag_preview(drag_itm)
	
	# we are the data being dragged
	return me

func can_drop_data(pos,data_from):
	var can = true
	
	# Can't export to yourself
#	if data_from == me:
#		can = false
	
	# Can't export to exporting
	if me.exporting == data_from:
		can = false
	
	# Can't export to an importer
	if data_from.exporting == me:
		can = false

	return can
	
	
func drop_data(pos,dragged_from):
	#dragged_from = town dragged from
	#me = town dragged to

	# stop lane following mouse
	dragged_from.set_process(false)
	
	# Cancel export if dragged into itself, 
	#or export if dragged into other town
	if dragged_from == me:
		me.cancel_export()
	else:
		dragged_from.set_export(me)
	
	dragged_from.set_lane(me.get_pos())

##############################


# Process: only runs while dragging a valid object
func _process(delta):
	if get_parent().get_parent():
		var pos = get_node('../../').get_local_mouse_pos()
		get_parent().set_lane(pos)

	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		set_process(false)
		get_parent().reset_lane()


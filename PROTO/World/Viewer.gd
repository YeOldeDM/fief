
extends Position2D

onready var Cam = get_node('Camera')

var target_zoom = 20.0
var camspeed = 500
var drag_camspeed = 20

var wheel_state = 0
var drag_state = 0
var drag_origin = null

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				drag_state = 1
				if not drag_origin:
					drag_origin = get_parent().get_global_mouse_pos()
			else:
				drag_state = 0
				drag_origin = null
		if event.button_index == BUTTON_WHEEL_UP:
			wheel_state = 1
		elif event.button_index == BUTTON_WHEEL_DOWN:
			wheel_state = 2

func _fixed_process(delta):
	
	if not drag_state:
		drag_origin = null
	
	# get input
	var UP = Input.is_action_pressed('pan_up')
	var DOWN = Input.is_action_pressed('pan_down')
	var LEFT = Input.is_action_pressed('pan_left')
	var RIGHT = Input.is_action_pressed('pan_right')
	
	var ZOOMIN = Input.is_action_pressed('zoom_in')
	var ZOOMOUT = Input.is_action_pressed('zoom_out')

	# get position
	var pos = get_pos()
	
	var M = camspeed*delta*Cam.get_zoom().x
	var dM = drag_camspeed*delta*max(Cam.get_zoom().x,5.0)
	
	
	if UP and !DOWN:
		pos.y -= M
	elif DOWN and !UP:
		pos.y += M
	if LEFT and !RIGHT:
		pos.x -= M
	elif RIGHT and !LEFT:
		pos.x += M
	

	if drag_state:
		pos -= dM*(get_parent().get_global_mouse_pos()-drag_origin)
		drag_origin = get_parent().get_global_mouse_pos()
	
	if pos != get_pos():
		set_pos(pos)
	
	var new_zoom = target_zoom
	if ZOOMIN or wheel_state == 1:
		new_zoom -= 20*delta

	if ZOOMOUT or wheel_state == 2:
		new_zoom += 20*delta
	new_zoom = clamp(new_zoom,1.0,20.0)
	if new_zoom != camspeed:
		target_zoom = new_zoom
	
	if Cam.get_zoom().x != target_zoom:
		var z = Cam.get_zoom()
		z.x = lerp(z.x,target_zoom,0.1)
		z.y = lerp(z.y,target_zoom,0.1)
		Cam.set_zoom(z)

	wheel_state = 0

extends Position2D

onready var Cam = get_node('Camera')

var target_zoom = 20.0
var camspeed = 500

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):

	var UP = Input.is_action_pressed('pan_up')
	var DOWN = Input.is_action_pressed('pan_down')
	var LEFT = Input.is_action_pressed('pan_left')
	var RIGHT = Input.is_action_pressed('pan_right')
	
	var ZOOMIN = Input.is_action_pressed('zoom_in')
	var ZOOMOUT = Input.is_action_pressed('zoom_out')
	
	var pos = get_pos()
	
	var M = camspeed*delta*Cam.get_zoom().x
	if UP and !DOWN:
		pos.y -= M
	elif DOWN and !UP:
		pos.y += M
	if LEFT and !RIGHT:
		pos.x -= M
	elif RIGHT and !LEFT:
		pos.x += M
	
	if pos != get_pos():
		set_pos(pos)
	
	var new_zoom = target_zoom
	if ZOOMIN:
		new_zoom -= 10*delta

	if ZOOMOUT:
		new_zoom += 10*delta
	new_zoom = clamp(new_zoom,1.0,20.0)
	if new_zoom != camspeed:
		target_zoom = new_zoom
	
	if Cam.get_zoom().x != target_zoom:
		var z = Cam.get_zoom()
		z.x = lerp(z.x,target_zoom,0.1)
		z.y = lerp(z.y,target_zoom,0.1)
		Cam.set_zoom(z)


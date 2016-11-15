
extends Sprite

var target = null

func _ready():
	set_process(true)


func _process(delta):
	if target:
		set_pos(target.get_global_transform_with_canvas().o)

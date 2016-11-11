
extends CanvasLayer

func add_pip(source):
	var pip = preload('res://World/CorePip.tscn').instance()
	pip.set_meta('source',source)
	get_node('Cores').add_child(pip)
	pip.get_node('Sprite').set_modulate(Color(randf(),randf(),randf()))
	print('added core pip')

func _ready():
	set_fixed_process(true)


func _fixed_process(delta):
	for pip in get_node('Cores').get_children():
		var src = pip.get_meta('source')
		if src:
			var pos = src.get_global_transform_with_canvas().o
			pip.set_pos(pos)
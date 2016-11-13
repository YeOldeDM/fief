
extends VBoxContainer

onready var timer = get_node('Timer')

var min_per_month = 0.2	setget _set_min_per_month#minutes per month of game time

var months = [
	'Jan',
	'Feb',
	'Mar',
	'Apr',
	'Jun',
	'Jul',
	'Aug',
	'Sept',
	'Nov',
	'Dec'
	]

var month = int(rand_range(0,11)) setget _set_month
var year = int(rand_range(900,1000)) setget _set_year

func _set_month(value):
	month = value
	if month > months.size()-1: 
		month = 0
		set('year', year+1)
	draw_date()

func _set_year(value):
	year = value
	draw_date()

func _ready():
	_set_min_per_month(min_per_month)
	set_process(true)
	draw_date()

func _process(delta):
	get_node('Bar').set_value(timer.get_time_left())

func _set_min_per_month(value):
	min_per_month = value
	timer.set_wait_time(min_per_month*60)
	get_node('Bar').set_max(timer.get_wait_time())



func draw_date():
	get_node('Label').set_text(months[month]+", "+str(year)+"a.d.")

func _on_Timer_timeout():
	set('month', month+1)

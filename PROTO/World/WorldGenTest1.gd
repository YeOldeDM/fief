
extends TextureFrame



const OCEAN = Color(0,0,0)
const RES = 512
const BUFFER = RES/6
const EROSION_FACTOR = 0.2
const FIEF_COUNT = 180

const LAND_MASS = 0.5

var target_pixels = int((RES*RES)*LAND_MASS)
var current_pixels = 0



var tex = ImageTexture.new()

var fiefs = {}

var edges = Vector2Array()


func _RC():
	return randi()%255

func _ready():
	randomize()
	var img = Image(RES,RES,false,Image.FORMAT_RGB)
	
	while FIEF_COUNT > 0:
		var pos = Vector2(BUFFER+randi()%(RES-(BUFFER*2)), \
						  BUFFER+randi()%(RES-(BUFFER*2)))
			
		if img.get_pixel(pos.x,pos.y) == OCEAN:
			var color = Color8(_RC(),_RC(),_RC())
			
			while color in fiefs:
				color = Color8(_RC(),_RC(),_RC())
			
			fiefs[color] = {'o':pos, 'cells': [pos], 'borders': []}
			img.put_pixel(pos.x,pos.y,color)
			current_pixels += 1
			var nei = get_neighbors(pos)
			
			for pos in nei:
				img.put_pixel(pos.x,pos.y,color)
				edges.append(pos)
				fiefs[color].cells.append(pos)
				current_pixels += 1
			
			FIEF_COUNT -= 1
			
	tex.create_from_image(img)
	set_texture(tex)
	get_node('../UI/Bar').set_max(target_pixels)
	get_node('../Viewer').set_pos(Vector2(1024,1024))

	set_process(true)

func _process(delta):
	if edges.size()==0 or current_pixels >= target_pixels:
		world2png()
		set_process(false)
	else:
		for i in range(5): 
			call_deferred('grow')


func grow():
	
	var img = get_texture().get_data()
	
	var i = randi()%edges.size()
	var pos = edges[i]
	
	var c = img.get_pixel(pos.x,pos.y)
	if c != OCEAN:
		var nei = get_neighbors(pos)
		var keep_edge = false
		
		for p in nei:
			var target_c = img.get_pixel(p.x,p.y)
			if target_c == OCEAN:
				if in_bounds(p) and randf() >= EROSION_FACTOR:
					img.put_pixel(p.x,p.y,c)
					current_pixels += 1
					edges.append(p)
					fiefs[c].cells.append(p)
					keep_edge = true
			else:
				if not target_c in fiefs[c].borders:
					fiefs[c].borders.append(target_c)
					if not c in fiefs[target_c].borders:
						fiefs[target_c].borders.append(c)
		if not keep_edge:
			edges.remove(i)
		
	tex.create_from_image(img)
	
	get_node('../UI/Bar').set_value(current_pixels)
	get_node('../UI/Bar/Count').set_text(str(current_pixels)+' / '+str(target_pixels))


func in_bounds(pos):
	return pos.x >= 0 and pos.x <= RES+1 and pos.y >= 0 and pos.y <= RES+1


func get_neighbors(pos):
	return Vector2Array([
		Vector2(pos.x,pos.y-1),
		Vector2(pos.x+1,pos.y-1),
		Vector2(pos.x+1,pos.y),
		Vector2(pos.x+1,pos.y+1),
		Vector2(pos.x,pos.y+1),
		Vector2(pos.x-1,pos.y+1),
		Vector2(pos.x-1,pos.y),
		Vector2(pos.x-1,pos.y-1)])


func world2png():
	var img = get_texture().get_data()
	img.save_png('res://world_map.png')





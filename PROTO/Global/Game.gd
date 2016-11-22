
extends Node

#	GAME CONTROL SINGLETON

const SAVE_PATH = 'usr://saves/'
const EXT = '.bob'

# Store all global game data under a key.
var data = {
	'filename':	'NOTAGAME'}


# Start a game after loading
func start_game():
	pass


# Begin a fresh new game
func new_game():
	pass


# Save the current game state to file
func game_to_bob(to_path):
	var D = {'data':data}
	
	var file = File.new()
	
	if file.file_exists(to_path):
		return ERR_FILE_CANT_WRITE
	file.open(to_path, File.WRITE)
	
	file.store_line(data.to_json())
	
	file.close()
	return OK

# Return a game state from file
func bob_to_game(from_path):
	var D = {}
	
	var file = File.new()
	
	if !file.file_exists(from_path):
		return ERR_FILE_NOT_FOUND
	file.open(from_path, File.READ)
	
	while !file.eof_reached():
		D.parse_json(file.get_line())
	
	file.close()
	return D


# Quit to Desktop
func quit_game():
	get_tree().quit()
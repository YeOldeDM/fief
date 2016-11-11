
extends Node

#################
#	CONSTANTS	#
const FIEF = -1
const BARONY = 0
const COUNTY = 1
const DUCHY = 2
const GRAND_DUCHY = 3
const KINGDOM = 4
const EMPIRE = 5



class Territory:
	var name
	var type
	var owner
	
	var parent
	var children
	
	var capitol
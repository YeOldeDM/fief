
extends Node

const FOOD = {
	'name':	'Food',
	'tier':	0,
	'icon':	'food.png',
	'special':	[]
	}

const LABOR = {
	'name':	'Labor',
	'tier':	0,
	'icon':	'labor.png',
	'special':	[['buff', 'production']]
	}

const WOOD = {
	'name':	'Wood',
	'tier':	0,
	'icon':	'wood.png',
	'special':	[['buff', 'Lumber']]
	}

const FAITH = {
	'name':	'Faith',
	'tier':	0,
	'icon':	'faith.png',
	'special':	[['buff', 'Influence']]
	}

const STONE = {
	'name':	'Stone',
	'tier':	0,
	'icon':	'stone.png',
	'special':	[['buff','Masonry']]
	}

const ORE = {
	'name':	'Ore',
	'tier':	0,
	'icon':	'ore.png',
	'special':	[['buff','Blacksmith']]
	}


const TOWN_UPGRADE_REQUIREMENTS = [
		[FOOD, LABOR],
		[FOOD, 1],
		[1,2],
		[LABOR, 2,3],
		[3,4],
		[1,2,3,4]
		]
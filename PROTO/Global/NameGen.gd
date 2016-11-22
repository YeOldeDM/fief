
extends Node

const NAMEBASE = "..aei.a.abkelivoexheuntewecajennirsagho.ah"


var tit = [
	'upper',
	'lower',
	'new',
	'old',
	'saint',
	'great',
	'holy',
	]

var pre = [
	'aud',
	'ab',
	'al',
	'ame',
	'ar',
	'aro',
	'bes',
	'bet',
	'nor',
	'norn',
	'wast',
	'wasten',
	'dun',
	'duen',
	'est',
	'esten',
	'hig',
	'pel',
	'dow',
	'hi',
	'ic',
	'ice',
	'iya',
	'iey',
	'low',
	'lo',
	'loen',
	'hro',
	'ho',
	'la',
	'le',
	'lun',
	'lon',
	'brun',
	'har',
	'her',
	'holl',
	'holli',
	'she',
	'sha',
	'shas',
	'loc',
	'the',
	'el',
	'eles',
	'elys',
	'esth',
	'ech',
	'ach',
	'mon',
	'may',
	'men',
	'myn',
	'san',
	'sem',
	'vest',
	'vyn',
	'rem',
	'ren',
	'ry',
	'sco',
	'scy',
	'sky',
	'er',
	'ere',
	'eire',
	'ire',
	'mos',
	'tie',
	'uru',
	'ur',
	'war',
	]

var suff = [
	'berg',
	'burg',
	'dom',
	'dorn',
	'dour',
	'top',
	'crest',
	'ton',
	'hill',
	'vill',
	'shire',
	'lake',
	'wood',
	'bay',
	'bra',
	'bro',
	'o',
	'a',
	'e',
	'en',
	'we',
	'ne',
	'end',
	'wick',
	'wich',
	'kell',
	'dale',
	'dell',
	'del',
	'rel',
	'hol',
	'jei',
	'jor',
	'dern',
	'eck',
	'plain',
	'veil',
	'vell',
	'do',
	'od',
	'ord',
	'orn',
	'sea',
	'ses',
	'ces',
	'pich',
	'pach',
	'mor',
	'moor',
	'mord',
	'wind',
	'wyn',
	'ter',
	'tre',
	'eb',
	'job',
	'tamb',
	'bes',
	'beth',
	'willow',
	'oak',
	'pine',
	'dre',
	]


var ext = [
	"'s Watch",
	"'s Rest",
	" Point",
	" Shore",
	" Bank",
	"'s Respite",
	"'s Hold",
	"'s Hill",
	"'s Rock",
	" Burrow",
	"'s Beacon",
	"'s Ward",
	"'s Fall",
	"'s Fallow",
	" Falls",
	" End",
	]

func rand_choice(list):
	return list[randi()%list.size()]

func GetName():
	randomize()
	
	var title = ''
	var prefix = ''
	var suffix = ''
	var extra = ''
	
	if randf() < 0.2:
		title = rand_choice(tit).capitalize()+' '
	
	prefix = rand_choice(pre)
	if randf() < 0.3:
		var pref2 = rand_choice(pre)
		while pref2 == prefix:
			pref2 = rand_choice(pre)
		prefix += pref2
		if randf() < 0.1 and prefix.length() <= 4:
			prefix += rand_choice(pre)
	if randf() < 0.7 or prefix.length() <= 6:
		suffix = rand_choice(suff)
	if randf() < 0.1:
		extra = rand_choice(ext)
	
	
	return title+prefix.capitalize()+suffix+extra


func GetName2(n=3):
	var name = ''
	for i in range(n):
		name += NAMEBASE[int(randi()%NAMEBASE.length()/2)*2]+NAMEBASE[1+int(randi()%NAMEBASE.length()/2)*2]
	name = name.replace('.','')
	return name.capitalize()


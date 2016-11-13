
extends Node

const NAMEBASE = "..aei.a.abkelivoexheuntewecajennirsagho.ah"


var tit = [
	'upper',
	'lower',
	'new',
	'old',
	'saint',
	'great',
	]

var pre = [
	'aud',
	'ab',
	'wast',
	'dun',
	'est',
	'high',
	'pel',
	'hi',
	'low',
	'lo',
	'hro',
	'ho',
	'la',
	'le',
	'lun',
	'lon',
	'brun',
	'har',
	'her',
	'loc',
	'the',
	'eles',
	'esth',
	'ech',
	'ach',
	'mon',
	'may',
	'men',
	'san',
	'sem',
	'vest',
	'rem',
	'ren',
	'sco',
	'ere',
	'eire',
	'ire',
	'mos',
	'tie',
	'war',
	]

var suff = [
	'berg',
	'burg',
	'top',
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
	'pich',
	'pach',
	'mor',
	'moor',
	'mord',
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
		if randf() < 0.2:
			prefix += rand_choice(pre)
	if randf() < 0.7 or prefix.length() <= 4:
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


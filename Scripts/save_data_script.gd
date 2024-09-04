extends Node

var playerSheet = {}
var characterSheet = {}
var playerName = ""
var run = true

func AddUser(chrname, hitpoints, baseattack, baseblock, abilities):
	characterSheet["name"] = chrname
	characterSheet["hitpoints"] = hitpoints
	characterSheet["baseattack"] = baseattack
	characterSheet["baseblock"] = baseblock
	characterSheet["abilities"] = abilities
	#{"ability1": {"effect": "", "cooldown": ""}, "ability2": {"effect": "", "cooldown": ""}, "ability3": {"effect": "", "cooldown": ""}, "ability4": {"effect": "", "cooldown": ""}}

	playerName = ""
	playerSheet[playerName] = characterSheet
	
	print(playerSheet)

func LoadPlayerSheet():
	var file = FileAccess.open("res://JSON_files/player_sheet.json", FileAccess.READ)
	var readData = file.get_as_text()
	playerSheet = JSON.parse_string(readData)
	return playerSheet
	
func SavePlayerSheet():
	var file = FileAccess.open("res://JSON_files/player_sheet.json", FileAccess.WRITE)
	var writeData = JSON.stringify(playerSheet)
	file.store_string(writeData)
	file = null

func _ready():
	AddUser("Template", "100", "5", "0.5", {"ability1": {"effect": "", "cooldown": ""}, "ability2": {"effect": "", "cooldown": ""}, "ability3": {"effect": "", "cooldown": ""}, "ability4": {"effect": "", "cooldown": ""}}) #{"ability1": {"effect": "", "cooldown": ""}, "ability2": {"effect": "", "cooldown": ""}, "ability3": {"effect": "", "cooldown": ""}, "ability4": {"effect": "", "cooldown": ""}}
	SavePlayerSheet()
	#LoadPlayerSheet()
	#print(playerSheet[playerName]["name"])

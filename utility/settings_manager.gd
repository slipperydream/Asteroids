extends Node

signal settings_reverted

const SETTINGS_FILE_PATH = "res://settings.cfg"

var config = ConfigFile.new()

var settings = {
	"audio" : {
		"master_muted": false,
		"master_volume": -6.0,
		"music_muted": false,
		"music_volume": -6.0,
		"sfx_muted": false,
		"sfx_volume": -6.0,
	},
	"visual": {
		"show_hitboxes": true,
		"bullet_color": Color(Color.ORANGE),
		"player_color": Color(Color.ORANGE),
		"line_width": 5,
		"line_color": Color(Color.WEB_GREEN),
	}
}

func _ready():
	#revert_settings()
	load_settings()
	print(settings)
	
func save_settings():
	for section in settings.keys():
		for key in settings[section]:
			config.set_value(section, key, settings[section][key])
			
	config.save(SETTINGS_FILE_PATH)
	emit_signal("settings_reverted")
	
func load_settings():
	var error = config.load(SETTINGS_FILE_PATH)
	if error != OK:
		print("Error loading settings file. %s" % error)
		return []
		
	for section in settings.keys():
		for key in settings[section].keys():
			settings[section][key] = config.get_value(section, key, null)

func get_settings():
	return settings
	
func get_audio_bus_muted(bus):
	var audio_bus = "%s_muted" % bus.to_lower()
	return settings["audio"][audio_bus]

func set_audio_bus_muted(bus, value):
	var key = "%s_muted" % bus.to_lower()
	settings["audio"][key] = value
	save_settings()
		
func get_audio_bus_volume(bus):
	var audio_bus = "%s_volume" % bus.to_lower()
	return settings["audio"][audio_bus]
	
func set_audio_bus_volume(bus, value):
	var key = "%s_volume" % bus.to_lower()
	settings["audio"][key] = value
	save_settings()
	
func get_line_width():
	return settings["visual"]["line_width"]
	
func set_line_width(value):
	settings["visual"]["line_width"] = value
	save_settings()

func get_bullet_color():
	return settings["visual"]["bullet_color"]

func set_bullet_color(color):
	settings["visual"]["bullet_color"] = color
	save_settings()

func get_line_color():
	return settings["visual"]["line_color"]

func set_line_color(color):
	settings["visual"]["line_color"] = color
	save_settings()
	
func get_player_color():
	return settings["visual"]["player_color"]

func set_player_color(color):
	settings["visual"]["player_color"] = color
	save_settings()

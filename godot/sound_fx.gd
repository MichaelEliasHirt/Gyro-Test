extends Node

const sounds = {
	"Click" : preload("res://assets/godot_mobile_assets/sound/Click.wav"),
	"Fall" :preload("res://assets/godot_mobile_assets/sound/Fall.wav"),
	"Jump" :preload("res://assets/godot_mobile_assets/sound/Jump.wav"),
}

@onready var sound_players = get_children()

func play(sound_name):
	var sound = sounds[sound_name]
	
	for sound_player in sound_players:
		if not sound_player.playing:
			sound_player.stream = sound
			sound_player.play()
			return
			

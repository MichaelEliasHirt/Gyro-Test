extends Node2D

@onready var platform_parent: Node2D = $PlatformParent

@onready var parallax_layer1: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var parallax_layer2: ParallaxLayer = $ParallaxBackground/ParallaxLayer2
@onready var parallax_layer3: ParallaxLayer = $ParallaxBackground/ParallaxLayer3

const PLATFORM_SCENE = preload("res://game/platform.tscn")
const PLAYER_SCENE = preload("res://game/player.tscn")

signal died(score:int,highscore:int)

var viewport_size: Vector2
var platform_size = Vector2(136,65)

var player: CharacterBody2D = null

#Level gen variables
var start_platform_y
var initial_y_distance_between_platforms = 100
var y_distance_between_platforms = initial_y_distance_between_platforms

var player_height = 0
var last_platform_height: int

var running = false

var death_height = 0
var dead = false

var score = 0
var highscore
var save_file_path = "user://highscore.save"

func _ready() -> void:
	# Generate the ground
	viewport_size = Vector2(get_viewport_rect().size)

	$GroundSprite.global_position = Vector2(viewport_size.x/2,viewport_size.y)
	setup_parallax_layer(parallax_layer1)
	setup_parallax_layer(parallax_layer2)
	setup_parallax_layer(parallax_layer3)
	load_score()

func new_game():
	running = true
	$CanvasLayer/HUD.show()
	player = PLAYER_SCENE.instantiate()
	@warning_ignore("integer_division")
	player.global_position = Vector2(viewport_size.x/2,viewport_size.y-100)
	
	add_child(player)
	player.jumped.connect(_on_player_jumped)
	
	var ground_layer_platform_count = (viewport_size.x / platform_size.x) + 1
	for i in range(ground_layer_platform_count):
		create_platform(Vector2(i * platform_size.x,viewport_size.y - platform_size.y))

	# Generate the first few platforms
	start_platform_y = y_distance_between_platforms * 2
	
	last_platform_height = start_platform_y

	generate_next_platforms()


func reset_game():
	running = false
	$CanvasLayer/HUD.change_label(0)
	score = 0
	death_height = 0
	dead = false
	y_distance_between_platforms = initial_y_distance_between_platforms
	player_height = 0
	for platform in platform_parent.get_children():
		platform.queue_free()
	if player:
		player.queue_free()
		player = null
		

func _process(_delta: float) -> void:
	
	if running:
		player_height = viewport_size.y - player.global_position.y
		if player_height < death_height:
			if not dead:
				SoundFx.play("Fall")
				dead = true
				$CanvasLayer/HUD.hide()
				highscore = max(highscore, score)
				save_score()
				died.emit(score,highscore)
				
		elif player_height > death_height + viewport_size.y:
			death_height = player_height - viewport_size.y
		
		for platform in platform_parent.get_children():
			@warning_ignore("integer_division")
			if viewport_size.y - platform.global_position.y <= player_height - viewport_size.y/2:
				platform.queue_free()
				
		score = max(score, player_height-100)
		$CanvasLayer/HUD.change_label(score)
		


func create_platform(location: Vector2):
	var platform = PLATFORM_SCENE.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform


func create_random_platform(height: int):
	var x_coordinate = randi_range(0,viewport_size.x-platform_size.x)
	create_platform(Vector2(x_coordinate,viewport_size.y - height))


func generate_next_platforms():
	y_distance_between_platforms = roundi(initial_y_distance_between_platforms + player_height/200)

	@warning_ignore("integer_division")
	var lookahead_distance = (floor(viewport_size.y*2 / y_distance_between_platforms) + 1) * y_distance_between_platforms

	if player_height + lookahead_distance > last_platform_height:

		for i in range((player_height + lookahead_distance - last_platform_height) / y_distance_between_platforms + 0.5):
			create_random_platform(last_platform_height + (i) * y_distance_between_platforms)
			
		last_platform_height = (player_height + lookahead_distance)


func _on_player_jumped() -> void:
	generate_next_platforms()


func get_parallax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_texture = parallax_sprite.texture
	var parallax_texture_width = parallax_texture.get_width()
	
	var _scale = viewport_size.x / parallax_texture_width
	return Vector2(_scale,_scale)


func setup_parallax_layer(parallax_layer: ParallaxLayer):
	var parallax_sprite: Sprite2D = parallax_layer.find_child("Sprite2D")
	parallax_sprite.scale = get_parallax_sprite_scale(parallax_sprite)
	
	parallax_layer.motion_mirroring.y = parallax_sprite.scale.y * parallax_sprite.texture.get_height()


func save_score():
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_var(highscore)
	file.close()
	
	
func load_score():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)
		highscore = file.get_var()
		file.close()
	else:
		highscore = 0

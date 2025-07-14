extends CanvasLayer

@onready var title_screen: Control = $TitleScreen
@onready var pause_screen: Control = $PauseScreen
@onready var game_over_screen: Control = $GameOverScreen

var current_screen = null

var buttons_disabeled = false


func _ready() -> void:
	$Debug/ConsoleLog.hide()
	register_buttons()
	change_screen(title_screen)


func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	if not buttons.is_empty():
		for button in buttons:
			if button is ScreenButton:
				button.clicked.connect(_on_button_pressed)


func _on_button_pressed(button:ScreenButton):
	SoundFx.play("Click")
	if not buttons_disabeled:
		match button.name:
			"Title_PlayBtn":
				change_screen(null)
				%Game.new_game()
				freeze_game(false)
				
			"Pause_RetryBtn":
				%Game.reset_game()
				%Game.new_game()
				change_screen(null)
				freeze_game(false)

			"Pause_MenuBtn":
				%Game.reset_game()
				change_screen(title_screen)
				
			"Pause_CloseBtn":
				change_screen(null)
				freeze_game(false)
				
			"GameOver_RetryBtn":
				%Game.reset_game()
				%Game.new_game()
				change_screen(null)
				freeze_game(false)
				
			"GameOver_MenuBtn":
				%Game.reset_game()
				change_screen(title_screen)
				
			"HUD_Btn":
				change_screen(pause_screen)
				freeze_game(true)


func freeze_game(on:bool):
	%Game.set_process(not on)
	if %Game.player:
		%Game.player.set_process(not on)
		%Game.player.set_physics_process(not on)


func _on_toggle_console_pressed() -> void:
	$Debug/ConsoleLog.visible = not $Debug/ConsoleLog.visible


func change_screen(new_screen):
	var tween = get_tree().create_tween()
	buttons_disabeled = true
	
	if current_screen:
		current_screen.modulate.a = 1
		tween.tween_property(current_screen,"modulate:a",0,0.2)
		await tween.finished
		if current_screen:
			current_screen.hide()
	
	current_screen = new_screen
	tween.kill()
	tween = get_tree().create_tween()
	
	if new_screen:
		new_screen.show()
		current_screen.modulate.a = 0
		tween.tween_property(current_screen,"modulate:a",1,0.2)
		await tween.finished
		
	buttons_disabeled = false
	tween.kill()


func _on_game_died(score,highscore) -> void:
	change_screen(game_over_screen)
	game_over_screen.set_score(score)
	game_over_screen.set_highscore(highscore)


func pause():
	if not current_screen:
		change_screen(pause_screen)
		freeze_game(true)

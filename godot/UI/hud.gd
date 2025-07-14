extends Control

func _ready() -> void:
	var os_name = OS.get_name()
	if os_name == "Android" or os_name == "iOS":
		var safe_area = DisplayServer.get_display_safe_area()
		
		var screen_scale
		if os_name == "iOS":
			screen_scale = DisplayServer.screen_get_scale()
			
		# try and get the android equivalent of the scale for IOS
		if os_name == "Android":
			var android_DPI = DisplayServer.screen_get_dpi()
			var android_screen_size = DisplayServer.screen_get_size()
			# if we get the screen size in pixels, then the DPI we can get a rough scale similar to IOS
			screen_scale = android_screen_size.x / android_DPI
			
			
		$BlackBG.size.y += safe_area.position.y/screen_scale
		$TopBar.position.y += safe_area.position.y/screen_scale

func change_label(number:int):
	$TopBar/ScoreBox/ScoreLabel.text = str(number)

extends Node


func _on_window_event(event):
	match event:		
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			$Screens.pause()
			
		DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
			get_tree().quit()


var has_working_gyroscope
var has_device_orientation_api_support: bool = false
var needs_gyro_permission: bool = false # True for iOS 13+
var is_gyro_permission_granted: bool = false # Updates after user interaction

func _ready():
	DisplayServer.window_set_window_event_callback(_on_window_event)
	
	#if OS.get_name() == "Web":
		## Fetch initial status from JavaScript
		#has_device_orientation_api_support = JavaScriptBridge.eval("window.hasDeviceOrientationEventSupport;")
		#if not has_device_orientation_api_support:
			#enable_gyro_button.hide()
		#needs_gyro_permission = JavaScriptBridge.eval("window.needsGyroPermission;")
		#if not has_device_orientation_api_support:
			#enable_gyro_button.hide()
		#is_gyro_permission_granted = JavaScriptBridge.eval("window.isGyroPermissionGranted;") # Likely false initially on iOS
		#if not is_gyro_permission_granted:
			#enable_gyro_button.hide()
			#
		#MyUtility.add_log_msg("DeviceOrientationEvent API Support: " + str(has_device_orientation_api_support))
		#MyUtility.add_log_msg("Needs Gyro Permission (iOS 13+): " + str(needs_gyro_permission))
		#MyUtility.add_log_msg("Gyro Permission Granted: " + str(is_gyro_permission_granted))
#
		## Connect the button signal if you have a UI button
		#if enable_gyro_button:
			#enable_gyro_button.pressed.connect(_on_EnableGyroButton_pressed)
			## You might show/hide the button based on 'needs_gyro_permission'
			#enable_gyro_button.visible = needs_gyro_permission and not is_gyro_permission_granted
	#else:
		#enable_gyro_button.hide()


#func _on_EnableGyroButton_pressed():
	#
	#if OS.get_name() == "Web":
		#if has_device_orientation_api_support:
			#if needs_gyro_permission:
				## Call the JavaScript function to request permission
				#MyUtility.add_log_msg("Calling JavaScript to request gyroscope permission...")
				#var permission_status_after_request = JavaScriptBridge.eval("window.requestGyroscopePermission();")
				#MyUtility.add_log_msg("Status: "+str(permission_status_after_request))
				#
				## Note: permission_status_after_request here will be the *initial* state
				## returned by the JS function, not the final promise result.
				## You'll rely on has_working_gyroscope and is_gyro_permission_granted updating
				## in _process after the promise resolves.
			#elif not has_working_gyroscope: # If permission not needed, but still not working
				#MyUtility.add_log_msg("Gyroscope API supported, but not working. Retrying listener setup.")
				#JavaScriptBridge.eval("window.requestGyroscopePermission();") # This JS function also sets up the listener if no permission needed
			#else:
				#MyUtility.add_log_msg("Gyroscope is already working or permission already granted!")
	#enable_gyro_button.call_deferred("hide")
#
#func _process(delta):
	#if OS.get_name() == "Web":
		#if not (needs_gyro_permission and not is_gyro_permission_granted):
			## Continuously update the permission status from JavaScript
			## This is how you'll know if the user granted or denied it.
			#is_gyro_permission_granted = JavaScriptBridge.eval("window.isGyroPermissionGranted;")
			## Also update the 'has_working_gyroscope' status as before
			#has_working_gyroscope = JavaScriptBridge.eval("window.hasWorkingGyroscope;")
#
			## ... (rest of your gyroscope data retrieval and rotation logic) ...
			#if enable_gyro_button:
				## Hide the button once permission is granted or if not needed
				#enable_gyro_button.visible = needs_gyro_permission and not is_gyro_permission_granted

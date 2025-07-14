extends Node

var gyro_alpha: float = 0.0
var gyro_beta: float = 0.0
var gyro_gamma: float = 0.0

var rotation_speed: float = 0.05

func get_gyro():
	if OS.get_name() == "Web":
		# Read values from global JavaScript variables
		gyro_alpha = JavaScriptBridge.eval("window.gyroAlpha;")
		gyro_beta = JavaScriptBridge.eval("window.gyroBeta;")
		gyro_gamma = JavaScriptBridge.eval("window.gyroGamma;")

		# For debugging (optional)
		# print("Godot Gyro data (alpha, beta, gamma): ", gyro_alpha, ", ", gyro_beta, ", ", gyro_gamma)

		# Apply rotation based on gyroscope data
		var rotation_vec = Vector3()
		rotation_vec.x = deg_to_rad(gyro_beta) * rotation_speed # Pitch
		rotation_vec.y = deg_to_rad(-gyro_alpha) * rotation_speed # Yaw (often inverted)
		rotation_vec.z = deg_to_rad(-gyro_gamma) * rotation_speed # Roll (often inverted)

		return rotation_vec

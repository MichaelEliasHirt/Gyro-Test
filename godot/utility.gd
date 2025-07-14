extends Node

func add_log_msg(msg:String):
	print("log_msg: ",msg)
	msg = Time.get_time_string_from_system()+ ": > " + msg
	var console = get_tree().get_first_node_in_group("debug_console")
	if console:
		var log_label = console.find_child("LogLabel")
		if log_label:
			if log_label.text.is_empty():
				log_label.text += msg
			else:
				log_label.text += "\n" + msg
	

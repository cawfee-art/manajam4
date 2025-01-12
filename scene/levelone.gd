extends Node2D


func _ready() -> void:
	Dialogic.signal_event.connect(on_dialogic_signal)


func on_dialogic_signal(name: String) -> void:
	match name:
		"give_infinite_beans":
			Globals.beans = -1
		
		"enable_hud":
			Events.enable_bean_hud.emit()
		
		"give_bean":
			if Globals.beans < 0:
				Globals.beans = 1
				Events.bean_collected.emit()
			else:
				Globals.beans += 1
				Events.bean_collected.emit()


func _on_next_level_body_entered(body: Node2D) -> void:
	if body is Player:
		Globals.checkpoint_reached = false
		get_tree().change_scene_to_file("res://scene/leveltwo.tscn")

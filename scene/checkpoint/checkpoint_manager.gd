extends Node


var player: Player


func _ready() -> void:
	player = get_tree().get_first_node_in_group(&"player")
	
	if Globals.checkpoint_reached:
		player.global_position = Globals.reset_position
	else:
		Globals.reset_position = player.global_position
		Globals.checkpoint_reached = true
	
	for checkpoint: Checkpoint in get_tree().get_nodes_in_group(&"checkpoint"):
		checkpoint.checkpoint_activated.connect(on_checkpoint_activated)


func on_checkpoint_activated(pos: Vector2) -> void:
	Globals.reset_position = pos


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Restart"):
		if Globals.beans >= 0:
			Globals.beans = 0
			Events.bean_collected.emit()
		get_tree().reload_current_scene()

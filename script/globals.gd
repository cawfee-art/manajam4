extends Node


var beans: int = 0 # -1 = ininite, 0 = can't place

var reset_position: Vector2
var checkpoint_reached: bool = false

## Plays dialogic timeline
func play_dialog(timeline: String, zoom: bool) -> void:
	var camera := get_viewport().get_camera_2d()
	if zoom:
		var tween := create_tween()
		tween.tween_property(camera, ^"zoom", Vector2(3.5, 3.5), 1.0)
	
	Events.dialog_started.emit()
	Dialogic.start(timeline)
	
	await Dialogic.timeline_ended
	
	Events.dialog_ended.emit()
	if zoom:
		var tween = create_tween()
		tween.tween_property(camera, ^"zoom", Vector2(1.0, 1.0), 0.5)


func die_restart() -> void:
	if Globals.beans >= 0:
		Globals.beans = 0
		Events.bean_collected.emit()
		get_tree().reload_current_scene()

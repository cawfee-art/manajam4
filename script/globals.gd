extends Node


var beans: int = 0


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

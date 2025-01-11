extends Area2D


@export_file("*.dtl") var timeline: String
@export var enabled: bool = true


func _on_body_entered(body: Node2D) -> void:
	if not enabled:
		return
	
	enabled = false
	
	var camera := get_viewport().get_camera_2d()
	var tween := create_tween()
	tween.tween_property(camera, ^"zoom", Vector2(3.5, 3.5), 2.0)
	
	Events.dialog_started.emit()
	Dialogic.start(timeline)
	
	await Dialogic.timeline_ended
	
	Events.dialog_ended.emit()
	tween.tween_property(camera, ^"zoom", Vector2.ONE, 1.0)

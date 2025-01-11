extends Area2D


@export_file("*.dtl") var timeline: String
@export var zoom: bool = true
@export var enabled: bool = true


func _on_body_entered(body: Node2D) -> void:
	if not enabled:
		return
	
	enabled = false
	
	if not timeline:
		push_error("No timeline set")
		return
	Globals.play_dialog(timeline, zoom)

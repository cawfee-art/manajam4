@tool
class_name Sign extends Node2D


@export_multiline var text: String:
	get:
		return text
	set(value):
		text = value
		%Text.text = text


func _ready() -> void:
	if not Engine.is_editor_hint():
		%Panel.hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		%Panel.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		%Panel.hide()

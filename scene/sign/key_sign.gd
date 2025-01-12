@tool
class_name KeySign extends Node2D


@export var key_image: Texture2D:
	get:
		return key_image
	set(value):
		key_image = value
		%Key.texture = value


func _ready() -> void:
	if not Engine.is_editor_hint():
		%Key.hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		%Key.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		%Key.hide()

@tool
extends Node2D


@export_tool_button("Flip", "FlipWinding") var flip_h = flip
@export_storage var flipped: bool = true

func flip() -> void:
	if flipped:
		%Pivot.scale = Vector2(1.0, 1.0)
		flipped = false
	else:
		%Pivot.scale = Vector2(-1.0, 1.0)
		flipped = true

## Dialog
@export_file("*.dtl") var timeline: String = ""

var player_in_range: bool = false
var player_can_talk: bool = false

var player: Player


func _ready() -> void:
	%InteractionMarker.hide()

func _physics_process(delta: float) -> void:
	if not player_in_range:
		return
	
	# check if player looks in direction of npc
	if (flipped and player.sprite.flip_h) or (not flipped and not player.sprite.flip_h):
		player_can_talk = false
		%InteractionMarker.hide()
		return
	
	player_can_talk = true
	%InteractionMarker.show()


func _unhandled_key_input(event: InputEvent) -> void:
	if player_can_talk and event.is_action_pressed(&"Talk"):
		player_in_range = false
		player_can_talk = false
		%InteractionMarker.hide()
		if not timeline:
			push_error("No timeline set")
			return
		Globals.play_dialog(timeline, true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		
		if not player:
			player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		%InteractionMarker.hide()

@tool
extends Node2D


const FLIPPED = Vector2(1.0, 1.0)
const UNFLIPPED = Vector2(-1.0, 1.0)

@export var flipped: bool = false:
	get:
		return flipped
	set(value):
		flipped = value
		flip()


func flip() -> void:
	if flipped:
		%Pivot.scale = FLIPPED
	else:
		%Pivot.scale = UNFLIPPED

@export_enum("Erika", "Aideen", "Olaf", "Coby", "Lilly") \
var person: String = "Erika":
	get:
		return person
	set(value):
		person = value
		%AnimatedSprite2D.play(person)

## Dialog
@export_file("*.dtl") var timeline: String = ""

var player_in_range: bool = false
var player_can_talk: bool = false

var player: Player


func _ready() -> void:
	%InteractionMarker.hide()
	flip()
	%AnimatedSprite2D.play(person)


func _physics_process(delta: float) -> void:
	if not player_in_range:
		return
	
	# check if player looks in direction of npc
	if (%Pivot.scale == FLIPPED and player.sprite.flip_h) or (not %Pivot.scale == FLIPPED and not player.sprite.flip_h):
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
		player_can_talk = false
		%InteractionMarker.hide()

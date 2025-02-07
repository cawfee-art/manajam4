extends CharacterBody2D
class_name Player
 
@export var SPEED : int = 150
@export var CLIMB_SPEED : int = 100
@export var JUMP_FORCE : int = 255
@export var GRAVITY : int = 900

@export var vine_tile_map_layer: TileMapLayer

var is_on_vine: bool

var paused: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	Events.dialog_started.connect(on_dialog_started)
	Events.dialog_ended.connect(on_dialog_ended)
 

func _physics_process(delta):
	
	# death
	if global_position.y > 6000:
		Globals.die_restart()
		return
	
	# start climbing vine
	if not paused and not is_on_vine and Input.is_action_pressed("Up") and _is_at_vine():
		is_on_vine = true
	
	# fall from vine
	if is_on_vine and not _is_at_vine():
		is_on_vine = false
	
	
	var direction = Input.get_axis("Left","Right")
	
	if is_on_vine:
		var y_direction = Input.get_axis("Up", "Down")
		
		if not paused and (direction or y_direction):
			
			velocity.x = CLIMB_SPEED * direction
			velocity.y = CLIMB_SPEED * y_direction
			
			sprite.play("Climb")
			
		else:
			
			velocity = Vector2.ZERO
			
			sprite.play("ClimbIdle")
		
	else: # not on vine
		if not paused and direction:
			
			velocity.x = SPEED * direction
			
			if is_on_floor():
				
				sprite.play("Run")
			
		else:
			
			velocity.x = 0
			
			if is_on_floor():
				
				sprite.play("Idle")
		
		# Rotate
		
		if not paused:
			if direction > 0:
				sprite.flip_h = false
			elif direction < 0:
				sprite.flip_h = true
		
		
		# Gravity
		
		if not is_on_floor():
			
			velocity.y += GRAVITY * delta
			
			if velocity.y > 0:
				
				sprite.play("Fall")
	
	# Jump
	
	if not paused and (is_on_floor() or is_on_vine) and Input.is_action_just_pressed("Jump"):
		# exit vine
		is_on_vine = false
		
		velocity.y -= JUMP_FORCE
		sprite.play("Jump")
	
	
	move_and_slide()


func on_dialog_started() -> void:
	paused = true

func on_dialog_ended() -> void:
	paused = false


## Returns true if a vine is behind player
func _is_at_vine() -> bool:
	if not vine_tile_map_layer:
		push_error("Vine tile map layer not set")
		return false
	
	var player_pos_on_grid := vine_tile_map_layer.local_to_map(position)
	if vine_tile_map_layer.get_cell_tile_data(player_pos_on_grid):
		# there is a tile at the current position on the vine tile map layer
		return true
	
	return false

extends CharacterBody2D
class_name Player
 
@export var SPEED : int = 150
@export var CLIMB_SPEED : int = 100
@export var JUMP_FORCE : int = 255
@export var GRAVITY : int = 900

@export var vine_tile_map_layer: TileMapLayer

var is_on_vine: bool
 

func _physics_process(delta):
	
	# start climbing vine
	if not is_on_vine and Input.is_action_pressed("Up") and _is_at_vine():
		is_on_vine = true
	
	# fall from vine
	if is_on_vine and not _is_at_vine():
		is_on_vine = false
	
	
	var direction = Input.get_axis("Left","Right")
	
	if is_on_vine:
		var y_direction = Input.get_axis("Up", "Down")
		
		if direction or y_direction:
			
			velocity.x = CLIMB_SPEED * direction
			velocity.y = CLIMB_SPEED * y_direction
			
			$AnimatedSprite2D.play("Climb")
			
		else:
			
			velocity = Vector2.ZERO
			
			$AnimatedSprite2D.play("ClimbIdle")
		
	else: # not on vine
		if direction:
			
			velocity.x = SPEED * direction
			
			if is_on_floor():
				
				$AnimatedSprite2D.play("Run")
			
		else:
			
			velocity.x = 0
			
			if is_on_floor():
				
				$AnimatedSprite2D.play("Idle")
	
	# Rotate
	
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true
	
	
	# Gravity
	
	if not is_on_floor() and not is_on_vine:
		
		velocity.y += GRAVITY * delta
		
		if velocity.y > 0:
			
			$AnimatedSprite2D.play("Fall")
	
	# Jump
	
	if (is_on_floor() or is_on_vine) and Input.is_action_just_pressed("Jump"):
		# exit vine
		is_on_vine = false
		
		velocity.y -= JUMP_FORCE
		$AnimatedSprite2D.play("Jump")
	
	
	move_and_slide()


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

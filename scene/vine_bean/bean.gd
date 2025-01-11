class_name Bean extends Node


## Delay between frames in sec
@export_range(1.0, 100.0, 1.0) var grow_speed: float = 25.0
@export var player: Player
## The layer the vine is placed on. Should be empty.
@export var vine_layer: TileMapLayer
## Source id of vine atlas
@export var vine_tile_set_id: int = 0
## The tile set collision layers the vine will search for collision
@export var collision_layer: int = 0

var tile_map_layers: Array[TileMapLayer]


func _ready() -> void:
	_get_all_tile_map_layers(get_tree().root)

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.is_action_pressed(&"Bean"):
		return
	
	if not player:
		push_error("Player not set")
		return
	
	if not vine_layer:
		push_error("Vine Layer not set")
		return
	
	if not vine_layer.tile_set.get_source(vine_tile_set_id):
		push_error("Vine Atlas not found")
		return
	
	#TEST: show marker everytime
	_show_marker()
	
	if not has_bean():
		printerr("No bean")
		return
	
	if not can_plant_here():
		printerr("Can't plant here")
		return
	
	plant_vine_at(_get_player_position_on_grid())


func has_bean() -> bool:
	return true

func can_plant_here() -> bool:
	var player_pos := _get_player_position_on_grid()
	var below := player_pos + Vector2i(0, 1)
	var above := player_pos - Vector2i(0, 1)
	
	if not _grid_has_collision_at(below):
		printerr("No collision below")
		return false
	
	if not _can_plant_at(below):
		printerr("Ground is no soil")
		return false
	
	if not can_grow_at(above):
		printerr("Not enough space above")
		return false
	
	return true

func can_grow_at(grid_pos: Vector2i) -> bool:
	# check if there is a vine here already
	if vine_layer.get_cell_tile_data(grid_pos):
		return false
	
	# check for collision on other layers
	if _grid_has_collision_at(grid_pos):
		return false
	
	# no collision found
	return true


func plant_vine_at(grid_pos: Vector2i) -> void:
	var current_pos := grid_pos
	var vine_type := 2 # 2 = root, 1 = mid, 0 = end; start with root
	
	while current_pos.y >= 0 and can_grow_at(current_pos):
		var above = current_pos - Vector2i(0, 1)
		if current_pos == grid_pos:
			vine_type = 2
			
		elif above.y >= 0 and can_grow_at(above):
			vine_type = 1
			
		else:
			vine_type = 0
		
		for x in range(4):
			vine_layer.set_cell(current_pos, vine_tile_set_id, Vector2i(x, vine_type))
			await get_tree().create_timer(grow_speed / 1000.0).timeout
		
		current_pos = above


## Stores all tilemaps in the current level
func _get_all_tile_map_layers(node: Node) -> void:
	# ignore paralax tile_map_layers
	if node is ParallaxLayer:
		return
	
	if node is TileMapLayer and node != vine_layer:
		tile_map_layers.append(node)
	
	# recursive
	for child in node.get_children():
		_get_all_tile_map_layers(child)

## Returns the player current grid position
func _get_player_position_on_grid() -> Vector2i:
	return vine_layer.local_to_map(player.position)

## Returns if the grid has any collision of the given layer
func _grid_has_collision_at(grid_pos: Vector2i) -> bool:
	for tile_map in tile_map_layers:
		var tile_data := tile_map.get_cell_tile_data(grid_pos)
		if not tile_data:
			continue
		if tile_data.get_collision_polygons_count(collision_layer):
			return true
	
	return false


func _can_plant_at(grid_pos: Vector2i) -> bool:
	for tile_map in tile_map_layers:
		var tile_data := tile_map.get_cell_tile_data(grid_pos)
		if not tile_data:
			continue
		if tile_data.get_custom_data("Soil"):
			return true
	
	return false

## Shows the marker at the current grid position for a second
func _show_marker() -> void:
	%Marker.position = vine_layer.map_to_local(_get_player_position_on_grid())
	if can_plant_here():
		%Marker.self_modulate = Color.GREEN
	else:
		%Marker.self_modulate = Color.RED
	%Marker.show()
	await get_tree().create_timer(0.2).timeout
	%Marker.hide()

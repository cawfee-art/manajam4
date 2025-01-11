extends CanvasLayer


func _ready() -> void:
	Events.connect(&"bean_collected", on_bean_count_changed)
	Events.connect(&"vine_planted", on_bean_count_changed)
	Events.connect(&"not_enough_beans", on_not_enough_beans)


func on_bean_count_changed() -> void:
	%BeanLabel.text = str(Globals.beans)


func on_not_enough_beans() -> void:
	%BeanLabel.modulate = Color.RED
	var tween := create_tween()
	tween.tween_property(%BeanLabel, ^"modulate", Color.WHITE, 0.2)

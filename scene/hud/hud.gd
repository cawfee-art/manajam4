extends CanvasLayer


func _ready() -> void:
	Events.bean_collected.connect(on_bean_count_changed)
	Events.vine_planted.connect(on_bean_count_changed)
	Events.not_enough_beans.connect(on_not_enough_beans)


func on_bean_count_changed() -> void:
	%BeanLabel.text = str(Globals.beans)


func on_not_enough_beans() -> void:
	%BeanLabel.modulate = Color.RED
	var tween := create_tween()
	tween.tween_property(%BeanLabel, ^"modulate", Color.WHITE, 0.2)

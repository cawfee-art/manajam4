extends CanvasLayer


func _ready() -> void:
	%BeanCounter.hide()
	hide()
	
	Events.bean_collected.connect(on_bean_count_changed)
	Events.vine_planted.connect(on_bean_count_changed)
	
	Events.not_enough_beans.connect(on_not_enough_beans)
	
	Events.dialog_started.connect(on_dialog_started)
	Events.dialog_ended.connect(on_dialog_ended)
	
	Events.enable_bean_hud.connect(on_enable_bean_hud)


func on_bean_count_changed() -> void:
	%BeanLabel.text = str(Globals.beans)


func on_not_enough_beans() -> void:
	%BeanLabel.modulate = Color.RED
	var tween := create_tween()
	tween.tween_property(%BeanLabel, ^"modulate", Color.WHITE, 0.2)


func on_dialog_started() -> void:
	hide()

func on_dialog_ended() -> void:
	show()


func on_enable_bean_hud() -> void:
	%BeanCounter.show()

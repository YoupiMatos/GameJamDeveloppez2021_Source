extends Area2D



func _on_Area2D_body_shape_entered(body_id: int, body: Node, body_shape: int, local_shape: int) -> void:
	Autoload.blue_mana = true
	$Sprite.visible = false
	$Label.visible = true
	yield(get_tree().create_timer(1.0), "timeout")
	$Label.visible = false
	queue_free()

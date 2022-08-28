extends Area

func _on_GhostArea_body_entered(body):
	if body.is_in_group("Player"):
		$Ghost/AudioStreamPlayer3D.play()
		$Ghost.hide()

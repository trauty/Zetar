extends Spatial

func _on_Player_water_gone():
	$AnimationPlayer.play("water_gone_anim")
	$AudioStreamPlayer3D.play()
	$StaticBody.set_collision_layer_bit(0, false)
	$StaticBody.set_collision_mask_bit(0, false)

extends Spatial

var itempillar_count = 0

func _on_Player_plant_orb():
	itempillar_count += 1
	if itempillar_count == 2:
		$AnimationPlayer.play("gate_opening_anim")
		$AudioStreamPlayer3D.play()

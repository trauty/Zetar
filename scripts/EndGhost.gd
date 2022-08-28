extends Area

func _on_Area_body_entered(body):
	$Timer.connect("timeout", self, "on_timer_complete")
	$SoundTimer.connect("timeout", self, "on_soundtimer_complete")
	$Timer.start()
	$SoundTimer.start()

func on_soundtimer_complete():
	$AudioStreamPlayer.play()
	
func on_timer_complete():
	get_tree().quit()

extends Spatial

var is_active = false

func activate_pillar():
	is_active = true
	$GlowingOrb.show()

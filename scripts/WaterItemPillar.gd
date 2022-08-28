extends StaticBody

var is_active = false

func activate_pillar():
	is_active = true
	$GreenTablet.show()

extends KinematicBody

signal plant_orb
signal water_gone

var item_count = 0

var mouse_sensitivity = 0.2

var full_contact = false

var movement_speed = 9
var hor_acceleration = 6
var direction = Vector3()
var hor_velocity = Vector3()
var movement = Vector3()

var gravity_scale = 32
var jump_height = 2
var air_acceleration = 1
var normal_acceleration = 6
var gravity_vec = Vector3()

var is_flashlight_on = false
var is_in_tunnel = false
var sound_is_playing = false

onready var head = $Head
onready var ground_check = $GroundCheck

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$UI/FlashlightPopup.popup()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	direction = Vector3()
	
	full_contact = ground_check.is_colliding()
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity_scale * delta
		hor_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity_scale
		hor_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		hor_acceleration = air_acceleration
	
	if Input.is_action_pressed("jump") and (is_on_floor() or full_contact):
		gravity_vec = Vector3.UP * sqrt(gravity_scale * jump_height * 2) 
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		 direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		 direction += transform.basis.x
	if Input.is_action_pressed("crouch") or is_in_tunnel:
		$CollisionShape.scale.y = 0.2
		$Foot.scale.y = 0.2
		$GroundCheck.scale.y = 0.2
		$Head.translation.y = 0.5
	else:
		$CollisionShape.scale.y = 1.0
		$Foot.scale.y = 1.0
		$GroundCheck.scale.y = 1.0
		$Head.translation.y = 1.25
	if Input.is_action_just_pressed("flashlight"):
		$Head/Flashlight/FlashlightSoundPlayer.play()
		$UI/FlashlightPopup.hide()
		if is_flashlight_on:
			$Head/Flashlight/OmniLight.visible = false
			is_flashlight_on = false
		else:
			$Head/Flashlight/OmniLight.visible = true
			is_flashlight_on = true
	if Input.is_action_just_pressed("interact") and $Head/PickupRaycast.is_colliding():
		var col_object = $Head/PickupRaycast.get_collider()
		if col_object.is_in_group("ItemPickup"):
			item_count += 1
			$PickupSoundPlayer.play()
			col_object.set_collision_mask_bit(0, false)
			col_object.set_collision_layer_bit(0, false)
			col_object.hide()
			if item_count == 2:
				$Head/Flashlight/OmniLight.visible = false
				is_flashlight_on = false
				$Head/Flashlight/FlashlightSoundPlayer.play()
		if col_object.is_in_group("ItemPillar") and item_count != 0:
			if !col_object.is_active:
				item_count -= 1
				col_object.activate_pillar()
				emit_signal("plant_orb")
		if col_object.is_in_group("WaterItemPillar") and item_count > 0:
			item_count -= 1
			col_object.activate_pillar()
			emit_signal("water_gone")
	direction = direction.normalized()
	hor_velocity = hor_velocity.linear_interpolate(direction * movement_speed, hor_acceleration * delta)
	movement.x = hor_velocity.x + gravity_vec.x
	movement.z = hor_velocity.z + gravity_vec.z
	movement.y = gravity_vec.y
	
	if direction.length() <= 0.1 or is_in_tunnel or !full_contact:
		$AnimationPlayer.stop()
	else:
		if $Timer.time_left <= 0:
			$AnimationPlayer.play("flashlight_bob")
			$SteppingSoundPlayer.pitch_scale = rand_range(0.8, 1.2)
			$SteppingSoundPlayer.play()
			$Timer.start(0.4)
	
	move_and_slide(movement, Vector3.UP)


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		is_in_tunnel = true

func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		is_in_tunnel = false

func _on_TrampolineArea_body_entered(body):
	if body.is_in_group("Player"):
		jump_height *= 10

func _on_TrampolineArea_body_exited(body):
	jump_height /= 10

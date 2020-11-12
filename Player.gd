extends KinematicBody2D

class_name Player

const SPEED = 500
const JUMP_POWER = -1400
const DEFAULT_GRAVITY = 60
const FLOOR = Vector2(0, -1)
const FIREBALL = preload("res://Fireball.tscn")
const STARBALL = preload("res://Starball.tscn")
const IMPULSE_MINERAL_COLUMN = preload("res://ImpulseMineralColumn.tscn")
const WALL_SLIDE_ACCELERATION = 10
const MAX_WALL_SLIDE_SPEED = 120
const MAX_SPEED = 5000
const STOPPING_FRICTION = 0.6
const RUNNING_FRICTION = 0.9
const FALL_SPEED = 0.7

onready var player_vars = get_node("res://Global.gd")

var velocity = Vector2()
var jumps_left = 0
var on_ground = false
var GRAVITY = 60

#lets the attack animation finish
var is_attacking = false

#prevents him from moving if true
var is_dead = false

#stuff for dashing
var can_dash = true
var dashing = false
var dash_direction = Vector2(1,0)

#trying to see if this can be used to make it so that he has to jump away from the wall to wall jump
var can_wall_jump = false

#coins
var coin_amount = 0 

func _physics_process(delta):
	run(delta)
	jump(delta)
	friction()
	gravity()
	dash()
	shoot()
	anti_grav_mineral()
	impulse_mineral()
	has_collided_with_enemy()
	fast_fall()
	velocity = move_and_slide(velocity, FLOOR)


#		if Input.is_action_just_pressed("up") && is_on_wall() == false:
#			if is_attacking == false:
#				if on_ground == true:
#					velocity.y = JUMP_POWER
#					if Input.is_action_just_released("up") and velocity.y < 0:
#						velocity.y = 0					
#					on_ground = false
#			can_wall_jump = true

#		if is_on_wall() && Input.is_action_pressed("right") && Input.is_action_pressed("up"):
#			if (can_wall_jump == true)&&(is_on_floor() == false):
#				$Sprite.flip_h = false
#				velocity.y = JUMP_POWER
#				velocity.x = SPEED
#
#				on_ground = false
#			can_wall_jump = false
#
#		elif is_on_wall() && Input.is_action_pressed("left") && Input.is_action_pressed("up"):
#			if (can_wall_jump == true)&&(is_on_floor() == false):
#				$Sprite.flip_h = true
#				velocity.y = JUMP_POWER
#				velocity.x = -SPEED
#			can_wall_jump = false


#		velocity.y += GRAVITY


func has_collided_with_enemy():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "Enemy" in get_slide_collision(i).collider.name:
				dead()
func run(delta):
	if is_dead == false:
		if Input.is_action_pressed("right"):
			velocity.x = SPEED
			$Sprite.play("run")
			$Sprite.flip_h = false
			#flips the fireballs
			if sign($ProjectilePosition.position.x) == -1:
					$ProjectilePosition.position.x *= -1
					#flips the impulse mineral 
					$ImpulseMineralPosition.position.x *= -1
		elif Input.is_action_pressed("left"):
			velocity.x = -SPEED
			$Sprite.play("run")
			$Sprite.flip_h = true
			if sign($ProjectilePosition.position.x) == 1:
					$ProjectilePosition.position.x *= -1
					$ImpulseMineralPosition.position.x *= -1
		else:
			velocity.x = 0
			if on_ground == true && is_attacking == false:
				$Sprite.play("idle")

func friction():
	#when i hold the key
	var running = Input.is_action_pressed("left") or Input.is_action_pressed("right")
	if not running and is_on_floor():
		velocity.x *= STOPPING_FRICTION
	else: 
		velocity.x *= RUNNING_FRICTION

func jump(delta):
	if is_dead == false: 
		if is_on_floor():
			jumps_left = 2
			can_wall_jump = true
		elif next_to_wall() and $WallJumpCooldown.is_stopped():
			jumps_left = 1
			can_wall_jump = false
			$WallJumpCooldown.start()

			
		if Input.is_action_just_pressed("up") and jumps_left > 0:
			#if I'm falling - ignore fall velocity
#			if velocity.y > 0:
#				print("Velocity has reached 0")
#				velocity.y = 0
			velocity.y = JUMP_POWER
			jumps_left -= 1
			#wall jump
			if not is_on_floor() and next_to_left_wall() :
				velocity.x += JUMP_POWER
			if not is_on_floor() and next_to_right_wall():
				velocity.x -= JUMP_POWER
#				can_wall_jump = false
#				jumps_left = 0
#				$WallJumpCooldown.start()				
		
		#if still jumping, start to fall
		if Input.is_action_just_released("up") and velocity.y < 0:
			velocity.y *= FALL_SPEED
		on_ground = false
		
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
		else:
			if is_attacking == false:
				on_ground = false
				$Sprite.play("spinning")
	else:
		velocity = Vector2()

func next_to_wall():
	return next_to_left_wall() or next_to_right_wall()
	
func next_to_left_wall():
	return $RayCast2DBottomLeft.is_colliding() or $RayCast2DTopLeft.is_colliding()
	
func next_to_right_wall():
	return $RayCast2DTopRight.is_colliding() or $RayCast2DBottomRight.is_colliding()

func gravity():
	if not dashing:
		velocity.y += GRAVITY
#	if velocity.y > 2000: 
#		velocity.y = 0 #clamp falling speed 
	if next_to_wall() and velocity.y > MAX_WALL_SLIDE_SPEED and (Input.is_action_pressed("right") or Input.is_action_pressed("left")): 
		velocity.y = MAX_WALL_SLIDE_SPEED #wall slide
		
func dash():
	if is_on_floor():
		can_dash = true #recharges when player touches floor
	
	if Input.is_action_pressed("right"):
		dash_direction = Vector2(1,0)
	elif Input.is_action_pressed("left"):
		dash_direction = Vector2(-1,0)
		
	if Input.is_action_just_pressed("dash") and can_dash:
		velocity = dash_direction.normalized() * (10000)
		can_dash = false
		dashing = true #turn off gravity while dashing
		yield(get_tree().create_timer(0.5), "timeout")
		dashing = false
func fast_fall():
	if not is_on_floor():
		if Input.is_action_pressed("down"):
			velocity.y *= -3

func dead():
	is_dead = true
	velocity = Vector2()
	$Sprite.play("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()

#fireball code
func shoot():
	if Input.is_action_just_pressed("shoot") && is_attacking == false:
		if is_on_floor():
			velocity.x = 0
		is_attacking = true
		$Sprite.play("throw")
		$FightSound.play()
		var fireball = null
		if Global.fireball_power == 1:
			fireball = FIREBALL.instance()
		elif Global.fireball_power == 2:
			fireball = STARBALL.instance()
		if sign($ProjectilePosition.position.x) == 1:
			fireball.set_fireball_direction(1)
		else: 
			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)
		fireball.position = $ProjectilePosition.global_position

func _on_Sprite_animation_finished():
	is_attacking = false

func _on_Timer_timeout():
	get_tree().change_scene("res://Title Screen.tscn")

#Power Ups Here
func gem_power_up():
	Global.fireball_power = 2
	
func activate_anti_grav_mineral_power_up():
	Global.can_use_anti_grav_mineral = true
	
func anti_grav_mineral():
	if Input.is_action_just_pressed("anti_grav") and Global.can_use_anti_grav_mineral:
		$MineralCrash.play()
		#decreases gravity
		GRAVITY = 20
		#you can use the anti grav power for 5 seconds
		yield(get_tree().create_timer(5), "timeout")
		#after done, change to normal gravity
		GRAVITY = DEFAULT_GRAVITY

func activate_impulse_mineral_power_up():
	Global.can_use_impulse_mineral = true

func impulse_mineral():
	if Input.is_action_just_pressed("impulse") and Global.can_use_impulse_mineral:
		$MineralCrash.play()
		$Sprite.play("throw")
		var impulse_mineral_instance = null
		impulse_mineral_instance = IMPULSE_MINERAL_COLUMN.instance()
		get_parent().add_child(impulse_mineral_instance)
		impulse_mineral_instance.position = $ImpulseMineralPosition.global_position
		
func impulse_launch():
	velocity.x *= 2
	if velocity.y == 0:
		velocity.y = JUMP_POWER
	elif velocity.y < 0:
		velocity.y = JUMP_POWER * 2
	else:
		velocity.y *= 3
		
func get_coin():
	coin_amount += 1
	print(coin_amount)

func _on_Footsteps_finished():
	pass

func _on_WallJumpCooldown_timeout():
	can_wall_jump = true
	pass # Replace with function body.

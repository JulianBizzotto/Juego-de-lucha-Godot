extends KinematicBody2D

var speed = 200
var velocity = Vector2(0, 0)
var gravity = 750
var jump = -600
var hit_count = 0
var max_hit = 2
var hit = false
var direccion = Vector2()
var Combo1 = 3


func _ready():
	$Animaciones.play("Normal");


func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = 0
	
	if Input.is_action_just_pressed("tecla_x") && Combo1 == 3:
		$Animaciones.play("Golpe1");
		Combo1 = 2;
		
	if Input.is_action_pressed("ui_right"):
		velocity.x = velocity.x + speed
		$Animaciones.play("Correr");
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		$Animaciones.play("Correr");
		
	if velocity.x == 0 && ! is_on_floor():
		$Animaciones.play("Normal");
	
		
	
	direccion.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	if direccion.x != 0:
		get_node("BodyPivot").scale = Vector2(direccion.x,1);
	
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump
		$Animaciones.play("Salto");



	velocity = move_and_slide(velocity, Vector2.UP)





func _on_Animaciones_animation_finished(anim_name):
	if anim_name == "Golpe1":
		$Animaciones.play("Normal");

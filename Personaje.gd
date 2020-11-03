extends KinematicBody2D

var speed = 300;
var velocity = Vector2(0, 0);
var gravity = 750;
var jump = -600;
var StateMachine;
var direccion = Vector2();
var moverse = false
var attacking = false;
var combo = null;
export var max_vida = 100;
export var vida_actual = 100;
export var max_mana = 100;
export var mana_actual = 0;
var barravida;
var barramana;
var damage_enemigo = 0;
var salto = false;
var ataque_enemigo = false;
func actualizardamage_enemigo():
	vida_actual -= damage_enemigo;
func actualizar_barrahp():
	barravida.value = vida_actual * barravida.max_value / max_vida;
func actualizar_barramana():
	barramana.value = mana_actual * barramana.max_value / max_mana;
func _ready():
	ataque_enemigo = false;
	barravida = get_tree().get_nodes_in_group("hpj1")[0];
	barramana = get_tree().get_nodes_in_group("energyj1")[0];
	attacking = false;
	moverse = false;
	salto = false;
	StateMachine = $AnimacionesBasicas.get("parameters/playback");
	StateMachine.start("Normal");

func _physics_process(delta):
	actualizar_barrahp()
	actualizar_barramana()
	velocity.y += gravity * delta;
	velocity.x = 0;
	getcontrols();
	

func getcontrols():
	if Input.is_action_pressed("ui_right") && attacking == false:
		moverse = true;
		velocity.x = velocity.x + speed;
		$BodyPivot/Images.flip_h = false;
		correr();
	elif Input.is_action_pressed("ui_left") && attacking == false:
		moverse = true;
		velocity.x -= speed;
		$BodyPivot/Images.flip_h = true;
		correr();
	if is_on_floor():
		salto = false;
	if velocity.x == 0 and is_on_floor():
		moverse = false;
		normal();
		
			
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		salto = true;
		moverse = true;
		velocity.y = jump;
		salto();
	if is_on_floor() and Input.is_action_pressed("ui_down") && moverse == false:
		agacharse();

	if is_on_floor() and Input.is_action_pressed("tecla_x") and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		if $BodyPivot/Images.flip_h:
			$Golpe.position = Vector2(-97, 0.458);
			$Golpe.scale = Vector2(-1, 1)
		else:
			$Golpe.position = Vector2(97.384, -0.458);
			$Golpe.scale = Vector2(1, 1)
		golpear2();
		owner.get_node("Enemigo").damage_jugador = 4;
	elif is_on_floor() and Input.is_action_pressed("tecla_c") && moverse == false:
		cubrirse();
		attacking = true;
	elif is_on_floor() and Input.is_action_pressed("tecla_x"):
		if $BodyPivot/Images.flip_h:
			$Golpe.position = Vector2(-97.384, 0.458);
		else:
			$Golpe.position = Vector2(97.384, -0.458);
		golpear();
		owner.get_node("Enemigo").damage_jugador = 2;
		attacking = true;
	elif is_on_floor() and Input.is_action_pressed("tecla_v") && moverse == false:
		Patada();
		owner.get_node("Enemigo").damage_jugador = 2;
		attacking = true;
	velocity = move_and_slide(velocity, Vector2.UP);

func parar_movimiento_en_ataque():
	if $Golpe/Colision_Ataques.is_disabled():
		attacking = false;
func normal():
	StateMachine.travel("Normal");
	parar_movimiento_en_ataque();

func correr():
	StateMachine.travel("Correr");

func Patada():
	StateMachine.travel("Patada");

func salto():
	StateMachine.travel("Salto");

func golpear():
	StateMachine.travel("Golpe1");
	
func golpear2():
	StateMachine.travel("Golpe2");

func golpear3():
	StateMachine.travel("Golpe largo");

func cubrirse():
	StateMachine.travel("Cubrirse");
	
func agacharse():
	StateMachine.travel("Agacharse");

	




func _on_Area_area_entered(area):
	if area.is_in_group("golpe_enemigo"):
		actualizardamage_enemigo();
		ataque_enemigo = true;
		print("hit_enemigo");
	else:
		ataque_enemigo = false;

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
export var max_vida = 200;
export var vida_actual = 200;
export var max_mana = 100;
export var mana_actual = 0;
var barravida;
var barramana;
var damage_enemigo = 0;
var salto = false;
var ataque_enemigo = false;
var ultimate = false;
var izquierda = false;
var derecha = false;
func actualizardamage_enemigo():
	vida_actual -= damage_enemigo;
	mana_actual = mana_actual + damage_enemigo;
	if barramana.value == 100:
		ultimate = true;
func actualizar_barrahp():
	barravida.value = vida_actual * barravida.max_value / max_vida;
func actualizar_barramana():
	barramana.value = mana_actual * barramana.max_value / max_mana;
func _ready():
	izquierda = false;
	derecha = true;
	ultimate = false;
	mana_actual = 100;
	$Posicion_particulas/Particulas_viento.emitting = false;
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
		$BodyPivot.scale = Vector2(1, 1);
		correr();
		derecha = true;
		izquierda = false;
	elif Input.is_action_pressed("ui_left") && attacking == false:
		derecha = false;
		izquierda = true;
		moverse = true;
		velocity.x -= speed;
		$BodyPivot.scale = Vector2(-1, 1);
		correr();
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		salto = true;
		moverse = true;
		velocity.y = jump;
		velocity.x -= speed;
		salto2();
	elif is_on_floor():
		salto = false;
	if velocity.x == 0 and is_on_floor() && salto == false:
		moverse = false;
		normal();
		
			

	if is_on_floor() and Input.is_action_pressed("ui_down") && moverse == false:
		agacharse();

	if is_on_floor() and Input.is_action_pressed("tecla_x") and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		if izquierda == true:
			$Posicion_particulas.scale = Vector2(-1, 1);
			$Golpe.position = Vector2(-97, 0.458);
			$Golpe.scale = Vector2(-1, 1);
		else:
			$Posicion_particulas.scale = Vector2(1, 1);
			$Golpe.position = Vector2(97.384, -0.458);
			$Golpe.scale = Vector2(1, 1)
		golpear2();
		owner.get_node("Enemigo").atacando = true;
		owner.get_node("Enemigo").damage_jugador = 2;
	elif is_on_floor() and Input.is_action_pressed("tecla_c") && moverse == false:
		cubrirse();
		attacking = true;
	elif is_on_floor() and Input.is_action_pressed("tecla_x"):
		if izquierda == true:
			$Golpe.position = Vector2(-97.384, 0.458);
		else:
			$Golpe.position = Vector2(97.384, -0.458);
		golpear();
		owner.get_node("Enemigo").atacando = true;
		owner.get_node("Enemigo").damage_jugador = 1;
		attacking = true;
	elif is_on_floor() and Input.is_action_pressed("tecla_v") && moverse == false:
		Patada();
		owner.get_node("Enemigo").damage_jugador = 1;
		attacking = true;
		owner.get_node("Enemigo").atacando = true;
	elif is_on_floor() and Input.is_action_just_pressed("tecla_z") && moverse == false && ultimate == true:
		golpear3();
		if izquierda == true:
			$Posicion_particulas.scale = Vector2(-1, 1);
			$Golpe.position = Vector2(-97, 0.458);
			$Golpe.scale = Vector2(-1, 1);
		else:
			$Posicion_particulas.scale = Vector2(1, 1);
			$Golpe.position = Vector2(97.384, -0.458);
			$Golpe.scale = Vector2(1, 1);
		owner.get_node("Enemigo").atacando = true;
		attacking = true;
		owner.get_node("Enemigo").damage_jugador = 10;
		ultimate = false;
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

func salto2():
	StateMachine.travel("Salto");

func golpear():
	StateMachine.travel("Golpe1");
	
func golpear2():
	StateMachine.travel("Golpe2");

func golpear3():
	StateMachine.travel("Golpe3");

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

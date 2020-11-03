extends KinematicBody2D

var direccion = Vector2();
var speed = 200;
var jump_speed = -600;
var velocity = Vector2();
var StateMachine;
var acciones = null;
var ataques = null;
var barravidaia;
var barramanaia;
var maxima_vida = 100;
var vida_actual1 = 100;
var maxima_mana = 100;
var mana_actual1 = 0;
var damage_jugador = 0;
var gravity = 100;
var moverseia = false;
var atacar = false;
var direccion_enemiga;
var tiempo_enemigo;
func actualizardamage_jugador():
	vida_actual1 -= damage_jugador;
func actualizarbarravidaia():
	barravidaia.value = vida_actual1 * barravidaia.max_value / maxima_vida;
func actualizarmanaia():
	barramanaia.value = mana_actual1 * barramanaia.max_value / maxima_mana;


func _ready():
	$Cooldown_ataque.start();
	atacar = false;
	moverseia = false;
	StateMachine = $Arboldeanimaciones.get("parameters/playback");
	StateMachine.start("Inmovil");
	barravidaia = get_tree().get_nodes_in_group("hpia")[0];
	barramanaia = get_tree().get_nodes_in_group("energyia")[0];

func _physics_process(delta):
	tiempo_enemigo = $Cooldown_ataque;
	ataques = [Ataque_Fuerte(), Ataque_ligero(), Ataque_combo(), Golpe_Salto()];
	velocity.y += gravity * delta;
	velocity.x = 0;
	actualizarbarravidaia();
	actualizarmanaia();
	movimiento();
	tiempo_enemigo();
func movimiento():
	var objetivo = get_parent().get_node("Personaje");
	if $Eyes_left2.is_colliding():
		$Cuerpo.flip_h = false;
		$golpe.position = Vector2(210, 0);
	elif $Eyes_right2.is_colliding():
		$Cuerpo.flip_h = true;
		$golpe.position = Vector2(0, 0);
	if $Eyes_left.is_colliding():
		$Cuerpo.flip_h = false;
		$Tiempo.start();
	elif $Eyes_right.is_colliding():
		$Tiempo.start();
		$Cuerpo.flip_h = true;
	else:
		Correr();
		moverseia = true;
		move_and_slide(speed * direccion);
		if owner.get_node("Personaje").velocity.y == 0:
			direccion = (objetivo.global_position - global_position).normalized();
func Inmovil():
	StateMachine.travel("Inmovil");
	
func Salto2():
	velocity.y = jump_speed;
	StateMachine.travel("Salto");
	
func Correr():
	if moverseia == true:
		StateMachine.travel("Correr");
func tiempo_enemigo():
	if owner.get_node("Personaje").ataque_enemigo == true:
		$Cooldown_ataque.start();
func Ataque_ligero():
	StateMachine.travel("Ataqueligero");
	owner.get_node("Personaje").damage_enemigo = 2;
func Ataque_Fuerte():
	StateMachine.travel("Ataquefuerte2");
	owner.get_node("Personaje").damage_enemigo = 3;
func Ataque_combo():
	StateMachine.travel("Ataquecombo");
	owner.get_node("Personaje").damage_enemigo = 5;

func Golpe_Salto():
	velocity.y = jump_speed;
	StateMachine.travel("Golpesalto");
	owner.get_node("Personaje").damage_enemigo = 5;

func ataques():
	if atacar == true && moverseia == false:
		randomize();
		var index = randi() %4
		ataques[index];

func _on_Area2D_area_entered(area):
	if area.is_in_group("golpe"):
		actualizardamage_jugador();
		print("hit");


func _on_Tiempo_timeout():
	direccion = Vector2(0,0);
	atacar = true;


func _on_Cooldown_ataque_timeout():
	ataques();
	

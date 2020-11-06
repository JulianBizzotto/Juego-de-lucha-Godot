extends KinematicBody2D

var direccion = Vector2();
var speed = 200;
var jump_speed = -600;
var velocity = Vector2();
var StateMachine;
var acciones = null;
var barravidaia;
var barramanaia;
var maxima_vida = 175;
var vida_actual1 = 175;
var maxima_mana = 100;
var mana_actual1 = 0;
var damage_jugador = 0;
var gravity = 100;
var moverseia = false;
var atacar = false;
var direccion_enemiga;
var tiempo_enemigo;
var colission;
var activable_golpes = 0;
var atacando = false;
func actualizardamage_jugador():
	vida_actual1 -= damage_jugador;
	mana_actual1 = mana_actual1 + damage_jugador;
func actualizarbarravidaia():
	barravidaia.value = vida_actual1 * barravidaia.max_value / maxima_vida;
func actualizarmanaia():
	barramanaia.value = mana_actual1 * barramanaia.max_value / maxima_mana;


func _ready():
	atacando = false;
	mana_actual1 = 0;
	activable_golpes = 0;
	$Cooldown_ataque.start();
	atacar = false;
	moverseia = false;
	StateMachine = $Arboldeanimaciones.get("parameters/playback");
	StateMachine.start("Inmovil");
	barravidaia = get_tree().get_nodes_in_group("hpia")[0];
	barramanaia = get_tree().get_nodes_in_group("energyia")[0];

func _physics_process(delta):
	tiempo_enemigo = $Cooldown_ataque;
	velocity.y += gravity * delta;
	velocity.x = 0;
	actualizarbarravidaia();
	actualizarmanaia();
	movimiento();
	tiempo_enemigo();
	cancel_golpes();
	ataques();
	tiempo_restante();
func movimiento():
	var objetivo = get_parent().get_node("Personaje");
	if $Eyes_left2.is_colliding():
		colission = $Eyes_left2.get_collider()
		if colission == owner.get_node("Personaje/Golpe"):
			$Eyes_left2.add_exception(colission);
		$Cuerpo.flip_h = false;
		$golpe.position = Vector2(0, 0);
		$Posicion_particulas.scale = Vector2(1, 1);
	elif $Eyes_right2.is_colliding():
		colission = $Eyes_right2.get_collider()
		if colission == owner.get_node("Personaje/Golpe"):
			$Eyes_right2.add_exception(colission);
		$Cuerpo.flip_h = true;
		$Posicion_particulas.scale= Vector2(-1, 1);
		$golpe.position = Vector2(-240, 0);
	if $Eyes_left.is_colliding():
		atacar = true;
		$Cuerpo.flip_h = false;
		colission = $Eyes_left.get_collider()
		Inmovil()
		moverseia = false;
		if colission == owner.get_node("Personaje/Golpe"):
			$Eyes_left.add_exception(colission);
	elif $Eyes_right.is_colliding():
		atacar = true;
		$Cuerpo.flip_h = true;
		colission = $Eyes_right.get_collider()
		moverseia = false;
		Inmovil()
		if colission == owner.get_node("Personaje/Golpe"):
			$Eyes_right.add_exception(colission);
	else:
		Correr();
		moverseia = true;
# warning-ignore:return_value_discarded
		move_and_slide(speed * direccion, Vector2.UP);
		if owner.get_node("Personaje").velocity.y == 0:
			direccion = (objetivo.global_position - global_position).normalized();
func Inmovil():
	StateMachine.travel("Inmovil");
	
func Salto2():
	StateMachine.travel("Salto");
	
func Correr():
	if moverseia == true:
		StateMachine.travel("Correr");
# warning-ignore:function_conflicts_variable
func tiempo_enemigo():
	if owner.get_node("Personaje").ataque_enemigo == true:
		$Cooldown_ataque.start();
func Ataque_ligero():
	StateMachine.travel("Ataqueligero");
func Ataque_Fuerte():
	StateMachine.travel("Ataquefuerte2");
	
func Ataque_combo():
	StateMachine.travel("Ataquecombo");

func cancel_golpes():
	if activable_golpes == 13:
		activable_golpes = 0;
func Golpe_Salto():
	StateMachine.travel("Golpesalto");
	owner.get_node("Personaje").damage_enemigo = 2;

func ataques():
	if atacar == true && moverseia == false && atacando == true:
		$Cooldown_ataque.start();
		atacando = false;
		if !activable_golpes == 4 or !activable_golpes == 8 or !activable_golpes == 11 or !activable_golpes == 12 or !activable_golpes == 9:
			Ataque_ligero();
			owner.get_node("Personaje").damage_enemigo = 2;
			activable_golpes = activable_golpes + 1;
		if activable_golpes == 4 or activable_golpes == 8 or activable_golpes == 11:
			Ataque_Fuerte();
			owner.get_node("Personaje").damage_enemigo = 2;
			activable_golpes = activable_golpes + 1;
		if activable_golpes == 12:
			Ataque_combo();
			owner.get_node("Personaje").damage_enemigo = 3;
			activable_golpes = activable_golpes + 1;
		if activable_golpes == 9:
			velocity.y = jump_speed;
			activable_golpes = activable_golpes + 1
			Golpe_Salto();
func _on_Area2D_area_entered(area):
	if area.is_in_group("golpe"):
		actualizardamage_jugador();
		print("hit");
		

func tiempo_restante():
	if atacando == false && $Cooldown_ataque.time_left == 0:
		atacando = true;


func _on_Cooldown_ataque_timeout():
	atacando = true;
	
	
	

extends Node2D

@export var player : CharacterBody2D
@export var enemy : PackedScene
@export var enemy_pool: Node
@export var enemy_types : Array[PackedScene]

var distance : float = 420
var can_spawn : bool = true

var minute : int:
	set(value):
		minute = value
		$Minute.text = str(value)

var second : int:
	set(value):
		second = value
		if second >= 10:
			second -= 10
			minute += 1
		#$Second.text = str(second).lpad(2, '0')

func _ready():
	if enemy_pool:
		print("enemy_pool is correctly assigned")
		enemy_pool.connect("enemy_available", Callable(self, "_on_enemy_available"))
	else:
		print("Error: enemy_pool is null")

func _physics_process(_delta):
	if get_tree().get_node_count_in_group("Enemy") < 700:
		can_spawn = true
	else:
		can_spawn = false

func spawn(pos: Vector2, elite: bool = false):
	if not can_spawn and not elite:
		return

	print("enemy_pool: ", enemy_pool)
	print("enemy_types: ", enemy_types)
	var enemy_instance = enemy_pool.get_available_enemy(enemy_types[min(minute, enemy_types.size() - 1)], pos, player)
	if enemy_instance:
		enemy_instance.elite = elite
		get_tree().current_scene.add_child(enemy_instance)

func _on_timer_timeout():
	second += 1
	amount(second % 10)

func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))

func amount(number : int = 1):
	for i in range(number):
		spawn(get_random_position())

func _on_pattern_timeout():
	for i in range(75):
		spawn(get_random_position())

func _on_elite_timeout():
	spawn(get_random_position(), true)

func _on_enemy_available(enemy):
	# Usa el enemigo que se ha hecho disponible
	pass

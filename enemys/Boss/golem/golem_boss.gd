extends CharacterBody2D
 
@onready var player = get_parent().find_child("Player")
@onready var sprite = $Sprite2D
@onready var progress_bar = $Ui/ProgressBar
@onready var animation_player = $AnimationPlayer
var damage = 0
var direction : Vector2
var DEF = 0
var separation : float
var is_dying = false
 
var health = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0 and not is_dying:
			is_dying = true
			progress_bar.visible = false
			# Remover del grupo de enemies para que el player deje de disparar
			remove_from_group("enemies")
			# Resetear la referencia del nearest_enemy si este boss era el objetivo
			if player.nearest_enemy == self:
				player.nearest_enemy = null
			find_child("FiniteStateMachine").change_state("Death")
			set_process(false)
			set_physics_process(false)
			if animation_player and not animation_player.is_connected("animation_finished", _on_death_animation_finished):
				animation_player.animation_finished.connect(_on_death_animation_finished)
		elif value <= progress_bar.max_value / 2 and DEF == 0:
			DEF = 1
			find_child("FiniteStateMachine").change_state("ArmorBuff") 
 
func _ready():
	set_physics_process(false)
	add_to_group("enemies")
 
func _process(delta):
	if is_dying:
		return
	if player == null:
		return
	direction = player.position - position
	check_separation(delta)
 
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
 
func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
 
func take_damage(amount):
	if is_dying:
		return
	health -= amount - DEF

func check_separation(_delta):
	separation = (player.position - position).length()
	if separation < player.nearest_enemy_distance and not is_dying:
		player.nearest_enemy = self

func _on_death_animation_finished(anim_name: String):
	if anim_name == "Death":
		queue_free()

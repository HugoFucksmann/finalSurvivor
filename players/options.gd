extends VBoxContainer

@export var weapons: HBoxContainer
@export var passive_items: HBoxContainer
var OptionSlot = preload("res://Ui/option_slot.tscn")

@export var particles : GPUParticles2D
@export var panel : NinePatchRect

func _ready():
	hide()
	particles.hide()
	panel.hide()

func close_option():
	hide()
	particles.hide()
	panel.hide()
	get_tree().paused = false
	
func get_aviable_resource_in(items) -> Array[Item]:
	var resurces : Array[Item] = []
	for item in items.get_children():
		if item.item != null:
			resurces.append(item.item)
	return resurces
	
func add_option(item) -> int:
	if item.is_upgradable():
		var option_slot = OptionSlot.instantiate()
		option_slot.item = item
		add_child(option_slot)
		return 1
	return 0
	
func show_option():
	var weapons_aviable = get_aviable_resource_in(weapons)
	var passive_item_aviable = get_aviable_resource_in(passive_items)
	if weapons_aviable.size() == 0 and passive_item_aviable.size() == 0:
		return
		
	for slot in get_children():
		slot.queue_free()
		
	var option_size = 0
	for weapon in weapons_aviable:
		option_size += add_option(weapon)
		
		if weapon.max_level_reached() and weapon.item_needed in passive_item_aviable:
			var option_slot = OptionSlot.instantiate()
			option_slot.item = weapon
			add_child(option_slot)
			option_size += 1
		
	for passive_item in passive_item_aviable:
		option_size += add_option(passive_item)
			
	if option_size == 0:
		return
	show()
	particles.hide()
	panel.hide()
	get_tree().paused = true

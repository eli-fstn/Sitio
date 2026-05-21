extends Node

@onready var hitboxes = {
	"up": $Hitboxes/UHitbox,
	"down": $Hitboxes/DHitbox,
	"left": $Hitboxes/LHitbox,
	"right": $Hitboxes/RHitbox
}

func attack(direction: String):
	var hb = hitboxes[direction]

	# reset hit tracking on all hurtboxes in scene
	_reset_hurtboxes()

	hb.active = true
	await get_tree().create_timer(0.15).timeout
	hb.active = false

func _reset_hurtboxes():
	for h in get_tree().get_nodes_in_group("hurtbox"):
		h.already_hit.clear()

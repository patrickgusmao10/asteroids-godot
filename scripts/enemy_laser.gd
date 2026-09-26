extends Area2D

var direction := Vector2.ZERO
var speed := 300.0

func _physics_process(delta):
	global_position += direction * speed * delta

func setup(new_direction: Vector2, new_speed: float):
	direction = new_direction.normalized()
	speed = new_speed
	
	rotation = direction.angle()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	print("EnemyLaser entrou na Area2D: ", area.name)
	
	if area.name == "Shield":
		var player = area.get_parent()
		
		if player.shield_active:
			player.shield_hit_effect()
			print("SHIELD DETECTADO - DELETANDO LASER")
			queue_free()

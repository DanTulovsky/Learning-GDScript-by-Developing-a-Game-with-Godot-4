extends Collectible

@export var health_points: int = 1

func _on_area_2d_body_entered(body):
   body.add_health_points(health_points)
   queue_free()

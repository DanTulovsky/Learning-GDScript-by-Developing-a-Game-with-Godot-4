extends Collectible

func _on_area_2d_body_entered(body):
   body.add_coin()
   queue_free()

extends ParallaxBackground

const scrolling_speed = 150

func _process(delta):
	scroll_base_offset.x -= scrolling_speed * delta

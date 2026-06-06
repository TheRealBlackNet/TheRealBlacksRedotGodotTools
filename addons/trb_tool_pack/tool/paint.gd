class_name Paint


static func line(img:Image, start:Vector2, end:Vector2, col:Color):
	var lastPixel:Vector2i = Vector2i(-1,-1)
	var steps:float = ceilf(10.0 * (end - start).length())

	for step in range(0, steps+1):
		var cur:Vector2 = start.lerp(end, (float(step) / float(steps)))
		var cpixel:Vector2i = Vector2i(cur)
		if (cpixel.x != lastPixel.x or cpixel.y != lastPixel.y):
			lastPixel = cpixel
			if lastPixel.x >= 0 and lastPixel.x < img.get_width()\
					and lastPixel.y >= 0 and lastPixel.y < img.get_height():
				img.set_pixelv(lastPixel, col)

static func circle(img:Image, mid:Vector2, radius:float, col:Color):
	var lastPixel:Vector2i = Vector2i(-1,-1)

	for step in range(0, 360*4):
		var cpixel:Vector2i = Vector2i(mid + Vector2(radius,0)\
			.rotated(deg_to_rad(float(step)/4.0)))
		if (cpixel.x != lastPixel.x or cpixel.y != lastPixel.y):
			lastPixel = cpixel
			if lastPixel.x >= 0 and lastPixel.x < img.get_width()\
					and lastPixel.y >= 0 and lastPixel.y < img.get_height():
				img.set_pixelv(lastPixel, col)

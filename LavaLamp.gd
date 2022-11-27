extends Sprite

const MAX_FRAMES = 120
var frame_count = 0
# ezgift.com/maker -> Create gifs with PNGs
func _ready():
	Engine.set_target_fps(15)
	get_tree().get_root().set_transparent_background(true)
	# Turn off for not creating PNGs
	# VisualServer.connect("frame_post_draw", self, "save_frame")

func save_frame():
	if frame_count < MAX_FRAMES:
		var image = get_tree().get_root().get_texture().get_data()
		var image_name = ""
		for i in range(len(str(MAX_FRAMES)) - len(str(frame_count))):
			image_name += "0"
		image_name += str(frame_count) + ".png"
		image.convert(Image.FORMAT_RGBA8)
		image.flip_y()
		image.save_png(image_name)
		frame_count += 1

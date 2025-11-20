extends ColorRect

var shader_material: ShaderMaterial = null

func make_palette(colors: Array) -> PackedColorArray:
	var total_steps:			int = 256
	var num_segments:		int = colors.size()
	
	var max_steps_per_segment: int = total_steps / num_segments
	
	var red_step_rate:		Array = []
	var green_step_rate:		Array = []
	var blue_step_rate:		Array = []
	
	for i in range( num_segments ):
		var j: int = ( i + 1 ) % num_segments
		
		var color_i = Color( colors[i].r / 255.0, colors[i].g / 255.0, colors[i].b / 255.0 )
		var color_j = Color( colors[j].r / 255.0, colors[j].g / 255.0, colors[j].b / 255.0 ) 
		
		red_step_rate.append		( ( color_i.r - color_j.r ) / float( max_steps_per_segment ) )
		green_step_rate.append	( ( color_i.g - color_j.g ) / float( max_steps_per_segment ) )
		blue_step_rate.append	( ( color_i.b - color_j.b ) / float( max_steps_per_segment ) )
		
	var palette_array: PackedColorArray
	
	for i in range( num_segments ):
		var color_start = Color( colors[i].r / 250.0, colors[i].g / 250.0, colors[i].b / 250.0 )
		
		for step in range( max_steps_per_segment + 1 ):
			if palette_array.size() >= total_steps:
				break
			
			var r = color_start.r - red_step_rate[i] 	* float( step )
			var g = color_start.g - green_step_rate[i]	* float( step )
			var b = color_start.b - blue_step_rate[i]	* float( step )
			
			var final_color = Color(		clamp( r, 0.0, 1.0 ),
										clamp( g, 0.0, 1.0 ),
										clamp( b, 0.0, 1.0 ) )
			palette_array.append( final_color )
	return palette_array

func create_palette_texture( palette_array: PackedColorArray ) -> Texture2D:
	var width =		palette_array.size()
	var height =		1
	
	var image = Image.create( width, height, false, Image.FORMAT_RGBA8 )
	image.set_data( width, height, false, Image.FORMAT_RGBA8, palette_array.to_byte_array() )
	var texture = ImageTexture.create_from_image( image )
	
	return texture
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader_material = get_material()
	if shader_material == null: return
	
	var input_colors = [
		{"r": 255,	"g": 0,		"b": 0},		#RED
		{"r": 0,		"g": 255,	"b": 0},		#GREEN
		{"r": 0,		"g": 0,		"b": 255}	#BLUE
	]
	
	var palette_array =		make_palette( input_colors )
	var palette_texture =	create_palette_texture( palette_array )
	shader_material.set_shader_parameter("lut_texture", palette_texture)
	set_process(true)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

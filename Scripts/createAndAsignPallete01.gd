extends ColorRect

#Program to create a lut texture and asign it to a radial wave

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
		
	var palette_array: PackedColorArray = []
	
	for i in range( num_segments ):
		var color_start = Color( colors[i].r / 255.0, colors[i].g / 255.0, colors[i].b / 255.0 )
		
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
	
	var raw_bytes = PackedByteArray()
	
	for color in palette_array:
		# RGBA8 format expects 4 bytes per pixel.
		# We cast the component float value * 255.0 to an integer byte.
		raw_bytes.append( int(color.r * 255.0 ) ) # Red (R)
		raw_bytes.append( int(color.g * 255.0 ) ) # Green (G)
		raw_bytes.append( int(color.b * 255.0 ) ) # Blue (B)
		raw_bytes.append( int(color.a * 255.0 ) ) # Alpha (A)
	
	var final_image = Image.create_from_data(
		width, 
		height, 
		false, # No mipmaps
		Image.FORMAT_RGBA8, 
		raw_bytes
	)
	#Save the file to dir
	var file_path =		'res://imgs/lookup.png'
	var error =			final_image.save_png(file_path)
	
	if error != OK:
		push_error( "Failed to save LUT image to disk: ", error )
	else:
		print( "Successfully saved LUT to: ", file_path )
	
	var texture = ImageTexture.create_from_image( final_image )
	
	return texture
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader_material =		get_material()
	if shader_material ==	null: return

# passes init values to the params_array[3] inside the shader	
#	var wave_params_array = [
#		Vector4( 1.0, 0.0, 0.0, 10.0 ),	#Params for Wave1
#		Vector4( 0.0, 1.0, 0.0, 15.0 ),	#Params for Wave2
#		Vector4( 1.0, 1.0, 0.0, 20.0 )	#Params for Wave3
#	]
	
#	shader_material.set_shader_parameter( "wave_params", wave_params_array )
	
	var input_colors = [
		{"r": 255,	"g": 0,		"b": 0},		#RED
		{"r": 0,		"g": 255,	"b": 0},		#GREEN
		{"r": 0,		"g": 0,		"b": 255}	#BLUE
	]
	
	var palette_array =		make_palette( input_colors )
	var palette_texture =	create_palette_texture( palette_array )
	shader_material.set_shader_parameter( "lut_texture", palette_texture )
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( delta: float ) -> void:
	pass

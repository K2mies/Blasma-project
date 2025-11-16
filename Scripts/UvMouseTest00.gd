extends ColorRect
var shader_material: ShaderMaterial = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the material reference
	shader_material = get_material()
	if shader_material == null: return
	# Set the resolution once (or update on resize)
	var screen_size = get_viewport_rect().size
	shader_material.set_shader_parameter("u_resolution", screen_size)
	# Enable processing to get constant updates
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Ensure the material is valid before trying to set parameters
	if shader_material != null:
		# 3. Pass the current time (optional, but good practice)
		shader_material.set_shader_parameter("u_time", Time.get_ticks_msec() / 1000.0)
		# 4. Update the mouse position every frame
		# get_viewport().get_mouse_position() returns the mouse position in GLOBAL coordinates
		var mouse_pos = get_viewport().get_mouse_position()
		shader_material.set_shader_parameter("u_mouse", mouse_pos)

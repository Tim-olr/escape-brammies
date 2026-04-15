extends Interactable
class_name ElectricalBox

## The wires pickup scene to drop when the task is completed.
@export var wires_pickup_scene: PackedScene = null

var _ui: ElectricalBoxUI
var _completed: bool = false

@onready var indicator: MeshInstance3D = $IndicatorLight

func _ready() -> void:
	goes_away_on_interact = false
	_ui = ElectricalBoxUI.new()
	add_child(_ui)

func interact() -> bool:
	if _completed:
		GlobalPlayer.promptinstance.show_prompt("Already fixed.", 1.5)
		return false
	_ui.open(_on_task_complete)
	return false

func _on_task_complete() -> void:
	_completed = true

	_spawn_sparks()

	# Turn indicator green
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.1, 1.0, 0.1, 1)
	mat.emission_enabled = true
	mat.emission = Color(0.1, 1.0, 0.1, 1)
	mat.emission_energy_multiplier = 3.0
	indicator.set_surface_override_material(0, mat)

	# Drop the wires pickup in front of the box
	var scene := wires_pickup_scene
	if scene == null:
		scene = load("res://Items/interactables/repair_pickups/wires_pickup.tscn")
	if scene != null:
		var pickup := scene.instantiate()
		get_tree().current_scene.add_child(pickup)
		var drop_pos := global_position + global_transform.basis.z * 0.5
		var space := get_world_3d().direct_space_state
		var query := PhysicsRayQueryParameters3D.create(drop_pos + Vector3.UP * 0.5, drop_pos + Vector3.DOWN * 10.0)
		query.exclude = [get_rid()]
		var hit := space.intersect_ray(query)
		if hit:
			drop_pos = hit.position + Vector3.UP * 0.2
		pickup.global_position = drop_pos

	GlobalPlayer.promptinstance.show_prompt("Wiring fixed!", 2.0)

func _spawn_sparks() -> void:
	var particles := GPUParticles3D.new()
	add_child(particles)
	particles.position = Vector3(0, 0, 0.06)  # just in front of the panel

	var mat := ParticleProcessMaterial.new()
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	mat.emission_sphere_radius = 0.04
	mat.direction = Vector3(0, 1, 0)
	mat.spread = 70.0
	mat.initial_velocity_min = 0.8
	mat.initial_velocity_max = 2.5
	mat.gravity = Vector3(0, -5.0, 0)
	mat.scale_min = 0.6
	mat.scale_max = 1.2

	var gradient := Gradient.new()
	gradient.set_color(0, Color(1.0, 0.95, 0.4, 1.0))
	gradient.set_color(1, Color(1.0, 0.3, 0.0, 0.0))
	var ramp := GradientTexture1D.new()
	ramp.gradient = gradient
	mat.color_ramp = ramp

	var spark_mat := StandardMaterial3D.new()
	spark_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	spark_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	spark_mat.emission_enabled = true
	spark_mat.emission = Color(1.0, 0.8, 0.2)
	spark_mat.emission_energy_multiplier = 2.0
	spark_mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED

	var mesh := QuadMesh.new()
	mesh.size = Vector2(0.02, 0.02)
	mesh.material = spark_mat

	particles.process_material = mat
	particles.draw_pass_1 = mesh
	particles.amount = 40
	particles.lifetime = 0.9
	particles.explosiveness = 0.85
	particles.one_shot = true
	particles.emitting = true

	# Clean up once done
	await get_tree().create_timer(particles.lifetime + 0.3).timeout
	particles.queue_free()

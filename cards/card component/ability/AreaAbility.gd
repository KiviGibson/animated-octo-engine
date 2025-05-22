class_name AreaAbility

extends Ability
var areaOfEffect: Area3D
@export_category("this ability require cleanup on discard")
@export var radius: float
# 
func execute(_position: Vector3, caster: Unit) -> void:
	var collider := CollisionShape3D.new()
	collider.shape = SphereShape3D.new()
	collider.shape.radius = radius
	areaOfEffect = Area3D.new()
	areaOfEffect.add_child(collider)
	caster.add_child(areaOfEffect)

func clean_up() -> void:
	areaOfEffect.get_parent().remove_child(areaOfEffect)
	areaOfEffect.queue_free()

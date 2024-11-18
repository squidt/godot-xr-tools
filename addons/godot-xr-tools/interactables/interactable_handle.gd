@tool
class_name XRToolsInteractableHandle
extends XRToolsPickable


## XR Tools Interactable Handle script
##
## The interactable handle is a (usually invisible) object extending from
## [XRToolsPickable] that can be grabbed by the player and is used to
## manipulate interactable objects.
##
## The interactible handle has an origin position of its parent. In order
## to position interactible handles on the interactible object, the handle
## should be placed under a parent handle-origin node, and the origin nodes
## position set as desired.
##
## When the handle is released, it snaps back to its parent origin. If the
## handle is pulled further than its snap distance, then the handle is
## automatically released.


## Distance from the handle origin to auto-snap the grab
@export var snap_distance : float = 0.3


# Handle origin excluding grab movement
var handle_origin: Vector3


# Add support for is_xr_class on XRTools classes
func is_xr_class(name : String) -> bool:
	return name == "XRToolsInteractableHandle" or super(name)


# Called when this handle is added to the scene
func _ready() -> void:
	# In Godot 4 we must now manually call our super class ready function
	super()

	# freeze when not activated
	freeze = true

	# Ensure we start at our origin
	handle_origin = position

	# Turn off processing - it will be turned on only when held
	set_process(false)


# Called on every frame when the handle is held to check for snapping
func _process(_delta: float) -> void:
	# Skip if not picked up
	if not is_picked_up():
		return

	# If too far from the origin then drop the handle
	if position.distance_to(handle_origin) > snap_distance:
		drop()


# Called when the handle is picked up
func pick_up(by) -> void:
	# Call the base-class to perform the pickup
	super(by)

	# Enable the process function while held
	set_process(true)


# Called when the handle is dropped
func let_go(by: Node3D, _p_linear_velocity: Vector3, _p_angular_velocity: Vector3) -> void:
	# Call the base-class to perform the drop, but with no velocity
	super(by, Vector3.ZERO, Vector3.ZERO)

	# Disable the process function as no-longer held
	set_process(false)

	# Snap the handle back to the origin
	position = handle_origin

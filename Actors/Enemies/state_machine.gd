extends Node

@export var initial_state : State
var cur_state : State
var states: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.Transition.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		cur_state = initial_state
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cur_state:
		cur_state.Update(delta)

func _physics_process(delta: float) -> void:
	if cur_state:
		cur_state.Physic_Update(delta)

func on_child_transition(state, new_state_name):
	if !cur_state:
		return
	var new_state = state.get(new_state_name.toLower())
	
	if !new_state:
		return
		

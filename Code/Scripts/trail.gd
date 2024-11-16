extends Node2D

@export var trailColor : Color
@export var totalDistance : float
@export var distanceAddedByButter : float
@export var startLineWidth : float

var toast : RigidBody2D
var target : Sprite2D
var slowedDown : bool = false
var Segments : Array = []


func _init() -> void:
	var firstSegment : Line2D = Line2D.new()
	setSegmentDefaultParams(firstSegment)
	Segments.append(firstSegment)
	add_child(firstSegment)

func _ready() -> void:
	target = get_parent().get_parent().get_node("Target")

func _process(delta: float) -> void:
	if getSegmentWidth() < 0.0 and slowedDown == false:
		toast.linear_damp = 0.7
		slowedDown = true
	
	if (toast.global_position - target.global_position).length() < 10000:
		if getDistanceFromLastPoint(toast.position) > 5:
			createNewSegment(toast.position)

func setTrailToast(_toast : RigidBody2D) -> void:
	toast = _toast
	toast.connect("toastTookButter", toastTookButter)

func setInitialPoisition(initToastPosition : Vector2) -> void:
	Segments[0].add_point(initToastPosition)
	Segments[0].add_point(initToastPosition)

func getTotalDistance() -> float:
	var totalDistance : float = 0
	for segment in Segments:
		totalDistance += (segment.points[1] - segment.points[0]).length()
	return totalDistance

func getDistanceFromLastPoint(toastPosition : Vector2) -> float:
	return (Segments[-1].points[-1] - toastPosition).length()
	
func createNewSegment(toastPosition : Vector2) -> void:
	var newSegment : Line2D = Line2D.new()
	newSegment.add_point(Segments[-1].points[-1])
	newSegment.add_point(toastPosition)
	setSegmentDefaultParams(newSegment)
	newSegment.width = getSegmentWidth()
	Segments.append(newSegment)
	add_child(newSegment)
	
func setSegmentDefaultParams(segment : Line2D) -> void:
	segment.default_color = trailColor
	segment.joint_mode = Line2D.LINE_JOINT_ROUND
	segment.begin_cap_mode = Line2D.LINE_CAP_ROUND
	segment.end_cap_mode = Line2D.LINE_CAP_ROUND

func toastTookButter(toast : RigidBody2D) -> void:
	totalDistance += distanceAddedByButter

func getSegmentWidth() -> float:
	var widthProportion : float = inverse_lerp(0, totalDistance, getTotalDistance())
	return lerp(startLineWidth, 0.0, widthProportion)

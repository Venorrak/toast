extends Node2D
class_name Grid

@export var gridSize : Vector2
@export var nbOfRows : int
@export var nbOfColumns : int
@export var amountNear : int

var halfCellSize : Vector2
var cellSize : Vector2
var enabledCells : Array = []

func _ready() -> void:
	var xCellSize : float = gridSize.x / nbOfColumns
	var yCellSize : float = gridSize.y / nbOfRows
	cellSize = Vector2(xCellSize, yCellSize)
	halfCellSize = Vector2(xCellSize / 2, yCellSize / 2) 

func getCellCenterPosition(cell : Vector2) -> Vector2:
	if isOutOfBounds(cell):
		return Vector2(0,0)
	else:
		return Vector2((cell.x * cellSize.x) + halfCellSize.x, (cell.y * cellSize.y) + halfCellSize.y)
		
func isOutOfBounds(cell : Vector2) -> bool:
	if cell.x > nbOfColumns - 1 or cell.x < 0 or cell.y > nbOfRows - 1 or cell.y < 0:
		return true
	else:
		return false

func isNearEnabledCell(cell : Vector2) -> bool:
	for x in range(cell.x - amountNear, cell.x + amountNear):
		for y in range(cell.y - amountNear, cell.y + amountNear):
			if enabledCells.has(Vector2(x,y)):
				return true
	return false

func enableCell(cell : Vector2) -> void:
	if not isOutOfBounds(cell):
		enabledCells.append(cell)
		
func isCellEnabled(cell : Vector2) -> bool:
	if enabledCells.has(cell):
		return true
	return false
	
func numberEnabledInRow(row : int) -> int:
	var count : int = 0
	for ena in enabledCells:
		if ena.y == row:
			count += 1
	return count
	
func numberEnabledInColumn(col : int) -> int:
	var count : int = 0
	for ena in enabledCells:
		if ena.x == col:
			count += 1
	return count

func isNextToEnabled(cell : Vector2) -> bool:
	for x in range(-1 , 2):
		for y in range(-1, 2):
			if not cell == Vector2(x, y):
				if enabledCells.has(Vector2(cell.x + x, cell.y + y)):
					return true
	return false

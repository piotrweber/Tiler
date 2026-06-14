extends Node
class_name PlatformDiscovery

## Setup service: 
## - reads the tilemap
## - writes tiley_by_cell and platforms
## - gives each tile its identity

## Build
func build(layer : PlatformTileLayer):
	read_tilemap(layer)
	build_platforms(layer)
	
	
func read_tilemap(layer : PlatformTileLayer):
	# Get all the tile scenes
	for child in layer.get_children():
		if child is BaseTile:
			# Get the position on the tilemap
			var cell : Vector2i = layer.local_to_map(child.position)
			# Save to dict
			layer.tiles_by_cell[cell] = child
	
	
func build_platforms(layer : PlatformTileLayer):
	# get all the positions (keys)
	var cells : Array = layer.tiles_by_cell.keys()
	# sort them so that they always stays the same across runs
	cells.sort()
	
	var groups : Array = flood_fill(cells)
	# Setup all tiles
	for i in groups.size():
		layer.platforms.append({
			cells = groups[i],
			stepped = {},
			is_locked = false
		})
		for cell : Vector2i in groups[i]:
			var tile : BaseTile = layer.tiles_by_cell[cell]
			tile.setup(cell,i,neighbor_mask(layer, cell))
		

# takes a flat list of tile cells and splits them into groups 
# of connected tiles — each group becomes one platform.
# It works by visiting every cell once. 
# When it finds an unvisited cell, 
# it explores outward in all four directions 
# (up/right/down/left), collecting every tile reachable without gaps. 
# The result is an array of arrays: [[cells of platform 0], [cells of platform 1], ...], 
# which build_platforms then uses to assign each tile its platform_id.
# DOESNT? WORK FOR DIAGONALS NOR SINGLES
func flood_fill(cells: Array) -> Array:
	# Build a set of all cells so we can mark them visited in O(1)
	var unvisited := {}
	for c in cells:
		unvisited[c] = true

	var groups: Array = []
	for start in cells:
		# Skip cells already claimed by a previous group
		if not unvisited.has(start):
			continue
		# BFS/DFS from this unvisited cell to find all connected neighbours
		var stack: Array[Vector2i] = [start]
		var group: Array[Vector2i] = []
		while not stack.is_empty():
			var cell: Vector2i = stack.pop_back()
			# Already visited (reached via another path in the stack)
			if not unvisited.has(cell):
				continue
			# Claim this cell for the current group
			unvisited.erase(cell)
			group.append(cell)
			# Queue any unvisited orthogonal neighbours
			for dir in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
				if unvisited.has(cell + dir):
					stack.append(cell + dir)
		# All cells reachable from `start` form one platform group
		groups.append(group)
	return groups
 
 
func neighbor_mask(layer: PlatformTileLayer, cell: Vector2i) -> int:
	var m := 0
	if layer.tiles_by_cell.has(cell + Vector2i.UP):    m |= 1
	if layer.tiles_by_cell.has(cell + Vector2i.RIGHT): m |= 2
	if layer.tiles_by_cell.has(cell + Vector2i.DOWN):  m |= 4
	if layer.tiles_by_cell.has(cell + Vector2i.LEFT):  m |= 8
	return m

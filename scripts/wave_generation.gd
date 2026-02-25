extends Node2D

# ===== WAVE GENERATION FUNCTIONS =====
# A "wave" is a group of enemies that get spawned together.
# Each wave function below creates a different pattern of enemies.
#
# Every wave function returns an Array (a list) of enemies.
# Each enemy in the list is a dictionary with 3 pieces of info:
#   "type"    - what kind of enemy: 'enemy' or 'star'
#   "angle"   - what direction they come from (in radians, 0 to TAU)
#   "blocked" - whether the enemy can be blocked by the player (true/false)
#
# TAU is a built-in Godot constant equal to 2*PI (~6.28).
# Think of it like a full circle: 0 = right, TAU/4 = down, TAU/2 = left, etc.


# This function picks a random wave type and runs it.
# You don't need to change this — just add your new wave function
# to the wave_functions list below and it will get picked automatically!
func generate_new_wave() -> Array:
	# ADD YOUR NEW WAVE FUNCTION TO THIS LIST to include it in the game!
	var wave_functions = [
		generate_wave_random,
		generate_wave_circle,
		generate_wave_line,
	]
	
	# Pick one of the wave functions above at random
	var wave_func = wave_functions.pick_random()
	
	# Call the chosen function to get the list of enemies
	var enemies = wave_func.call()
	
	print("New wave started: ", wave_func.get_method(), " with ", enemies.size(), " enemies")
	return enemies


# ===== WAVE TYPES =====
# Want to make your own wave? Copy one of these functions, give it a new name,
# and change the angles, counts, or types to create a new pattern!
# Then add it to the wave_functions list in generate_new_wave() above.


# RANDOM WAVE
# Enemies come from completely random directions.
# A small chance (20%) that an enemy is a 'star' instead.
func generate_wave_random() -> Array:
	var enemies = []
	
	# Pick a random number of enemies between 5 and 15
	var count = randi_range(5, 15)
	
	for i in count:
		# 20% chance of being a star, otherwise it's a regular enemy
		var type = 'star' if randf() <= 0.2 else 'enemy'
		
		enemies.append({
			"type": type,
			"angle": randf() * TAU,  # Random direction (anywhere around the circle)
			"blocked": (type == 'enemy')  # Stars can't be blocked, enemies can
		})
	
	return enemies


# CIRCLE WAVE
# Enemies are spread evenly all the way around the player, like a ring closing in.
func generate_wave_circle() -> Array:
	var enemies = []
	
	# Pick a random number of enemies between 8 and 18
	var count = randi_range(8, 18)
	
	# Rotate the whole circle by a random amount so it's not always the same orientation
	var angle_modifier = randi_range(0, 359)
	
	for i in count:
		# Divide the full circle equally between all enemies
		# e.g. 8 enemies = one every 45 degrees
		enemies.append({
			"type": 'enemy',
			"angle": (TAU / count) * i + angle_modifier,
			"blocked": true
		})
	
	return enemies


# LINE WAVE
# All enemies come from roughly the same direction, like a swarm charging from one side.
func generate_wave_line() -> Array:
	var enemies = []
	
	# Pick a random number of enemies between 4 and 10
	var count = randi_range(4, 10)
	
	# Pick a random base direction for the whole group
	var base_angle = randf() * TAU
	
	for i in count:
		# Each enemy is aimed very close to the base direction, with a tiny random spread
		# The "(randf() - 0.5) * 0.3" part nudges each enemy slightly left or right
		# so they don't all overlap perfectly
		enemies.append({
			"type": 'enemy',
			"angle": base_angle + (randf() - 0.5) * 0.3,
			"blocked": true
		})
	
	return enemies

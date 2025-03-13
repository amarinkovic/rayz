import bpy
import math

# Create (or get) a new collection for the generated objects
collection_name = "SpiralCubes"
if collection_name in bpy.data.collections:
    spiral_collection = bpy.data.collections[collection_name]
else:
    spiral_collection = bpy.data.collections.new(collection_name)
    bpy.context.scene.collection.children.link(spiral_collection)

# Parameters for the spiral
num_cubes = 50                # Total number of cubes
angle_increment = math.radians(15)  # Angular increment (15 degrees per cube)
radius = 5.0                  # Radius of the spiral
height_increment = 0.2        # Vertical distance between cubes

for i in range(num_cubes):
    angle = i * angle_increment
    # Calculate the (x, y, z) coordinates for the current cube along a helix
    x = radius * math.cos(angle)
    y = radius * math.sin(angle)
    z = i * height_increment

    # Add a cube at the computed location
    bpy.ops.mesh.primitive_cube_add(size=1, location=(x, y, z))
    cube = bpy.context.active_object

    # Rotate the cube around all three axes for a dynamic effect
    cube.rotation_euler = (angle, angle, angle)

    # Optionally, scale each cube slightly to add variation
    scale_factor = 1.0 + 0.02 * i
    cube.scale = (scale_factor, scale_factor, scale_factor)

    # Link the cube to the spiral_collection
    spiral_collection.objects.link(cube)
    
    # Unlink the cube from all other collections except spiral_collection
    for coll in list(cube.users_collection):
        if coll != spiral_collection:
            coll.objects.unlink(cube)

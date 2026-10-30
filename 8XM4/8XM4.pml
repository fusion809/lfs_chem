
from pymol import cmd

# Fetch the PDB structure
cmd.fetch("8XM4", name="8XM4", type="cif", async_=0)

# General rendering settings
cmd.bg_color("white")
cmd.set("ray_opaque_background", 1)
cmd.set("antialias", 2)
cmd.set("valence", 1)
cmd.set("stick_radius", 0.18)
cmd.set("sphere_scale", 0.25)

# Separate macromolecule, small molecules and solvent
cmd.select("macromolecule", "8XM4 and polymer")
cmd.select("small_molecules", "8XM4 and not polymer and not solvent")
cmd.select("solvent", "8XM4 and solvent")

# Add hydrogens to small molecules
cmd.h_add("small_molecules")

# Select all small-molecule atoms, including added hydrogens
cmd.select("ligand_atoms", "small_molecules")

# Hide all default representations
cmd.hide("everything", "all")

# Macromolecule: cartoon representation
cmd.show("cartoon", "macromolecule")

# Colour by secondary structure
cmd.color("red", "macromolecule and ss H")
cmd.color("yellow", "macromolecule and ss S")
cmd.color("green", "macromolecule and not (ss H or ss S)")

# Small molecules: ball-and-stick representation
cmd.show("sticks", "ligand_atoms")
cmd.show("spheres", "ligand_atoms")

# CPK colouring, with black carbon atoms
cmd.util.cbag("ligand_atoms")
cmd.color("black", "ligand_atoms and elem C")
cmd.color("white", "ligand_atoms and elem H")

# Explicitly ensure hydrogen atoms are visible
cmd.show("sticks", "ligand_atoms and elem H")
cmd.show("spheres", "ligand_atoms and elem H")

# Representation dimensions
cmd.set("stick_radius", 0.18, "ligand_atoms")
cmd.set("sphere_scale", 0.25, "ligand_atoms")
cmd.set("sphere_scale", 0.22, "ligand_atoms and elem H")

# Cartoon appearance
cmd.set("cartoon_fancy_helices", 1)
cmd.set("cartoon_smooth_loops", 1)

# Lighting and material
cmd.set("specular", 0.25)
cmd.set("shininess", 35)

# Centre and orient the structure
cmd.orient("8XM4")
cmd.zoom("8XM4", 5)

# Rebuild representations
cmd.rebuild()

# Report the number of added hydrogen atoms
print("Small-molecule hydrogen atoms:",
      cmd.count_atoms("ligand_atoms and elem H"))

from pathlib import Path
import math

# Use the directory containing the exported POV file
pov_file = Path.cwd() / "8XM4.pov"
ini_file = Path.cwd() / "8XM4.ini"

if not pov_file.is_file():
    raise FileNotFoundError(f"POV-Ray scene not found: {pov_file}")

# Preserve the current PyMOL viewport aspect ratio
viewport_width, viewport_height = cmd.get_viewport()
aspect_ratio = viewport_width / viewport_height

# Calculate approximately 50 megapixels
target_pixels = 50_000_000
width = round(math.sqrt(target_pixels * aspect_ratio))
height = round(target_pixels / width)

# Create the POV-Ray INI file
ini_file.write_text(
    f"""Input_File_Name="{pov_file.name}"
Output_File_Name="8XM4_50MP.png"
Output_File_Type=N
Width={width}
Height={height}
Antialias=On
Antialias_Threshold=0.1
Antialias_Depth=3
Display=Off
Verbose=On
"""
)

print(f"Created: {ini_file}")
print(f"Resolution: {width} x {height}")
print(f"Pixel count: {width * height:,}")
python
from pathlib import Path

ini_file = Path("8XM4.ini")

ini_file.write_text("""Input_File_Name="8XM4.pov"
Output_File_Name="8XM4_50MP.png"
Output_File_Type=N
Width=10711
Height=4668
Antialias=On
Antialias_Threshold=0.1
Antialias_Depth=3
Display=Off
Verbose=On
""")

print(f"Created POV-Ray INI file: {ini_file.resolve()}")
python end

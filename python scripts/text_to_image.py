import numpy as np
import cv2
import os

# ============
# SET YOUR LOCAL PATH HERE
# Ensure this matches the output file from your Verilog simulation
image_path = 'edge_output.txt' 

# Image size (MUST match your Verilog testbench parameters)
WIDTH  = 512
HEIGHT = 512

if not os.path.exists(image_path):
    print(f"Error: Could not find {image_path} in {os.getcwd()}")
    exit()

# Read pixel values
print(f"Reading {image_path}...")
with open(image_path, "r") as f:
    pixels = f.readlines()

# Convert to integers, replace 'x' or 'X' (undefined Verilog states) with 0
pixels_clean = []
for p in pixels:
    p = p.strip()
    if p.lower() == 'x' or p == '':  # handles 'x', 'X', or empty lines
        pixels_clean.append(0)
    else:
        try:
            # Try to handle both decimal and hex if needed
            pixels_clean.append(int(p, 10)) 
        except ValueError:
            pixels_clean.append(0)

# Check total pixels and fix if necessary
expected_count = WIDTH * HEIGHT
actual_count = len(pixels_clean)

if actual_count != expected_count:
    print(f"⚠️ Warning: Expected {expected_count} pixels, got {actual_count}")
    if actual_count < expected_count:
        pixels_clean += [0] * (expected_count - actual_count)
    else:
        pixels_clean = pixels_clean[:expected_count]

# Convert to NumPy array and reshape
img_array = np.array(pixels_clean, dtype=np.uint8)
img_array = img_array.reshape((HEIGHT, WIDTH))

# Save the reconstructed image
output_filename = "reconstructed_edge_image.png"
cv2.imwrite(output_filename, img_array)

# Display the result locally
cv2.imshow("Reconstructed Edge Detection", img_array)
print(f"✅ Image saved as {output_filename}")
print("Press any key on the image window to close.")

cv2.waitKey(0)
cv2.destroyAllWindows()

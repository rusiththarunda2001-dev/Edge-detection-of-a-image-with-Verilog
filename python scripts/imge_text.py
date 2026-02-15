import cv2
import numpy as np
import matplotlib.pyplot as plt
import os

# ============ 
# SET YOUR IMAGE PATH HERE
# Use a relative path or a full local path (e.g., 'C:/Users/Name/Pictures/image.jpg')
image_path = 'tiger-tigr-vzglyad-tvkk.jpg' 

# Load image in grayscale
img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)

if img is None:
    print(f"Error: Image not found at {os.path.abspath(image_path)}")
else:
    height, width = img.shape
    print(f"Image size: {width} x {height}")

    # Display the image using standard OpenCV window
    cv2.imshow('Original Grayscale Image', img)
    
    # Standard way to keep the window open until a key is pressed
    print("Press any key on the image window to continue...")
    cv2.waitKey(0) 
    cv2.destroyAllWindows()

    # Save decimal pixel values to a text file in the current folder
    output_file = "nature_decimal.txt"
    with open(output_file, "w") as f:
        for row in range(height):
            for col in range(width):
                f.write(f"{int(img[row, col])}\n")

    print(f"{output_file} created successfully in {os.getcwd()} ✅")

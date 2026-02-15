

---

# 🖼️ Sobel Edge Detection Using Verilog (Simulation-Based Implementation)

### 📌 Project Overview

This project implements the **Sobel Edge Detection algorithm** using **Verilog HDL** for simulation purposes. The system processes a grayscale image stored in a text file, applies the Sobel operator using a 3×3 sliding window architecture, and generates an output text file containing edge-detected pixel values.

**The design is intended for:**

* Digital Design Laboratories
* FPGA Image Processing Fundamentals
* HDL-based Image Processing Simulation

> ⚠️ **Note:** This implementation uses file I/O system tasks (`$fopen`, `$fscanf`, `$fwrite`) and is meant for **simulation only**. It is not synthesizable for FPGA hardware.

---

### 🏗️ System Architecture

1. **Input Image (.jpg)** 2. **Pre-processing (Python):** Convert to Grayscale & Resize (512×512)
2. **Data Prep:** Convert to Text File (`nature_decimal.txt`)
3. **Verilog Simulation:** Sobel Processing Core
4. **Data Output:** `edge_output.txt`
5. **Post-processing (Python):** Convert Back to Image

---

### 🧠 Sobel Operator Theory

The filter calculates the intensity gradient of the image at each point.

**Horizontal Gradient ():**

```text
-1   0  +1
-2   0  +2
-1   0  +1

```

**Vertical Gradient ():**

```text
-1  -2  -1
 0   0   0
+1  +2  +1

```

**Gradient magnitude approximation used:**



*Values are clamped to 255 to maintain an 8-bit range.*

---

### 📂 File Structure

```text
sobel-edge-detection-verilog/
│
├── main.v               # Verilog Module & Testbench
├── nature_decimal.txt   # Input pixel values (Generated)
├── edge_output.txt      # Output pixel values (Sim Result)
├── preprocess.py        # Image to Text converter
└── reconstruct.py       # Text to Image converter

```

---

### ⚙️ Step 1: Convert Image to Text File (Local VS Code/VS)

Run the Python script imge_text.py in your local environment to prepare the image data.


---

### ▶️ Step 2: Run Verilog Simulation

1. Load `main.v` into your simulator (Vivado, ModelSim, or Icarus Verilog).
2. Place `nature_decimal.txt` in the simulation folder.
3. Run the simulation.
4. **⚠️ Important:** In your Tcl console, run `run all`. Do NOT use the default `run 1000ns`, as the simulation will stop before the 262,144 pixels are processed.

---

### 🖼️ Step 3: Reconstruct Output Image

After simulation, take the generated `edge_output.txt` and run text_python.py to see your result:

---

### 🧩 Key Design Features

* **3-Line Buffer Architecture:** Manages data flow for the sliding window.
* **3×3 Sliding Window:** Real-time neighborhood processing.
* **Absolute Value Calculation:** Simplified hardware-friendly magnitude.
* **Output Clamping:** Ensures values stay within 0-255.

---

### ⏱ Simulation Considerations

* **Clock Period:** 10 ns
* **Total Simulation Time:** For a 512×512 image, you need approximately **2.6 ms** of simulation time to process every pixel.

---


import cv2
import numpy as np

# ===== SETTINGS =====
VIDEO_PATH = "input.mp4"
OUTPUT_COE = "frames.coe"

WIDTH = 160
HEIGHT = 120
MAX_FRAMES = 10   # keep small for BRAM

# ====================

cap = cv2.VideoCapture(VIDEO_PATH)

frames = []
count = 0

while cap.isOpened() and count < MAX_FRAMES:
    ret, frame = cap.read()
    if not ret:
        break

    # Resize
    frame = cv2.resize(frame, (WIDTH, HEIGHT))

    # Convert to grayscale
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    frames.append(gray)
    count += 1

cap.release()

print(f"Extracted {len(frames)} frames")

# Flatten frames into 1D list
data = []

for f in frames:
    for y in range(HEIGHT):
        for x in range(WIDTH):
            pixel = f[y, x]
            data.append(pixel)

# Write COE file
with open(OUTPUT_COE, "w") as f:
    f.write("memory_initialization_radix=16;\n")
    f.write("memory_initialization_vector=\n")

    for i, val in enumerate(data):
        hex_val = format(val, '02X')

        if i == len(data) - 1:
            f.write(hex_val + ";\n")
        else:
            f.write(hex_val + ",\n")

print(f"COE file generated: {OUTPUT_COE}")
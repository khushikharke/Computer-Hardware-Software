import cv2
import numpy as np
from keras.models import load_model
import pygame

# Load the pre-trained CNN model
model_path = 'D:/6th sem/CHS/major project 2/nn code/firedetector.h5'
fire_detector_model = load_model(model_path)

# Initialize pygame mixer
pygame.mixer.init()
sound = pygame.mixer.Sound("mixkit-alert-alarm-1005.wav")

# Define function to preprocess input image
def preprocess_image(img):
    img = cv2.resize(img, (150, 150)) # Resize image to match input size of the model
    img = img.astype('float32') / 255  # Normalize pixel values to between 0 and 1
    img = np.expand_dims(img, axis=0) # Add batch dimension
    return img

# Define function to predict fire in the image
def predict_fire(img):
    preprocessed_img = preprocess_image(img)
    prediction = fire_detector_model.predict(preprocessed_img)
    return prediction[0][0] # Return the prediction value (probability of fire)

# Open camera
cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    if not ret:
        print("Error: Couldn't access camera")
        break

    frame = cv2.flip(frame, 1)

    # Predict fire
    prediction = predict_fire(frame)
    if prediction > 0.5:
        cv2.putText(frame, "Fire Detected!", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
        sound.play() # Play sound if fire is detected
    else:
        cv2.putText(frame, "No Fire Detected", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

    # Display the frame
    cv2.imshow('Fire Detection', frame)

    # Break the loop if 'q' is pressed
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release the camera and close windows
cap.release()
cv2.destroyAllWindows()

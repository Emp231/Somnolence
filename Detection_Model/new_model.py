import cv2
import os
import numpy as np
from sklearn.model_selection import train_test_split
import tensorflow as tf
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dropout, Flatten, Dense
from tensorflow.keras.models import Sequential

# Define image paths and labels
images_path = "C:/Users/saman/OneDrive/Documents/GitHub/Somnolence/Detection_Model/train"
img_labels = ["Closed", "Open"]


# Function to load and resize images
def get_data(input_string):
    data = []
    path = os.path.join(images_path, input_string)
    label = img_labels.index(input_string)  # Get label index

    for img in os.listdir(path):
        try:
            img_array = cv2.imread(os.path.join(path, img), cv2.IMREAD_COLOR)
            resized = cv2.resize(img_array, (145, 145))  # Resize images
            data.append([resized, label])
        except Exception as e:
            print(f"Error reading image {img}: {str(e)}")

    return data


# Get data for "Closed" and "Open" labels
X_closed = get_data("Closed")
X_open = get_data("Open")

# Combine data and labels
X = np.array([x[0] for x in X_closed + X_open])
y = np.array([x[1] for x in X_closed + X_open])

# Shuffle and split data into training and testing sets
seed = 42  # Set random seed for reproducibility
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=seed)

# Normalize pixel values to [0, 1]
X_train = X_train / 255.0
X_test = X_test / 255.0

# Define the model
model = Sequential([
    Conv2D(256, (3, 3), activation='relu', input_shape=(145, 145, 3)),
    MaxPooling2D(2, 2),

    Conv2D(128, (3, 3), activation='relu'),
    MaxPooling2D(2, 2),

    Conv2D(64, (3, 3), activation='relu'),
    MaxPooling2D(2, 2),

    Conv2D(32, (3, 3), activation='relu'),
    MaxPooling2D(2, 2),

    Flatten(),
    Dropout(0.5),

    Dense(64, activation='relu'),
    Dense(2, activation='softmax')
])

# Compile the model
model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

model.summary()

# Train the model
history = model.fit(X_train, y_train, epochs=50, validation_data=(X_test, y_test))

# Evaluate the model
test_loss, test_acc = model.evaluate(X_test, y_test, verbose=2)
print(f"Test Accuracy: {test_acc}")

model.save('C:/Users/saman/OneDrive/Documents/GitHub/Somnolence/Detection_Model/drowsinessmodel.h5')


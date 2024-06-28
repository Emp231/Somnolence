import cv2
import os
import numpy as np
from sklearn.model_selection import train_test_split
import tensorflow as tf
#from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dropout, Flatten, Dense
#from tensorflow.keras.models import Sequential
import pygame
import time
#from tensorflow.keras.models import load_model
import numpy as np

"""
accuracy = 0
for _ in range(5):
    images_path = "C:/Users/saman/OneDrive/Documents/GitHub/Somnolence/Detection_Model/train"
    img_labels = ["Closed", "Open"]

    def get_data(input_string):
        data = []
        path = os.path.join(images_path, input_string)
        label = img_labels.index(input_string)

        for img in os.listdir(path):
            try:
                img_array = cv2.imread(os.path.join(path, img), cv2.IMREAD_COLOR)
                resized = cv2.resize(img_array, (145, 145))
                data.append([resized, label])
            except Exception as e:
                print(f"Error reading image {img}: {str(e)}")

        return data


    X_closed = get_data("Closed")
    X_open = get_data("Open")

    X = np.array([x[0] for x in X_closed + X_open])
    y = np.array([x[1] for x in X_closed + X_open])

    seed = 42
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=seed)

    X_train = X_train / 255.0
    X_test = X_test / 255.0

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

    model.compile(optimizer='adam',
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])

    model.summary()

    history = model.fit(X_train, y_train, epochs=50, validation_data=(X_test, y_test))

    test_loss, test_acc = model.evaluate(X_test, y_test, verbose=2)
    print(f"Test Accuracy: {test_acc}")

    if test_acc > accuracy:
        model.save('C:/Users/saman/OneDrive/Documents/GitHub/Somnolence/Detection_Model/drowsinessmodel.h5')

"""

model = tf.keras.models.load_model("C:/Users/saman/OneDrive/Documents/GitHub/Somnolence/Detection_Model/drowsinessmodel.h5")

left_pred = 0 # 0 for Closed, 1 for Open
right_pred = 0
cap = cv2.VideoCapture(0)
eye_cascade_left = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_lefteye_2splits.xml")
eye_cascade_right = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_righteye_2splits.xml")

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    gray_scale = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    left_eye = eye_cascade_left.detectMultiScale(gray_scale, 1.3, 5)
    right_eye = eye_cascade_right.detectMultiScale(gray_scale, 1.3, 5)

    for (x, y, w, h) in left_eye:
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)

        roi = gray_scale[y:y + h, x:x + w]

        roi = cv2.resize(roi, (145, 145))
        roi_rgb = cv2.cvtColor(roi, cv2.COLOR_GRAY2RGB)

        input_data = roi_rgb.astype('float32') / 255.0
        input_data = np.expand_dims(input_data, axis=0)

        prediction = model.predict(input_data)

        pred_closed = prediction[0][0]
        pred_open = prediction[0][1]

        if pred_closed > pred_open:
            left_pred = 0
        else:
            left_pred = 1

    for (x, y, w, h) in right_eye:
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)

        roi = gray_scale[y:y + h, x:x + w]

        roi = cv2.resize(roi, (145, 145))
        roi_rgb = cv2.cvtColor(roi, cv2.COLOR_GRAY2RGB)

        input_data = roi_rgb.astype('float32') / 255.0
        input_data = np.expand_dims(input_data, axis=0)

        prediction = model.predict(input_data)

        pred_closed = prediction[0][0]
        pred_open = prediction[0][1]

        if pred_closed > pred_open:
            right_pred = 0
        else:
            right_pred = 1

    if right_pred == 0 and left_pred == 0:
        print("Closed")
    else:
        print("Open")

    mirrored_frame = cv2.flip(frame, 1)
    cv2.imshow("Drowsiness Detection", mirrored_frame)

    if cv2.waitKey(1) == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
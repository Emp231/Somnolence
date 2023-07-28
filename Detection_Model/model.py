import cv2
from flask import Flask, request, jsonify
import werkzeug
import base64

app = Flask(__name__)
@app.route("/detect", methods=["POST"])
def detect():
    pass


if __name__ == "__main__":
    app.run()


def perform_classification(frame):
    prediction = None
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
    eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_eye.xml")
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)

    for (x, y, w, h) in faces:
            prediction = "Closed"
            cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 0), 5)
            ROI_G = gray[y:y+w, x:x+w]
            ROI_C = frame[y:y+h, x:x+w]
            eye = eye_cascade.detectMultiScale(ROI_G, 1.3, 5)
            for (ex, ey, ew, eh) in eye:
                prediction = "Open"
                eyes_r = ROI_G[ey: ey + eh, ex:ex+ew]

                cv2.rectangle(ROI_C, (ex, ey), (ex+ew, ey+eh), (0, 255, 0), 5)

    return prediction
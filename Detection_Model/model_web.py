import cv2
from flask import Flask, request, jsonify
import base64
import numpy as np

app = Flask(__name__)

@app.route("/", methods=["GET"])
def classify():
    try:
        frame_data = request.args.get("frame_data")
        decoded_frame = base64.b64decode(frame_data.split(',')[1])
        frame_array = np.frombuffer(decoded_frame, dtype=np.uint8)
        frame = cv2.imdecode(frame_array, cv2.IMREAD_COLOR)
        result = perform_classification(frame)
        return jsonify({"prediction": result})
    except Exception as e:
        return jsonify({"error": str(e)})


def perform_classification(frame):
    prediction = None
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
    eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_eye.xml")
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)

    for (x, y, w, h) in faces:
            prediction = "Closed"
            ROI_G = gray[y:y+w, x:x+w]
            ROI_C = frame[y:y+h, x:x+w]
            eye = eye_cascade.detectMultiScale(ROI_G, 1.3, 5)
            for (ex, ey, ew, eh) in eye:
                prediction = "Open"


    return prediction

if __name__ == "__main__":
     app.run(port=5000)
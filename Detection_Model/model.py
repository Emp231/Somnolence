import cv2
import tensorflow as tf
import os
from flask import Flask, request, jsonify

app = Flask("Somnolence")

def upload():
    video_file = request.files["video"]
    video_file.save("Detection_Model/Video/video.mp4")
    return jsonify({"message": "Video recieved and processed successfully!"})

if __name__ == "__main__":
    app.run()


prediction = None
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_eye.xml")

vid = cv2.VideoCapture("Detection_Model/Video/video.mp4")

while vid.isOpened():
    ret, frame = vid.read()
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)

    if ret:
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

        cv2.imshow("Somnolence", frame)
        print(prediction)
    else:
        break

    
vid.release()
cv2.destroyAllWindows()
os.remove("Detection_Model/Video/video.mp4")
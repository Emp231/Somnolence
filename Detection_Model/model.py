import cv2

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
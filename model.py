import cv2
import numpy as np

threshold = 0.3

def eye_AR(eye):
    a = np.linalg.norm(eye[1] - eye[5])
    b = np.linalg.norm(eye[2] - eye[eye.shape[0] - 1])
    c = np.linalg.norm(eye[0] - eye[3])
    ear = (a + b) / (2.0 * c)
    return ear

def detect_pupil(eye):
    _, thresh_eye = cv2.threshold(eye, 30, 255, cv2.THRESH_BINARY_INV)
    circles = cv2.HoughCircles(thresh_eye, cv2.HOUGH_GRADIENT, dp=1, minDist=20, param1=50, param2=30, minRadius=5, maxRadius=20)

    if circles is not None:
        return True
    else:
        return False

cap = cv2.VideoCapture(0)
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_eye.xml")

while cap.isOpened():
    ret, frame = cap.read()

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)

    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 0), 5)
        ROI_G = gray[y:y+w, x:x+w]
        ROI_C = frame[y:y+h, x:x+w]
        eye = eye_cascade.detectMultiScale(ROI_G, 1.3, 5)
        for (ex, ey, ew, eh) in eye:

            eyes_r = ROI_G[ey: ey + eh, ex:ex+ew]
            AR = eye_AR(eyes_r)


            cv2.rectangle(ROI_C, (ex, ey), (ex+ew, ey+eh), (0, 255, 0), 5)

    cv2.imshow("Detection", frame)

    if cv2.waitKey(1) == ord('q'):
        break


cap.release()
cv2.destroyAllWindows()
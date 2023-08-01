import cv2
import numpy as np

preditcion = None
cap = cv2.VideoCapture(0)
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_eye.xml")

while cap.isOpened():
    ret, frame = cap.read()

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)

    for (x, y, w, h) in faces:
        preditcion = "Closed"
        cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 0), 5)
        ROI_G = gray[y:y+w, x:x+w]
        ROI_C = frame[y:y+h, x:x+w]
        eye = eye_cascade.detectMultiScale(ROI_G, 1.3, 5)
        for (ex, ey, ew, eh) in eye:
            preditcion = "Open"
            eyes_r = ROI_G[ey: ey + eh, ex:ex+ew]


            cv2.rectangle(ROI_C, (ex, ey), (ex+ew, ey+eh), (0, 255, 0), 5)
    
    font = cv2.FONT_HERSHEY_SIMPLEX
    font_scale = 1
    font_color = (0, 0, 255)
    font_thickness = 2
    cv2.putText(frame, f"Prediction: {preditcion}", (10, 30), font, font_scale, font_color, font_thickness)


    cv2.imshow("Somnolence", frame)
    
    if cv2.waitKey(1) == ord('q'):
        break


cap.release()
cv2.destroyAllWindows()
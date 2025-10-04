import cv2
import mediapipe as mp
import time
import pygame
import math

pygame.init()
pygame.mixer.init()
sound_file = "Detection_Model/sounds/alarm.mp3"
pygame.mixer.music.load(sound_file)

cap = cv2.VideoCapture(0)
threshold = 3
last_drowsy_detect = None
ear_threshold = 0.2

mp_face_mesh = mp.solutions.face_mesh
mp_drawing = mp.solutions.drawing_utils

#define useful landmarks out of the 468 given my model
left_landmarks = [33, 160, 158, 133, 153, 144]
right_landmarks = [362, 387, 385, 263, 380, 373]
def EAR(eye_landmarks):
    p1 = eye_landmarks[0]
    p2 = eye_landmarks[1]
    p3 = eye_landmarks[2]
    p4 = eye_landmarks[3]
    p5 = eye_landmarks[4]
    p6 = eye_landmarks[5]

    height1 = math.hypot(p2[0] - p6[0], p2[1] - p6[1])
    height2 = math.hypot(p3[0] - p5[0], p3[1] - p5[1])
    horizontal = math.hypot(p1[0] - p4[0], p1[1] - p4[1])
    ratio = (height1 + height2) / (2.0 * horizontal)
    return ratio

#define face_mesh
with mp_face_mesh.FaceMesh(
    max_num_faces=1,
    refine_landmarks=True,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5
) as face_mesh:
    while True:
        ret, frame = cap.read()
        if not ret:
            break

        h, w, _ = frame.shape
        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = face_mesh.process(rgb)

        prediction = "No Face"

        if results.multi_face_landmarks:
            face_landmarks = results.multi_face_landmarks[0]

            left_eye = [(int(face_landmarks.landmark[i].x * w), int(face_landmarks.landmark[i].y * h)) for i in left_landmarks]
            right_eye = [(int(face_landmarks.landmark[i].x * w), int(face_landmarks.landmark[i].y * h)) for i in right_landmarks]

            #draws circles at landmarks
            for (x, y) in left_eye + right_eye:
                cv2.circle(frame, (x, y), 2, (0, 255, 0), -1)

            left_ear = EAR(left_eye)
            right_ear = EAR(right_eye)
            ear = (left_ear + right_ear) / 2.0

            frame = cv2.flip(frame, 1)

            # determine if eyes are closed
            if ear < ear_threshold:
                prediction = "Closed"
                if last_closed_time is None:
                    last_closed_time = time.time()
                elif time.time() - last_closed_time >= threshold:
                    cv2.putText(frame, "DROWSY", (10, 80), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                    if not pygame.mixer.music.get_busy():
                        pygame.mixer.music.play()
            else:
                prediction = "Open"
                last_closed_time = None
                cv2.putText(frame, "NOT DROWSY", (10, 80), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                pygame.mixer.music.stop()

        else:
            last_closed_time = None
            pygame.mixer.music.stop()

        cv2.putText(frame, f"Prediction: {prediction}", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 255), 2)

        cv2.imshow("Drowsiness Detection", frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()



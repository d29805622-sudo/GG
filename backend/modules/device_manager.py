import cv2


class DeviceManager:

    def list_camera(self):

        devices = []

        for i in range(5):

            cap = cv2.VideoCapture(i)

            if cap.isOpened():

                devices.append(i)

                cap.release()

        return devices

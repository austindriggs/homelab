import requests

URL: str = "http://driggs-zb"
PORT: str = "8047"
TOPIC: str = "dev"

message: str = "Hello, World"

def send_message(URL, PORT, TOPIC, message):
	requests.post(f"{URL}:{PORT}/{TOPIC}", data=message.encode("utf-8"))

send_message(URL, PORT, TOPIC, message)

print("Done!")

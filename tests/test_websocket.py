from fastapi.testclient import TestClient

from fastapi_websockets.main import app

client = TestClient(app)


def test_websocket():
    with client.websocket_connect("/ws") as websocket:
        message = "Hello World"

        websocket.send_text(message)
        data = websocket.receive_text()

        assert data == f"Message text was: {message}"

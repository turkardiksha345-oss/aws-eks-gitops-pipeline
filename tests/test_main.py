import pytest
from app.main import app

@pytest.fixture
def client():
    """Creates a test client for simulating HTTP requests."""
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client

def test_home_page(client):
    """Test the root '/' route returns HTTP 200 and loads HTML template."""
    response = client.get("/")
    assert response.status_code == 200
    assert b"quote" in response.data.lower() or b"daily" in response.data.lower() or b"inspiration" in response.data.lower()

def test_health_endpoint(client):
    """Test the '/health' endpoint returns 200 OK and healthy status."""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "healthy"}

def test_info_endpoint(client):
    """Test the '/info' endpoint returns valid app metadata."""
    response = client.get("/info")
    assert response.status_code == 200
    json_data = response.get_json()
    assert json_data["app"] == "aws-eks-gitops-pipeline"
    assert json_data["version"] == "1.0.0"

def test_404_error(client):
    """Test 404 behavior for invalid endpoints."""
    response = client.get("/non-existent-endpoint")
    assert response.status_code == 404

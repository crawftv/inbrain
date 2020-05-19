#!/usr/bin/env python3

import falcon
import pytest
from falcon import testing
from srv.api import app

@pytest.fixture
def client():
    return testing.TestClient(app)



def test_random_three(client):
    response = client.simulate_get("/random_three")

    assert response.status == falcon.HTTP_OK

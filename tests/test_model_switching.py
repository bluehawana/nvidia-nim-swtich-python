"""
Test file for model switching functionality.
This file demonstrates how to use the new model switching API.
"""

import requests
import json

def test_model_switching():
    """Test the model switching functionality."""

    # Base URL for the API
    base_url = "http://localhost:8089"

    print("Testing model switching functionality...")

    # 1. Get current model
    print("\n1. Getting current model:")
    response = requests.get(f"{base_url}/v1/models/current")
    if response.status_code == 200:
        current_model = response.json()
        print(f"Current model: {current_model['id']}")
        if 'owned_by' in current_model:
            print(f"Owned by: {current_model['owned_by']}")
        if 'settings' in current_model:
            print("Settings:")
            for key, value in current_model['settings'].items():
                print(f"  {key}: {value}")
    else:
        print(f"Error getting current model: {response.status_code}")
        print(response.text)
        return

    # 2. List available models
    print("\n2. Listing available models:")
    response = requests.get(f"{base_url}/v1/models")
    if response.status_code == 200:
        models = response.json()
        print(f"Found {len(models['data'])} models")
        # Show first 5 models
        for i, model in enumerate(models['data'][:5]):
            print(f"  {i+1}. {model['id']} (owned by {model.get('owned_by', 'unknown')})")
        if len(models['data']) > 5:
            print(f"  ... and {len(models['data']) - 5} more")
    else:
        print(f"Error listing models: {response.status_code}")
        print(response.text)
        return

    # 3. Switch to a different model (if there are any available)
    if len(models['data']) > 1:
        # Find a different model to switch to
        new_model = None
        for model in models['data']:
            if model['id'] != current_model['id']:
                new_model = model['id']
                break

        if new_model:
            print(f"\n3. Switching to model: {new_model}")
            response = requests.post(
                f"{base_url}/v1/models/switch",
                json={"model": new_model}
            )
            if response.status_code == 200:
                switch_result = response.json()
                print(f"Successfully switched to: {switch_result['id']}")
                print(f"Previous model: {switch_result['previous_model']}")
                print(f"Message: {switch_result['message']}")
            else:
                print(f"Error switching model: {response.status_code}")
                print(response.text)
                return

            # 4. Verify the switch by getting current model again
            print("\n4. Verifying model switch:")
            response = requests.get(f"{base_url}/v1/models/current")
            if response.status_code == 200:
                new_current_model = response.json()
                if new_current_model['id'] == new_model:
                    print(f"✓ Successfully verified! Current model is now: {new_current_model['id']}")
                else:
                    print(f"✗ Verification failed! Expected {new_model}, got {new_current_model['id']}")
            else:
                print(f"Error verifying model: {response.status_code}")
                print(response.text)

        # 5. Switch back to original model
        print(f"\n5. Switching back to original model: {current_model['id']}")
        response = requests.post(
            f"{base_url}/v1/models/switch",
            json={"model": current_model['id']}
        )
        if response.status_code == 200:
            switch_result = response.json()
            print(f"Successfully switched back to: {switch_result['id']}")
        else:
            print(f"Error switching back: {response.status_code}")
            print(response.text)

    print("\nTest completed!")

if __name__ == "__main__":
    test_model_switching()
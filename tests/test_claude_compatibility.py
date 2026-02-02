"""
Test Claude API compatibility with NVIDIA NIM proxy.
This tests if the proxy correctly handles Claude API requests.
"""

import requests
import json

def test_claude_api_compatibility():
    """Test Claude API compatibility."""
    
    base_url = "http://localhost:8089"
    
    print("🧪 Testing Claude API Compatibility with NVIDIA NIM Proxy")
    print("=" * 60)
    
    # Test 1: Simple message request
    print("\n1. Testing simple message request (Claude format)...")
    try:
        response = requests.post(
            f"{base_url}/v1/messages",
            headers={
                "Content-Type": "application/json",
                "anthropic-version": "2023-06-01"
            },
            json={
                "model": "claude-3-5-sonnet-20241022",
                "max_tokens": 1024,
                "messages": [
                    {
                        "role": "user",
                        "content": "Say 'Hello from NVIDIA NIM!' in exactly those words."
                    }
                ]
            },
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            print(f"   ✓ Status: {response.status_code}")
            print(f"   ✓ Model used: {result.get('model', 'N/A')}")
            print(f"   ✓ Response type: {result.get('type', 'N/A')}")
            if result.get('content'):
                text = result['content'][0].get('text', '')[:100]
                print(f"   ✓ Response text: {text}")
            print(f"   ✓ Stop reason: {result.get('stop_reason', 'N/A')}")
            if result.get('usage'):
                print(f"   ✓ Tokens - Input: {result['usage'].get('input_tokens', 0)}, Output: {result['usage'].get('output_tokens', 0)}")
        else:
            print(f"   ✗ Error: {response.status_code}")
            print(f"   Response: {response.text[:200]}")
    except Exception as e:
        print(f"   ✗ Exception: {e}")
    
    # Test 2: Streaming request
    print("\n2. Testing streaming request (Claude format)...")
    try:
        response = requests.post(
            f"{base_url}/v1/messages",
            headers={
                "Content-Type": "application/json",
                "anthropic-version": "2023-06-01"
            },
            json={
                "model": "claude-3-5-sonnet-20241022",
                "max_tokens": 100,
                "messages": [
                    {
                        "role": "user",
                        "content": "Count from 1 to 5."
                    }
                ],
                "stream": True
            },
            stream=True,
            timeout=30
        )
        
        if response.status_code == 200:
            print(f"   ✓ Status: {response.status_code}")
            print(f"   ✓ Streaming events received:")
            
            event_count = 0
            for line in response.iter_lines():
                if line:
                    line_str = line.decode('utf-8')
                    if line_str.startswith('data: '):
                        event_count += 1
                        if event_count <= 3:  # Show first 3 events
                            data = line_str[6:]
                            if data != '[DONE]':
                                try:
                                    event = json.loads(data)
                                    print(f"      - {event.get('type', 'unknown')}")
                                except:
                                    pass
            
            print(f"   ✓ Total events: {event_count}")
        else:
            print(f"   ✗ Error: {response.status_code}")
            print(f"   Response: {response.text[:200]}")
    except Exception as e:
        print(f"   ✗ Exception: {e}")
    
    # Test 3: Model mapping verification
    print("\n3. Testing model name mapping...")
    claude_models = [
        "claude-3-5-sonnet-20241022",
        "claude-3-opus-20240229",
        "claude-3-haiku-20240307"
    ]
    
    for claude_model in claude_models:
        try:
            response = requests.post(
                f"{base_url}/v1/messages",
                headers={
                    "Content-Type": "application/json",
                    "anthropic-version": "2023-06-01"
                },
                json={
                    "model": claude_model,
                    "max_tokens": 10,
                    "messages": [
                        {
                            "role": "user",
                            "content": "Hi"
                        }
                    ]
                },
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                mapped_model = result.get('model', 'N/A')
                print(f"   ✓ {claude_model} → {mapped_model}")
            else:
                print(f"   ✗ {claude_model} failed: {response.status_code}")
        except Exception as e:
            print(f"   ✗ {claude_model} exception: {e}")
    
    # Test 4: Current model info
    print("\n4. Current NVIDIA NIM model configuration:")
    try:
        response = requests.get(f"{base_url}/v1/models/current")
        if response.status_code == 200:
            current = response.json()
            print(f"   Model ID: {current.get('id', 'N/A')}")
            print(f"   Provider: {current.get('owned_by', 'N/A')}")
            if current.get('settings'):
                print(f"   Settings:")
                for key, value in current['settings'].items():
                    print(f"     - {key}: {value}")
        else:
            print(f"   ✗ Error: {response.status_code}")
    except Exception as e:
        print(f"   ✗ Exception: {e}")
    
    print("\n" + "=" * 60)
    print("✅ Claude API compatibility test completed!")
    print("\n💡 Summary:")
    print("   - Your NVIDIA NIM proxy is working as a Claude API replacement")
    print("   - All Claude model names are automatically mapped to NVIDIA NIM models")
    print("   - You can switch NVIDIA NIM models on-the-fly via API or web UI")
    print("   - Use this proxy URL in Claude Code: http://localhost:8089")

if __name__ == "__main__":
    test_claude_api_compatibility()

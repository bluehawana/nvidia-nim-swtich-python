# NVIDIA NIM Model Switching

This project extends the cc-nim proxy with enhanced model switching capabilities, allowing you to easily switch between different NVIDIA NIM models without manually editing environment variables.

## Features

1. **API Endpoints for Model Management**:
   - `GET /v1/models` - List all available NVIDIA NIM models
   - `GET /v1/models/current` - Get the currently selected model
   - `POST /v1/models/switch` - Switch to a different model

2. **Web Interface**:
   - Accessible at `http://localhost:8089/`
   - Visual model selection interface
   - Search functionality for finding models
   - Real-time model switching with confirmation

3. **Persistent Model Selection**:
   - Model selections are stored persistently across application restarts
   - Current model is saved to `config/current_model.json`

4. **Per-Request Model Selection**:
   - Existing `/v1/messages` endpoint supports model switching
   - Claude model requests are automatically mapped to the currently selected model

## API Usage

### List Available Models
```bash
curl http://localhost:8089/v1/models
```

### Get Current Model
```bash
curl http://localhost:8089/v1/models/current
```

### Switch Models
```bash
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "nvidia/llama-3.1-nemotron-70b-instruct"}'
```

## Web Interface

Access the web interface at `http://localhost:8089/` to visually browse and switch between models.

## Implementation Details

The model switching mechanism works by:

1. Loading all available NVIDIA NIM models from `nvidia_nim_models.json`
2. Storing the currently selected model in `config/current_model.json`
3. Updating the model mapping logic in `providers/model_utils.py` to use the currently selected model
4. Providing RESTful API endpoints for model management
5. Serving a static web interface for easy model switching

## Files Added/Modified

- `config/model_presets.py` - Model management logic
- `config/current_model.json` - Persistent storage for current model
- `api/models.py` - New request/response models for model management
- `api/routes.py` - New API endpoints for model management
- `static/index.html` - Web interface
- `static/style.css` - Web interface styling
- `static/script.js` - Web interface functionality
- `providers/model_utils.py` - Updated model normalization logic
- `api/app.py` - Mount static files directory
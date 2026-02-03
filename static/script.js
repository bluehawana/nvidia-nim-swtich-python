// API base URL
const API_BASE = '';

// DOM elements
const currentModelNameEl = document.getElementById('current-model-name');
const currentModelOwnerEl = document.getElementById('current-model-owner');
const currentModelSettingsEl = document.getElementById('current-model-settings');
const modelsListEl = document.getElementById('models-list');
const modelSearchEl = document.getElementById('model-search');
const notificationEl = document.getElementById('notification');
const notificationMessageEl = document.getElementById('notification-message');

// State
let allModels = [];
let currentModel = null;
let currentSort = 'name';
let currentSpeedFilter = 'all';

// Model speed categories (based on parameter count and architecture)
const MODEL_SPEEDS = {
    // Fast models (< 10B parameters)
    'fast': [
        'llama-3.1-8b', 'llama-3.2-1b', 'llama-3.2-3b', 'gemma-2-2b', 'gemma-2-9b',
        'phi-3', 'qwen2-7b', 'mistral-7b', 'yi-6b', 'deepseek-coder-6.7b'
    ],
    // Medium models (10B-30B parameters)
    'medium': [
        'llama-3.1-70b', 'mixtral', 'qwen2-72b', 'yi-34b', 'deepseek-v2',
        'nemotron-70b', 'qwq-32b', 'deepseek-r1-distill-qwen-32b'
    ],
    // Slow models (> 30B parameters or complex architectures)
    'slow': [
        'llama-3.3-70b', 'qwen3-coder-480b', 'deepseek-v3', 'deepseek-r1'
    ]
};

// Determine model speed based on name
function getModelSpeed(modelId) {
    const lowerModelId = modelId.toLowerCase();
    
    for (const [speed, patterns] of Object.entries(MODEL_SPEEDS)) {
        if (patterns.some(pattern => lowerModelId.includes(pattern))) {
            return speed;
        }
    }
    
    // Default heuristics
    if (lowerModelId.includes('8b') || lowerModelId.includes('7b') || 
        lowerModelId.includes('6b') || lowerModelId.includes('3b') ||
        lowerModelId.includes('2b') || lowerModelId.includes('1b')) {
        return 'fast';
    }
    if (lowerModelId.includes('70b') || lowerModelId.includes('72b') ||
        lowerModelId.includes('34b') || lowerModelId.includes('32b')) {
        return 'medium';
    }
    if (lowerModelId.includes('480b') || lowerModelId.includes('v3') ||
        lowerModelId.includes('r1') || lowerModelId.includes('405b')) {
        return 'slow';
    }
    
    return 'medium'; // Default to medium if unknown
}

// Get speed emoji and label
function getSpeedIndicator(speed) {
    const indicators = {
        'fast': { emoji: '⚡', label: 'Fast', color: '#10b981' },
        'medium': { emoji: '🚀', label: 'Medium', color: '#f59e0b' },
        'slow': { emoji: '🐢', label: 'Slow', color: '#ef4444' }
    };
    return indicators[speed] || indicators['medium'];
}

// Get estimated model size
function getModelSize(modelId) {
    const lowerModelId = modelId.toLowerCase();
    const sizeMatch = lowerModelId.match(/(\d+)b/);
    if (sizeMatch) {
        return parseInt(sizeMatch[1]);
    }
    return 50; // Default size if unknown
}

// Initialize the app
document.addEventListener('DOMContentLoaded', async () => {
    await loadCurrentModel();
    await loadModels();

    // Set up search functionality
    modelSearchEl.addEventListener('input', filterAndSortModels);
    
    // Set up sort functionality
    const sortSelect = document.getElementById('sort-select');
    sortSelect.addEventListener('change', (e) => {
        currentSort = e.target.value;
        filterAndSortModels();
    });
    
    // Set up speed filter
    const speedFilter = document.getElementById('speed-filter');
    speedFilter.addEventListener('change', (e) => {
        currentSpeedFilter = e.target.value;
        filterAndSortModels();
    });
});

// Load current model information
async function loadCurrentModel() {
    try {
        const response = await fetch(`${API_BASE}/v1/models/current`);
        if (!response.ok) throw new Error('Failed to load current model');

        currentModel = await response.json();
        updateCurrentModelDisplay();
    } catch (error) {
        showNotification(`Error loading current model: ${error.message}`, 'error');
    }
}

// Load all available models
async function loadModels() {
    try {
        const response = await fetch(`${API_BASE}/v1/models`);
        if (!response.ok) throw new Error('Failed to load models');

        const data = await response.json();
        allModels = data.data;
        renderModels(allModels);
    } catch (error) {
        showNotification(`Error loading models: ${error.message}`, 'error');
        modelsListEl.innerHTML = `<p>Error loading models: ${error.message}</p>`;
    }
}

// Update current model display
function updateCurrentModelDisplay() {
    if (!currentModel) return;

    currentModelNameEl.textContent = currentModel.id;
    currentModelOwnerEl.textContent = currentModel.owned_by ? `Owned by: ${currentModel.owned_by}` : '';

    if (currentModel.settings) {
        const settingsHtml = Object.entries(currentModel.settings)
            .map(([key, value]) => `<li>${key}: ${value}</li>`)
            .join('');
        currentModelSettingsEl.innerHTML = settingsHtml;
    } else {
        currentModelSettingsEl.innerHTML = '<li>No settings available</li>';
    }
}

// Render models list
function renderModels(models) {
    if (models.length === 0) {
        modelsListEl.innerHTML = '<p>No models found</p>';
        return;
    }

    const modelsHtml = models.map(model => {
        const isSelected = currentModel && model.id === currentModel.id;
        const selectedClass = isSelected ? 'selected' : '';
        const ownerInfo = model.owned_by ? `${model.owned_by}` : '';
        
        // Add speed indicator
        const speed = getModelSpeed(model.id);
        const speedInfo = getSpeedIndicator(speed);
        const size = getModelSize(model.id);

        return `
            <div class="model-item ${selectedClass}" data-model-id="${model.id}" data-speed="${speed}">
                <div class="model-header">
                    <span class="speed-badge" style="background-color: ${speedInfo.color}20; color: ${speedInfo.color}; border: 1px solid ${speedInfo.color}">
                        ${speedInfo.emoji} ${speedInfo.label}
                    </span>
                    <span class="size-badge">${size}B</span>
                </div>
                <h3>${model.id}</h3>
                <p class="model-owner">${ownerInfo}</p>
                <button class="switch-button" onclick="switchModel('${model.id}')" ${isSelected ? 'disabled' : ''}>
                    ${isSelected ? '✓ Current Model' : 'Switch to Model'}
                </button>
            </div>
        `;
    }).join('');

    modelsListEl.innerHTML = modelsHtml;
}

// Sort models based on selected criteria
function sortModels(models) {
    const sorted = [...models];
    
    switch (currentSort) {
        case 'speed':
            sorted.sort((a, b) => {
                const speedOrder = { 'fast': 0, 'medium': 1, 'slow': 2 };
                const speedA = getModelSpeed(a.id);
                const speedB = getModelSpeed(b.id);
                return speedOrder[speedA] - speedOrder[speedB];
            });
            break;
        case 'size':
            sorted.sort((a, b) => getModelSize(a.id) - getModelSize(b.id));
            break;
        case 'provider':
            sorted.sort((a, b) => {
                const providerA = a.owned_by || '';
                const providerB = b.owned_by || '';
                return providerA.localeCompare(providerB);
            });
            break;
        case 'name':
        default:
            sorted.sort((a, b) => a.id.localeCompare(b.id));
            break;
    }
    
    return sorted;
}

// Filter models based on search input and speed
function filterAndSortModels() {
    const searchTerm = modelSearchEl.value.toLowerCase();
    
    let filtered = allModels;
    
    // Apply search filter
    if (searchTerm) {
        filtered = filtered.filter(model =>
            model.id.toLowerCase().includes(searchTerm) ||
            (model.owned_by && model.owned_by.toLowerCase().includes(searchTerm))
        );
    }
    
    // Apply speed filter
    if (currentSpeedFilter !== 'all') {
        filtered = filtered.filter(model => {
            const speed = getModelSpeed(model.id);
            if (currentSpeedFilter === 'fast') {
                return speed === 'fast';
            } else if (currentSpeedFilter === 'medium') {
                return speed === 'fast' || speed === 'medium';
            }
            return true; // 'slow' shows all
        });
    }
    
    // Sort filtered models
    const sorted = sortModels(filtered);
    
    renderModels(sorted);
}

// Filter models based on search input (legacy function, now calls filterAndSortModels)
function filterModels() {
    filterAndSortModels();
}

// Switch to a different model
async function switchModel(modelId) {
    try {
        // Disable all buttons during switching
        document.querySelectorAll('.switch-button').forEach(btn => {
            btn.disabled = true;
            if (btn.parentElement.dataset.modelId === modelId) {
                btn.textContent = 'Switching...';
            }
        });

        const response = await fetch(`${API_BASE}/v1/models/switch`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ model: modelId }),
        });

        if (!response.ok) {
            const errorData = await response.json().catch(() => ({}));
            throw new Error(errorData.detail || 'Failed to switch model');
        }

        const result = await response.json();
        showNotification(result.message, 'success');

        // Update current model
        currentModel = result;
        updateCurrentModelDisplay();

        // Re-render models to update selection status
        filterAndSortModels();
    } catch (error) {
        showNotification(`Error switching model: ${error.message}`, 'error');
    } finally {
        // Re-enable all buttons
        document.querySelectorAll('.switch-button').forEach(btn => {
            btn.disabled = false;
            if (btn.parentElement.dataset.modelId === currentModel.id) {
                btn.textContent = 'Current Model';
            } else {
                btn.textContent = 'Switch to Model';
            }
        });
    }
}

// Show notification
function showNotification(message, type) {
    notificationMessageEl.textContent = message;
    notificationEl.className = `notification ${type} show`;

    setTimeout(() => {
        notificationEl.classList.remove('show');
    }, 3000);
}

// Add event listener for Enter key in search
modelSearchEl.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        filterModels();
    }
});


// Chat functionality - Initialize after DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    const chatOutput = document.getElementById('chat-output');
    const chatInput = document.getElementById('chat-input');
    const clearChatBtn = document.getElementById('clear-chat');
    const sendBtn = document.getElementById('send-btn');

    if (!chatInput || !chatOutput) return; // Exit if chat elements don't exist

    let chatHistory = [];

    // Send message function
    async function sendMessage(message) {
        // Add user message to chat
        addMessageToChat('user', message);
        
        // Add loading indicator
        const loadingDiv = document.createElement('div');
        loadingDiv.className = 'chat-message loading-message';
        loadingDiv.textContent = 'Thinking...';
        chatOutput.appendChild(loadingDiv);
        chatOutput.scrollTop = chatOutput.scrollHeight;
        
        try {
            const response = await fetch(`${API_BASE}/v1/messages`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'x-api-key': 'demo',
                    'anthropic-version': '2023-06-01'
                },
                body: JSON.stringify({
                    model: currentModel ? currentModel.id : 'meta/llama-3.1-8b-instruct',
                    messages: [{ role: 'user', content: message }],
                    max_tokens: 1024
                })
            });
            
            // Remove loading indicator
            loadingDiv.remove();
            
            if (!response.ok) {
                const errorData = await response.json().catch(() => ({}));
                throw new Error(errorData.error?.message || 'Failed to get response');
            }
            
            const data = await response.json();
            console.log('API Response:', data); // Debug log
            
            // Handle different response types (text or thinking)
            let assistantMessage = 'No response';
            if (data.content && data.content.length > 0) {
                const content = data.content[0];
                console.log('Content type:', content.type, 'Content:', content); // Debug log
                if (content.type === 'text') {
                    assistantMessage = content.text;
                } else if (content.type === 'thinking') {
                    assistantMessage = content.thinking;
                }
            }
            
            addMessageToChat('assistant', assistantMessage);
            
        } catch (error) {
            loadingDiv.remove();
            addMessageToChat('error', error.message);
        }
    }

    // Add message to chat display
    function addMessageToChat(type, message) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `chat-message ${type}-message`;
        messageDiv.textContent = message;
        chatOutput.appendChild(messageDiv);
        chatOutput.scrollTop = chatOutput.scrollHeight;
    }

    // Enter key handler
    chatInput.addEventListener('keypress', async (e) => {
        if (e.key === 'Enter' && chatInput.value.trim()) {
            await sendMessage(chatInput.value.trim());
            chatInput.value = '';
        }
    });

    // Send button handler
    if (sendBtn) {
        sendBtn.addEventListener('click', async () => {
            if (chatInput.value.trim()) {
                await sendMessage(chatInput.value.trim());
                chatInput.value = '';
            }
        });
    }

    // Clear button handler
    if (clearChatBtn) {
        clearChatBtn.addEventListener('click', () => {
            chatHistory = [];
            chatOutput.innerHTML = '<div class="system-message">Chat cleared. Type your message below.</div>';
        });
    }
});


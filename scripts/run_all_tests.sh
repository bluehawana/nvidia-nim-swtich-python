#!/bin/bash

# Comprehensive Test Suite for NVIDIA NIM Switch
# Run this before publishing to verify everything works

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     NVIDIA NIM Switch - Comprehensive Test Suite          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS_COUNT=0
FAIL_COUNT=0

# Function to run test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -n "Testing: $test_name ... "
    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        ((FAIL_COUNT++))
        return 1
    fi
}

# Test 1: Check if server is running
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Server Health Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

run_test "Server health check" "curl -s http://localhost:8089/health | grep -q 'healthy'"
run_test "API documentation accessible" "curl -s -o /dev/null -w '%{http_code}' http://localhost:8089/docs | grep -q '200'"
run_test "Web interface loads" "curl -s http://localhost:8089/ | grep -q 'NVIDIA NIM Model Switcher'"

# Test 2: Model Management
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. Model Management Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

run_test "List models API" "curl -s http://localhost:8089/v1/models | python3 -c 'import sys,json; assert len(json.load(sys.stdin)[\"data\"]) > 0'"
run_test "Get current model" "curl -s http://localhost:8089/v1/models/current | python3 -c 'import sys,json; assert \"id\" in json.load(sys.stdin)'"

# Test model switching
echo -n "Testing: Switch model API ... "
SWITCH_RESULT=$(curl -s -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "meta/llama-3.1-8b-instruct"}')
if echo "$SWITCH_RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); assert d['id'] == 'meta/llama-3.1-8b-instruct'" 2>/dev/null; then
    echo -e "${GREEN}✅ PASS${NC}"
    ((PASS_COUNT++))
else
    echo -e "${RED}❌ FAIL${NC}"
    ((FAIL_COUNT++))
fi

# Test 3: Claude API Compatibility
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. Claude API Compatibility Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

run_test "Claude API message endpoint" "curl -s -X POST http://localhost:8089/v1/messages \
  -H 'Content-Type: application/json' \
  -H 'anthropic-version: 2023-06-01' \
  -d '{\"model\": \"claude-3-5-sonnet-20241022\", \"max_tokens\": 10, \"messages\": [{\"role\": \"user\", \"content\": \"Hi\"}]}' \
  | python3 -c 'import sys,json; assert json.load(sys.stdin)[\"type\"] == \"message\"'"

run_test "Token counting endpoint" "curl -s -X POST http://localhost:8089/v1/messages/count_tokens \
  -H 'Content-Type: application/json' \
  -d '{\"model\": \"claude-3-5-sonnet-20241022\", \"messages\": [{\"role\": \"user\", \"content\": \"Hi\"}]}' \
  | python3 -c 'import sys,json; assert \"input_tokens\" in json.load(sys.stdin)'"

# Test 4: Cross-Directory Access
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4. Cross-Directory Access Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create test directories
mkdir -p /tmp/test-project-1 /tmp/test-project-2

echo -n "Testing: Access from /tmp/test-project-1 ... "
if (cd /tmp/test-project-1 && curl -s http://localhost:8089/health | grep -q 'healthy'); then
    echo -e "${GREEN}✅ PASS${NC}"
    ((PASS_COUNT++))
else
    echo -e "${RED}❌ FAIL${NC}"
    ((FAIL_COUNT++))
fi

echo -n "Testing: Access from /tmp/test-project-2 ... "
if (cd /tmp/test-project-2 && curl -s http://localhost:8089/health | grep -q 'healthy'); then
    echo -e "${GREEN}✅ PASS${NC}"
    ((PASS_COUNT++))
else
    echo -e "${RED}❌ FAIL${NC}"
    ((FAIL_COUNT++))
fi

# Test 5: Security
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5. Security Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo -n "Testing: .env file not tracked by git ... "
if git ls-files | grep -q "^\.env$"; then
    echo -e "${RED}❌ FAIL - .env IS TRACKED!${NC}"
    ((FAIL_COUNT++))
else
    echo -e "${GREEN}✅ PASS${NC}"
    ((PASS_COUNT++))
fi

echo -n "Testing: .env in .gitignore ... "
if grep -q "^\.env$" ../.gitignore 2>/dev/null || grep -q "^\.env$" .gitignore 2>/dev/null; then
    echo -e "${GREEN}✅ PASS${NC}"
    ((PASS_COUNT++))
else
    echo -e "${RED}❌ FAIL${NC}"
    ((FAIL_COUNT++))
fi

echo -n "Testing: No real API keys in tracked files ... "
if git grep "nvapi-5" 2>/dev/null | grep -v "nvapi-your" | grep -v "nvapi-xxx" > /dev/null; then
    echo -e "${RED}❌ FAIL - REAL API KEY FOUND IN GIT!${NC}"
    ((FAIL_COUNT++))
else
    echo -e "${GREEN}✅ PASS${NC}"
    ((PASS_COUNT++))
fi

# Test 6: Commands Available
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "6. Global Commands Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

export PATH="$HOME/.local/bin:$PATH"

for cmd in nim-start nim-stop nim-status nim-web nim-claude nim-switch; do
    echo -n "Testing: $cmd command exists ... "
    if command -v $cmd &> /dev/null; then
        echo -e "${GREEN}✅ PASS${NC}"
        ((PASS_COUNT++))
    else
        echo -e "${RED}❌ FAIL${NC}"
        ((FAIL_COUNT++))
    fi
done

# Test 7: Documentation
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "7. Documentation Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for doc in README.md docs/USER_GUIDE.md docs/QUICK_START.md MODEL_SWITCHING.md; do
    echo -n "Testing: $doc exists ... "
    if [ -f "$doc" ] || [ -f "../$doc" ]; then
        echo -e "${GREEN}✅ PASS${NC}"
        ((PASS_COUNT++))
    else
        echo -e "${RED}❌ FAIL${NC}"
        ((FAIL_COUNT++))
    fi
done

# Summary
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                      TEST SUMMARY                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo -e "Total Tests: $((PASS_COUNT + FAIL_COUNT))"
echo -e "${GREEN}Passed: $PASS_COUNT${NC}"
echo -e "${RED}Failed: $FAIL_COUNT${NC}"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✅ ALL TESTS PASSED - READY FOR PUBLICATION! 🎉          ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "✅ Safe to push to GitHub"
    echo "✅ Safe to share on LinkedIn"
    echo "✅ Production ready"
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ❌ SOME TESTS FAILED - FIX BEFORE PUBLISHING             ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    exit 1
fi

#!/bin/bash

# Security Check Script
# Verifies no sensitive data is tracked by git

echo "╔════════════════════════════════════════════════════════════╗"
echo "║              SECURITY CHECK                                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

PASS=0
FAIL=0

# Check 1: .env not tracked
echo -n "1. Checking .env is NOT tracked by git... "
if git ls-files | grep -q "^\.env$"; then
    echo "❌ FAIL: .env IS TRACKED!"
    ((FAIL++))
else
    echo "✅ PASS"
    ((PASS++))
fi

# Check 2: .env in .gitignore
echo -n "2. Checking .env in .gitignore... "
if grep -q "^\.env$" .gitignore; then
    echo "✅ PASS"
    ((PASS++))
else
    echo "❌ FAIL"
    ((FAIL++))
fi

# Check 3: No real API keys
echo -n "3. Checking for real API keys in git... "
if git grep "nvapi-5" 2>/dev/null | grep -v "nvapi-your" | grep -v "example" > /dev/null; then
    echo "❌ FAIL: Real API key found!"
    ((FAIL++))
else
    echo "✅ PASS"
    ((PASS++))
fi

# Check 4: server logs not tracked
echo -n "4. Checking server logs not tracked... "
if git ls-files | grep -E "\.(log|jsonl)$" > /dev/null; then
    echo "⚠️  WARNING: Log files tracked"
else
    echo "✅ PASS"
    ((PASS++))
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "Results: $PASS passed, $FAIL failed"
echo "════════════════════════════════════════════════════════════"

if [ $FAIL -eq 0 ]; then
    echo "✅ SAFE TO PUSH TO GITHUB!"
    exit 0
else
    echo "❌ FIX ISSUES BEFORE PUSHING!"
    exit 1
fi

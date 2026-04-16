#!/bin/bash

# Configuration
CONFIG_FILE="litellm-config.yaml"
PORT=4000

# Cleanup function to kill background processes on exit
cleanup() {
    echo -e "\n--- Shutting down LiteLLM and Localtunnel ---"
    kill $LITELLM_PID $LT_PID 2>/dev/null
    exit
}

# Trap CTRL-C (SIGINT) and SIGTERM
trap cleanup SIGINT SIGTERM

echo "--- Starting LiteLLM Proxy ---"
# Start LiteLLM in the background
litellm --config "$CONFIG_FILE" --port $PORT &
LITELLM_PID=$!

# Wait a moment for LiteLLM to initialize
sleep 3

echo "--- Starting Localtunnel ---"
npx localtunnel --port $PORT &
LT_PID=$!

# Give localtunnel a moment to connect, then print bypass info
sleep 2
BYPASS_IP=$(curl -s https://loca.lt/mytunnelpassword)
echo ""
echo "-----------------------------------------------------------"
echo "  Browser access:  enter IP '$BYPASS_IP' when prompted"
echo "  API / add-in:    set header 'Bypass-Tunnel-Reminder: true'"
echo "-----------------------------------------------------------"
echo ""

# Keep the script running
wait


#!/bin/bash

# Replace these with your actual Telegram bot token and chat ID
TELEGRAM_BOT_TOKEN="6614915150:AAFOKUgukLQe4spwN87OBhPVVJL9xCQUqbY"
CHAT_ID="822103678"
TELEGRAM_API_URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"

# Replace this with your actual curl command that fetches the JSON weather data
response=$(curl -s "https://api.data.gov.sg/v1/environment/24-hour-weather-forecast")

# Define an array of rain-related keywords
rain_keywords=("Rain" "Showers" "Thundery Showers" "Heavy Thundery Showers")

general_forecast=$(echo "$response" | grep -o '"forecast":"[^"]*' | sed 's/"forecast":"//')

# Initialize a flag to check if rain is found
rain_found=0

# Check for rain-related keywords in the general forecast
for keyword in "${rain_keywords[@]}"; do
    if [[ "$general_forecast" == *"$keyword"* ]]; then
        rain_found=1
        break
    fi
done

# If rain is detected, send an alert
if [ "$rain_found" -eq 1 ]; then
    message="Weather Alert: Rain expected! General forecast is '$general_forecast'. Stay prepared!"

    # Send the message to the Telegram bot
    curl -s -X POST $TELEGRAM_API_URL \
        -d chat_id=$CHAT_ID \
        -d text="$message" > /dev/null

    echo "Alert sent: $message"
else
    echo "No rain expected. General forecast is '$general_forecast'."
fi

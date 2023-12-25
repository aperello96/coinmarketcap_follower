# COINMARKETCAP FOLLOWER

This code allows you to get notifications on your telegram app about your favorites cryptos.\
You will recive at 8am, 12pm and 10pm a notification with the price, the marketcap and the ranking of your cryptos.

## Use:

This code is designed to run on a docker container. If you dont need to modify anything, you can download the image from my docker hub public repository running the docker-compose.yml file.\
You can do it by positioning yourself in the directory where the docker-compouse.yml document is located and executing:
```docker compose up -d```

In case you need to modify some parameters like cronjob, you can modify it and then build your own docker image with:

``` docker build -t <DOCKER_IMAGE_NAME> .```

## Parameters:

The code needs 4 parameters to run correctly:
- API_KEY -> you need an account of coinmarketcap 
- SYMBOLS -> A list of the cryptos you want to follow
- TELEGRAM_API_TOKEN -> Your telegram token to send notifications. You can check [here](https://github.com/aperello96/telegram_robot) for how to create one
- TELEGRAM_CHAT_ID -> Your chat id where you want to be notified
- TZ -> Your time zone. Ej: Europe/Madrid

## Limitations:

This code download a list of the first 300 crypto coins sorted by market_cap. If the coin that you need to follow is not in the list, the script will not find it. You can increase or decrease this limit on the "parameters" var on line 28 of app.py.\
The request of 300 cryptos will spend 2 credits of your coinmarketcap account. If you want to just spend 1, change the limit to 100.

 #This example uses Python 2.7 and the python-request library.

from requests import Request, Session
from numerize import numerize
import requests
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json
from dotenv import load_dotenv
import os

load_dotenv()

telegram_api_token = os.environ.get('TELEGRAM_API_TOKEN')
telegram_chat_id = os.environ.get('TELEGRAM_CHAT_ID')

#send telegram message function:
def send_to_telegram(message, apiToken, chatID):
    apiURL = f'https://api.telegram.org/bot{apiToken}/sendMessage'
    try:
        resp = requests.post(apiURL, json={'chat_id': chatID, 'text': message})
        return resp
    except Exception as e:
        print(e)

url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
parameters = {
  'start':'1',
  'limit':'300',
  'sort':'market_cap',
  'cryptocurrency_type': 'all',
  'tag': 'all'
}
headers = {
  'Accepts': 'application/json',
  'X-CMC_PRO_API_KEY': os.environ.get('API_KEY'),
}

session = Session()
session.headers.update(headers)

try:
  response = session.get(url, params=parameters)
  data = json.loads(response.text)

  # Símbolos de las criptomonedas que buscas (en una lista)
  symbols = os.environ.get('SYMBOLS').split(',')

  # Busca las criptomonedas correspondientes en la lista data
  for symbol in symbols:
      cripto_founded = False
      for cripto in data['data']:
          if cripto['symbol'] == symbol:
              cripto_founded = cripto
              break

      # Verifica si se encontró la criptomoneda
      if cripto_founded:
          cmc_rank = cripto_founded['cmc_rank']
          cap_market = numerize.numerize(cripto_founded['quote']['USD']['market_cap'])
          price = round(cripto_founded['quote']['USD']['price'],4)
          print(f'La criptomoneda con símbolo {symbol} tiene un cmc_rank de: {cmc_rank}')
          print(f'La criptomoneda con símbolo {symbol} tiene un capital de mercado de: {cap_market}')
          send_to_telegram(message=f'{symbol}: \n 🏆: {cmc_rank} \n 🏷️: {price}$ \n 💰: {cap_market}', apiToken=telegram_api_token, chatID=telegram_chat_id)
      else:
          print(f'No se encontró la criptomoneda con símbolo {symbol}')

except (ConnectionError, Timeout, TooManyRedirects) as e:
  print(e)
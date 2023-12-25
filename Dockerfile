#FROM python:3.9-alpine
FROM ubuntu:20.04
#FROM arm64v8/ubuntu:20.04

# Instala el instalador de paquetes pip y cron
RUN apt-get update && apt-get install -y python3 python3-pip cron


# Instala las librerias python necesarias
RUN pip3 install --no-cache-dir requests python-dotenv numerize

# Copia los ficheros necesarios
COPY ./market_advisor/app.py /root/main.py
COPY ./market_advisor/mycron /etc/cron.d/mycron

# Damos permisos a los ficheros y aplicamos mycron a crontab
RUN chmod 0644 /etc/cron.d/mycron
RUN crontab /etc/cron.d/mycron
RUN chmod 0644 /root/main.py

# Create empty log (TAIL needs this)
RUN touch /var/log/cron.log

# Start TAIL - as your always-on process (otherwise - container exits right after start)
CMD cron && printenv | grep -v "no_proxy" >> /etc/environment && tail -f /var/log/cron.log
# "printenv | grep -v "no_proxy" >> /etc/environment" is used to send all env vars to /etc/environment to be used on cronjobs. cronjob can use only variables that are in this file

#Run
#docker build -t perelo96/coinmarketcap_cripto_info .
#docker push perelo96/coinmarketcap_cripto_info:latest
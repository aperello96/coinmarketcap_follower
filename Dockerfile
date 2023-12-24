#FROM python:3.9-alpine
FROM ubuntu:20.04
#FROM arm64v8/ubuntu:20.04

# Instala el instalador de paquetes pip y cron
RUN apt-get update && apt-get install -y python3 python3-pip cron


# Instala las librerias python necesarias
RUN pip3 install --no-cache-dir requests python-dotenv numerize

# Copia los ficheros necesarios
COPY ./market_advisor/app.py /root/main.py
#COPY ./market_advisor/.env /root/.env
COPY ./market_advisor/mycron /etc/cron.d/mycron

# Damos permisos a los ficheros y aplicamos mycron a crontab
RUN chmod 0644 /etc/cron.d/mycron
RUN crontab /etc/cron.d/mycron
RUN chmod 0644 /root/main.py
#RUN chmod 0644 /root/.env

# Create empty log (TAIL needs this)
RUN touch /var/log/cron.log

# Start TAIL - as your always-on process (otherwise - container exits right after start)
CMD cron && tail -f /var/log/cron.log


#Run
#docker build -t perelo96/binance-test .
#docker push perelo96/binance-test:latest
#docker run -d -v /home/ec2-user/volumes/kucoin:root/data --name kucoin perelo96/binance-test

#docker run -d -v kucoin:/root/data --name kucoin perelo96/binance-test
#ssh ssh -i "perelo96.pem" ec2-user@ec2-35-181-50-40.eu-west-3.compute.amazonaws.com
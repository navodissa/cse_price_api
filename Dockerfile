FROM ubuntu:latest

RUN apt update \
&& mkdir /app \
&& apt install -y git python3-pip

WORKDIR /app

RUN git clone https://github.com/navodissa/cse_price_api.git 

WORKDIR cse_price_api
RUN pip install requirements.txt
RUN python3 manage.py migrate

EXPOSE 8000

ENTRYPOINT ["python3 manage.py runserver"]


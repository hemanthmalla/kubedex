FROM python:2.7-jessie

RUN mkdir /opt/firedex

COPY ./ /opt/firedex/middleware

WORKDIR /opt/firedex/middleware

RUN pip install  --upgrade -r requirements.txt

EXPOSE 8888

CMD ["python", "firedex_middleware.py"]
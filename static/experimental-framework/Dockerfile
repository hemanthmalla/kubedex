FROM python:2.7-jessie

RUN mkdir /opt/firedex

COPY ./ /opt/firedex/experimental_framework

WORKDIR /opt/firedex/experimental_framework

RUN pip install  --upgrade -r requirements.txt

CMD ["python", "experimental_framework.py"]
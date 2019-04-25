FROM store/oracle/serverjre:8

RUN mkdir /opt/firedex

COPY ./build/* /opt/firedex/
COPY scripts/start_firedex.sh /opt/firedex/

WORKDIR /opt/firedex

EXPOSE 1883 20000 9999

CMD ["bash", "./start_firedex.sh"]

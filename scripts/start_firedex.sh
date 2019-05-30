#!/bin/bash

trap_signal() {
  echo "Sending SIGTERM to Firedex.."
  kill -s SIGTERM "$child"
  wait "$child"
}

trap trap_signal SIGTERM

FIREDEX_HEAP_DUMP_DIR="/var/log/firedex"

JVM_OPTS="$JVM_OPTS -XX:+HeapDumpOnOutOfMemoryError"
JVM_OPTS="$JVM_OPTS -XX:HeapDumpPath=$FIREDEX_HEAP_DUMP_DIR/firedex-`date +%s`-pid$$.hprof"

# Enable for JMX based monitoring
# JVM_OPTS="$JVM_OPTS -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

case $ROLE in
"producer")
  CMD="/opt/firedex/static/publisher-1.0.0-jar-with-dependencies.jar edu.uci.ics.application.Application /opt/firedex/static/config/publisher.json"
  ;;
"subscriber")
  CMD="/opt/firedex/static/subscriber-1.0.0-jar-with-dependencies.jar edu.uci.ics.application.Application /opt/firedex/static/config/subscriber.json"
  ;;
"broker")
  CMD="/opt/firedex/static/mqtt-broker-1.0.0-jar-with-dependencies.jar edu.uci.ics.application.Application /opt/firedex/static/config/moquette.configuration"
  ;;
"gateway")
  CMD="/opt/firedex/static/mqtt-sn-broker-1.0.0-jar-with-dependencies.jar org.eclipse.paho.mqttsn.gateway.Gateway /opt/firedex/static/config/gateway.properties"
  ;;
*)
  echo "No role specified.. Exiting.."
  exit 1
  ;;
esac

java ${JVM_OPTS} -cp ${CMD}

sleep infinity

child=$!
wait "$child"

echo $CMD
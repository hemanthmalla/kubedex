#!/bin/bash

subscriber_id=$1
topic_id=$2
port=$3
priority=$4
netem_id=$5
drop_rate=$6
is_first_subscriber=$7
is_first_topic=$8

if [ $is_first_subscriber -eq 1 ] 
then
    tc qdisc del dev eth0 root
    tc qdisc add dev eth0 root handle 1: htb 
fi    

if [ $is_first_topic -eq 1 ]
then
    tc class add dev eth0 parent 1: classid 1:$subscriber_id htb rate 78kbit ceil 78kbit 
fi    

tc class add dev eth0 parent 1:$subscriber_id classid 1:$topic_id htb rate 78kbit ceil 78kbit prio $priority
tc qdisc add dev eth0 parent 1:$topic_id handle $netem_id:0 netem loss $drop_rate%
tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32  match ip dport $port 0xffff flowid 1:$topic_id






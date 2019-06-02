'use strict';

const network_flows = require('./network_flows/network_flows.json');
const execSync = require('child_process').execSync;

const subscriber_rules = {};
const rules = [];  
let is_first_subscriber = 1;  
const netem_ids = [];

execSync('bash delete_prev_results.sh', {stdio: 'inherit'});

for(let i=3000; i<4000; i++) {
    netem_ids.push(i);
}

const trasform_id = (id) => {
    
    
    id = parseInt(id);

    return  id + 1;   
}


network_flows.forEach((subscriber) => {
    
    let subscriber_id = subscriber.identifier.substring(3,subscriber.identifier.length); 
    let topic_id = subscriber.subscriptions[0].topic.substring(5, subscriber.subscriptions[0].topic.length);
    
    if(!(subscriber_id in subscriber_rules))
        subscriber_rules[subscriber_id] = [];

    let subscriber_rule = {};    

    subscriber_rule.subscriber_id = trasform_id(subscriber_id);
    subscriber_rule.topic_id = parseInt(`${subscriber_rule.subscriber_id}${trasform_id(topic_id)}`);
    subscriber_rule.port = subscriber.network_flow.port;
    subscriber_rule.priority = subscriber.priority;
    subscriber_rule.netem_id = netem_ids[netem_ids.length-1];
    netem_ids.pop();
    subscriber_rule.drop_rate = subscriber.drop_rate;

    subscriber_rules[subscriber_id].push(subscriber_rule);
});

for(let key in subscriber_rules) {
    
    if(subscriber_rules.hasOwnProperty(key)) {
        let is_first_topic = 1;
        let rules = subscriber_rules[key];

        rules.forEach((rule) => {

            execSync(`bash setup_rules.sh ${rule.subscriber_id} ${rule.topic_id} ${rule.port} \
            ${rule.priority} ${rule.netem_id} ${rule.drop_rate} ${is_first_subscriber} ${is_first_topic}`,  {stdio: 'inherit'});

            is_first_subscriber = 0;
            is_first_topic = 0;     
        });

    }


}

import json
import os
import requests
import time

from scenario.experiment_scenario import *

from configuration.network_configuration import NetworkConfiguration
from configuration.topology_configuration import TopologyConfiguration
from configuration.firedex_configuration import FiredexConfiguration
from configuration.experiment_configuration import ExperimentConfiguration

FIREDEX_BASE_API = "http://middleware.firedex:8888/api/firedex"

class Configuration:

    def __init__(self):
        self.network_configuration = None
        self.topology_configuration = None
        self.firedex_configuration = None
        self.experiment_configuration = None

configuration = Configuration()

def network_scenario():
    configuration.network_configuration = NetworkConfiguration()
    print("Network configuration loaded.")

def topology_scenario():
    configuration.topology_configuration = TopologyConfiguration()
    print("Topology configuration loaded.")

def firedex_scenario():
    configuration.firedex_configuration = FiredexConfiguration()
    print("Firedex configuration loaded.")

def experiment_scenario():
    configuration.experiment_configuration = ExperimentConfiguration(configuration.network_configuration,
                                                                     configuration.topology_configuration,
                                                                     configuration.firedex_configuration
                                                                    )
    print("Experiment configuration loaded.")

def push_network_configuration():
    url = FIREDEX_BASE_API + "/push-network-configuration/"
    body = configuration.network_configuration.json()

    response = requests.post(
        url = url,
        data = body
    )

    content = response.json()

    print("Network configuration pushed.")

def push_topology_configuration():
    url = FIREDEX_BASE_API + "/push-topology-configuration/"
    body = configuration.topology_configuration.json()

    response = requests.post(
        url = url,
        data = body
    )

    content = response.json()

    print("Topology configuration pushed.")

def push_firedex_configuration():
    url = FIREDEX_BASE_API + "/push-firedex-configuration/"
    body = configuration.firedex_configuration.json()

    response = requests.post(
        url = url,
        data = body
    )

    content = response.json()

    print("Firedex configuration pushed.")

def push_experiment_configuration():
    url = FIREDEX_BASE_API + "/push-experiment-configuration/"
    body = configuration.experiment_configuration.json()

    response = requests.post(
        url = url,
        data = body
    )

    content = response.json()

    print("Experiment configuration pushed.")

def apply_experiment_configuration():
    url = FIREDEX_BASE_API + "/apply-experiment-configuration/"
    body = configuration.experiment_configuration.json()

    response = requests.post(
        url = url,
        data = body
    )

    content = response.json()
    network_flows_file = open("/var/configuration/network_flows/network_flows.json", "w")
    network_flows_file.write( json.dumps(content, indent = 4) )
    network_flows_file.close()

    print("Experiment configuration applied on the FireDeX middleware.")

def start_publisher():
    print("Writing publisher config files")

    publishers = configuration.experiment_configuration.publishers()

    for publisher in publishers:
        identifier = publisher["publisher"]["identifier"]

        configuration_file_name = ("/var/configuration/publishers/%s.json" % identifier)
        configuration_file = open(configuration_file_name, "w")
        configuration_file.write( json.dumps(publisher, indent = 4) )
        configuration_file.close()

def start_subscriber():
    print("Writing subscriber config files")

    subscribers = configuration.experiment_configuration.subscribers()

    for subscriber in subscribers:
        identifier = subscriber["subscriber"]["identifier"]

        configuration_file_name = ("/var/configuration/subscribers/%s.json" % identifier)
        configuration_file = open(configuration_file_name, "w")
        configuration_file.write( json.dumps(subscriber, indent = 4) )
        configuration_file.close()


if __name__ == "__main__":
    network_scenario()
    topology_scenario()
    firedex_scenario()
    experiment_scenario()

    print("")

    push_network_configuration()
    push_topology_configuration()
    push_firedex_configuration()
    push_experiment_configuration()

    print("")

    apply_experiment_configuration()

    print("")

    start_publisher()
    start_subscriber()

 
    

package edu.uci.ics.configuration;

import java.io.File;
import java.nio.charset.Charset;
import java.util.List;

import com.google.common.io.Files;

import edu.uci.ics.exception.FiredexException;
import edu.uci.ics.utility.JsonUtility;

public class Configuration {
	private Server server;
	private Subscriber subscriber;
	private Output output;
	
	public Configuration(Server server, Subscriber subscriber, Output output) {
		this.server = server;
		this.subscriber = subscriber;
		this.output = output;
	}
	
	public Server getServer() {
		return (server);
	}
	
	public Subscriber getSubscriber() {
		return (subscriber);
	}
	
	public Output getOutput() {
		return (output);
	}

}

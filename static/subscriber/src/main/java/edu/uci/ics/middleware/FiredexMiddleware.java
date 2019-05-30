package edu.uci.ics.middleware;

import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;

import edu.uci.ics.configuration.Configuration;
import edu.uci.ics.exception.FiredexException;
import edu.uci.ics.model.SubscriptionRequest;
import edu.uci.ics.model.SubscriptionResponse;
import edu.uci.ics.utility.JsonUtility;

public class FiredexMiddleware {
	private String baseApi;

	public FiredexMiddleware() {
		this.baseApi = baseApi();
	}

	private String baseApi() {
		String middlewareHost = "middleware.firedex";
		int middlewarePort = 8888;
		String baseApi = String.format("http://%s:%d/api/firedex", middlewareHost, middlewarePort);
		return (baseApi);
	}

	public SubscriptionResponse subscriptionRequest(SubscriptionRequest subscriptionRequest) throws FiredexException {
		try {
			String json = JsonUtility.toJson(subscriptionRequest);
			
			String url = baseApi + "/subscriber-network-flows/";
			
			HttpResponse<JsonNode> response = Unirest
					.post(url)
					.header("Content-Type", "application/json")
					.header("Accept", "application/json")
					.body(json)
					.asJson();
			
			json = response.getBody().toString();	
			SubscriptionResponse subscriptionResponse = JsonUtility.fromJson(json, SubscriptionResponse.class);
			return (subscriptionResponse);
		} catch (UnirestException exception) {
			throw ( new FiredexException() );
		}
	}

	public String getSubscriptionIdentifier() throws FiredexException {
		try {

			String url = baseApi + "/get-subscription-id/";

			HttpResponse<JsonNode> response = Unirest
					.get(url)
					.asJson();

			String subscription_id = response.getBody().getObject().getString("subscription_id");

			return (subscription_id);
		} catch (UnirestException exception) {
			throw ( new FiredexException() );
		}
	}


}

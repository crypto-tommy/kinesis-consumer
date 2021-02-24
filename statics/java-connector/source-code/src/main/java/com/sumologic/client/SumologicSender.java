package com.sumologic.client;


import java.io.IOException;
import java.util.concurrent.ExecutionException;
import java.util.regex.Pattern;
import java.lang.StringBuilder;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.ning.http.client.AsyncHttpClient;
import com.ning.http.client.AsyncHttpClientConfig;
import com.ning.http.client.AsyncHttpClient.BoundRequestBuilder;
import com.ning.http.client.AsyncHttpClientConfig.Builder;
import com.ning.http.client.Response;

public class SumologicSender {
  private static final Log LOG = LogFactory.getLog(SumologicSender.class);

  private String url = null;
  private String stream = null;
  private AsyncHttpClient client = null;

	public SumologicSender(String url, String stream) {
		  this.url = url;
      this.stream = stream;

	    Builder builder = new AsyncHttpClientConfig.Builder();
	    this.client = new AsyncHttpClient(builder.build());
	}

  private BoundRequestBuilder clientPreparePost(String url){
    if (this.client.isClosed()){
      Builder builder = new AsyncHttpClientConfig.Builder();
      this.client = new AsyncHttpClient(builder.build());
    }
    return this.client.preparePost(url);
  }

	public boolean sendToSumologic(String data) throws IOException{
	  int statusCode = -1;

    BoundRequestBuilder builder = null;
    builder = this.clientPreparePost(url);

    String logStreamName = data.substring(data.lastIndexOf("LogStream:"));

    String sourceHost = logStreamName.replace("LogStream:","").trim();
    sourceHost = sourceHost.replace("app/","");
    data = data.replace(logStreamName,"");

    byte[] compressedData = SumologicKinesisUtils.compressGzip(data);
    if (compressedData == null) {
      LOG.error("Unable to compress data to send: "+data);
      return false;
    }
    LOG.info("HTTP POST body of size " + compressedData.length + " bytes");
    builder.setHeader("Content-Encoding", "gzip");
    builder.setHeader("X-Sumo-Host", sourceHost);
    builder.setBody(compressedData);

    Response response = null;
    try {
      response = builder.execute().get();
      statusCode = response.getStatusCode();
    } catch (InterruptedException e) {
      LOG.error("Can't send POST to Sumologic "+e.getMessage());
    } catch (ExecutionException e) {
      LOG.error("Can't send POST to Sumologic "+e.getMessage());
    }

    // Check if the request was successful;
    if (statusCode != 200) {
      LOG.warn(String.format("Received HTTP error from Sumo Service: %d", statusCode));
      return false;
    }
    else{
      return true;
    }
	}
}

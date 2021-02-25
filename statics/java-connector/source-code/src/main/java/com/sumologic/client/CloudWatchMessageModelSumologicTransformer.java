package com.sumologic.client;

import java.io.IOException;

import com.amazonaws.services.kinesis.model.Record;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import sun.rmi.runtime.Log;

import com.sumologic.client.implementations.SumologicTransformer;
import com.sumologic.client.model.CloudWatchLogsMessageModel;
import com.sumologic.client.model.LogEvent;

import org.apache.log4j.Logger;

import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * A custom transfomer for {@link CloudWatchLogsMessageModel} records in JSON
 * format. The output is in a format usable for insertions to Sumologic.
 */
public class CloudWatchMessageModelSumologicTransformer implements SumologicTransformer<CloudWatchLogsMessageModel> {
  private static final Logger LOG = Logger.getLogger(CloudWatchMessageModelSumologicTransformer.class.getName());

  private static CharsetEncoder encoder = Charset.forName("UTF-8").newEncoder();

  /**
   * Creates a new KinesisMessageModelSumologicTransformer.
   */
  public CloudWatchMessageModelSumologicTransformer() {
    super();
  }

  @Override
  public String fromClass(CloudWatchLogsMessageModel message) {
    if (message == null) {
      return "";
    }

    String jsonMessage = "";
    JSONObject outputObject;
    JSONArray outputArray;

    List<LogEvent> logEvents = message.getLogEvents();
    int logEventsSize = logEvents.size();
    String LogStream = message.getLogStream();
    String LogGroup = message.getLogGroup();

    for (int i = 0; i < logEventsSize; i++) {
        LogEvent log = logEvents.get(i);

        String logMessage = log.getMessage();

        // JSON format
        if (isJSONValid(logMessage)) {
          try {
            outputObject = new JSONObject(logMessage);
            jsonMessage += outputObject.toString();
          } catch (JSONException ex) {
            try {
              outputArray = new JSONArray(logMessage);
              for (int j = 0; j < outputArray.length(); j++){
                jsonMessage += outputArray.optString(j);
              }
            } catch (Exception e) {
              LOG.error(e);
              LOG.error("log message: " + logMessage);
            }
          }
        } else {
          jsonMessage += logMessage;
        }


        if (i < logEventsSize - 1) {
          jsonMessage += "\n";
        }
    }
    jsonMessage += "\n";
    jsonMessage += "INFO:";
    jsonMessage += "LogStream:";
    jsonMessage += LogStream.trim();
    jsonMessage += "LogGroup:";
    jsonMessage += LogGroup.trim();
    jsonMessage += "END";
    jsonMessage += "\n";
    return jsonMessage;
  }

  // Modified
  private boolean isJSONValid(String test) {
    try {
      new JSONObject(test);
    } catch (JSONException ex) {
      try {
        new JSONArray(test);
      } catch (JSONException ex1) {
        return false;
      }
    }
    return true;
  }

  @Override
  public CloudWatchLogsMessageModel toClass(Record record) {
    byte[] decodedRecord = record.getData().array();
    String stringifiedRecord = SumologicKinesisUtils.decompressGzip(decodedRecord);

    if (stringifiedRecord == null) {
      LOG.error("Unable to decompress the record: " + new String(record.getData().array())
          + "\nNot attempting to transform into a Message Model");
      return null;
    }

    ByteBuffer bufferedData = null;
    try {
      bufferedData = encoder.encode(CharBuffer.wrap(stringifiedRecord));
    } catch (CharacterCodingException e) {
      LOG.error("Unable to set the decompressed Record for serializing " + e.getMessage());
    }
    record.setData(bufferedData);

    try {
      return new ObjectMapper().readValue(record.getData().array(), CloudWatchLogsMessageModel.class);
    } catch (IOException e) {
      LOG.error("Unable to convert the Record into a POJO: " + stringifiedRecord + "\nerror: " + e.getMessage());
    }
    return null;
  }
}

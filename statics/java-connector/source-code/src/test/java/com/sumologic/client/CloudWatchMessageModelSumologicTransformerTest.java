package com.sumologic.client;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.Ignore;

import com.amazonaws.services.kinesis.model.Record;
import com.sumologic.client.model.CloudWatchLogsMessageModel;
import com.sumologic.client.model.SimpleKinesisMessageModel;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.nio.CharBuffer;
import java.nio.ByteBuffer;


public class CloudWatchMessageModelSumologicTransformerTest {
  public static Charset charset = Charset.forName("UTF-8");
  public static CharsetEncoder encoder = charset.newEncoder();
  
  // @Test
  // public void theTransformerShouldFailGracefullyWhenUnableToCompress () {
  //   CloudWatchMessageModelSumologicTransformer transfomer = new CloudWatchMessageModelSumologicTransformer();
    
  //   String randomData = "Some random string without GZIP compression";
  //   ByteBuffer bufferedData = null;
  //   try {
  //     bufferedData = encoder.encode(CharBuffer.wrap(randomData));
  //   } catch (Exception e) {
  //     Assert.fail("Getting error: "+e.getMessage());
  //   }
    
  //   Record mockedRecord = new Record();
  //   mockedRecord.setData(bufferedData);
    
  //   CloudWatchLogsMessageModel messageModel = transfomer.toClass(mockedRecord);
    
    
  //   Assert.assertNull(messageModel);
  // }
  
  // @Test
  // public void theTransformerShouldSucceedWhenTransformingAProperJSON() {
  //   CloudWatchMessageModelSumologicTransformer transfomer = new CloudWatchMessageModelSumologicTransformer();
    
  //   String jsonData =  "abcd";

  //   byte[] compressData = SumologicKinesisUtils.compressGzip(jsonData);
    
  //   ByteBuffer bufferedData = null;
  //   try {
  //     bufferedData = ByteBuffer.wrap(compressData);
  //   } catch (Exception e) {
  //     Assert.fail("Getting error: "+e.getMessage());
  //   }
    
  //   Record mockedRecord = new Record();
  //   mockedRecord.setData(bufferedData);
    
  //   CloudWatchLogsMessageModel messageModel = transfomer.toClass(mockedRecord);
    
  //   Assert.assertNotNull(messageModel);
  // }
  
  // @Test
  // public void theTransformerShouldFailWhenTransformingAJSONWithTrailingCommas() {
  //   CloudWatchMessageModelSumologicTransformer transfomer = new CloudWatchMessageModelSumologicTransformer();
    
  //   String jsonData =  "abcd";
                    
  //   byte[] compressData = SumologicKinesisUtils.compressGzip(jsonData);
    
  //   ByteBuffer bufferedData = null;
  //   try {
  //     bufferedData = ByteBuffer.wrap(compressData);
  //   } catch (Exception e) {
  //     Assert.fail("Getting error: "+e.getMessage());
  //   }
    
  //   Record mockedRecord = new Record();
  //   mockedRecord.setData(bufferedData);
    
  //   CloudWatchLogsMessageModel messageModel = null;
  //   messageModel = transfomer.toClass(mockedRecord);
    
  //   Assert.assertNull(messageModel);
  // }
  
  // @Test
  // public void theTransfomerShouldSeparateBatchesOfLogs() {
  //   CloudWatchMessageModelSumologicTransformer transfomer = new CloudWatchMessageModelSumologicTransformer();
    
  //   String jsonData =  "abcd";
                    
  //   byte[] compressData = SumologicKinesisUtils.compressGzip(jsonData);
    
  //   ByteBuffer bufferedData = null;
  //   try {
  //     bufferedData = ByteBuffer.wrap(compressData);
  //   } catch (Exception e) {
  //     Assert.fail("Getting error: "+e.getMessage());
  //   }
    
  //   Record mockedRecord = new Record();
  //   mockedRecord.setData(bufferedData);
    
  //   CloudWatchLogsMessageModel messageModel = null;
  //   messageModel = transfomer.toClass(mockedRecord);
    
  //   String debatchedMessage = transfomer.fromClass(messageModel);
  //   System.out.println(debatchedMessage);
    
  //   String[] messages = debatchedMessage.split("\n");
  //   Assert.assertTrue(messages.length == 2);
  // }
}
# README

### Development

Refer to Dockerfile to install dependency

Local development
Refer to https://github.com/SumoLogic/sumologic-kinesis-connector/blob/main/src/main/resources/SumologicConnector.properties.stub to edit SumologicConnector.properties file.
```sh
$ mvn install
$ mvn clean compile exec:java -Dargs="SumologicConnector.properties"
```

Dockerize

```sh
$ docker build -t kinesis-data-stream-java-connector .
$ docker tag kinesis-data-stream-java-connector crypto1tim/kinesis-data-stream-java-connector:latest
$ docker push crypto1tim/kinesis-data-stream-java-connector:latest
```

Run
```sh
$ docker run --rm -it -e appName="[AWS dynamodb name]" \
-e regionName="[AWS region]"  \
-e kinesisInputStream="[AWS kinesis stream name]" \
-e connectorDestination="" \
-e sumologicUrl="[Consumer Url]" kinesis-data-stream-java-connector
```

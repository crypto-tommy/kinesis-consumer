#!/bin/sh

TARGETFILE="$(pwd)/src/main/resources/SumologicConnector.properties"

sed -i "s/^appName =.*/appName = ${dynamodb_table_name}/" "${TARGETFILE}"
sed -i "s/^regionName =.*/regionName = ${region_name}/" "${TARGETFILE}"
sed -i "s/^kinesisInputStream =.*/kinesisInputStream = ${kinesis_input_stream_name}/" "${TARGETFILE}"
sed -i "s/^connectorDestination =.*/connectorDestination = ${destination_identifier}/" "${TARGETFILE}"
sed -i "s#^sumologicUrl =.*#sumologicUrl = ${destination_url}#" "${TARGETFILE}"

mvn clean compile exec:java -Dargs="SumologicConnector.properties"

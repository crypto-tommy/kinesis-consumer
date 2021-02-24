FROM alpine:3.12.1

RUN apk update
RUN apk upgrade --available && sync

RUN apk add maven openjdk11

COPY mavenrc /etc/mavenrc
COPY pom.xml /code/pom.xml
WORKDIR /code
RUN mvn install

COPY . /code

ENTRYPOINT [ "./entry.sh" ] 

FROM openjdk

ARG version
ENV ver=$version

COPY target/spring-petclinic-$ver.jar /tmp/spring-petclinic-$ver.jar
RUN chmod +x /tmp/spring-petclinic-$ver.jar

COPY target/spring-petclinic-$ver.jar /tmp/spring-petclinic-$ver.jar
VOLUME /tmp
ENTRYPOINT ["sh", "-c", "java -jar /tmp/spring-petclinic-$ver.jar"]

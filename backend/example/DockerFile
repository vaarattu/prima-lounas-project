FROM openjdk:11
VOLUME /tmp
COPY /out/artifacts/com_divit_spring_boot_simple_rest_api_jar/com.divit.spring-boot-simple-rest-api.jar app.jar
EXPOSE 8888
ENTRYPOINT ["java","-jar","/app.jar"]
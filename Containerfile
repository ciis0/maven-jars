FROM curlimages/curl:8.10.1 AS fetch
USER root

RUN set -eu; \
    mkdir -p /jars; \
    for gav in \
      com.fasterxml.jackson.core:jackson-databind:2.21.5 \
      org.apache.tomcat.embed:tomcat-embed-core:11.0.25 \
      org.apache.wss4j:wss4j-ws-security-dom:3.0.4 \
      org.bouncycastle:bcprov-jdk18on:1.84 \
      org.apache.httpcomponents.client5:httpclient5:5.5.2 \
      org.apache.cxf:cxf-rt-ws-security:3.6.9 \
      org.springframework.batch:spring-batch-core:5.2.5; \
    do \
      group="${gav%%:*}"; \
      remainder="${gav#*:}"; \
      artifact="${remainder%%:*}"; \
      version="${remainder#*:}"; \
      path="$(printf '%s' "$group" | tr '.' '/')"; \
      filename="${artifact}-${version}.jar"; \
      curl --fail --show-error --silent --location --retry 3 \
        "https://repo.maven.apache.org/maven2/${path}/${artifact}/${version}/${filename}" \
        --output "/jars/${filename}"; \
    done

FROM scratch
COPY --from=fetch /jars/ /jars/

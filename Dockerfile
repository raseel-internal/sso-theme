

# Copyright (c) 2022 Raseel.city Platform to Present
# All right reserved

FROM quay.io/keycloak/keycloak:18.0 as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

WORKDIR /opt/keycloak


RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:18.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Configure a database vendor
ENV KC_DB=postgres

ARG RASEEL_THEME_BASE_DIR=/opt/keycloak/themes/raseel
ARG RASEEL_THEME_LOCAL_DIR=theme/keywind

RUN mkdir ${RASEEL_THEME_BASE_DIR}
COPY ${RASEEL_THEME_LOCAL_DIR} ${RASEEL_THEME_BASE_DIR}

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
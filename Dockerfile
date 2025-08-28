FROM quay.io/keycloak/keycloak:latest AS builder

ENV KC_DB=postgres \
    KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
    KC_SPI_HEALTH_ENABLED=true \
    KC_SPI_HEALTH_CHECKS_ENABLED=true \
    KC_OPTIMIZED=true 

RUN /opt/keycloak/bin/kc.sh build


# 运行阶段：使用构建结果启动 Keycloak
FROM quay.io/keycloak/keycloak:latest


# 拷贝构建结果
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# 设置数据库连接参数（可通过 ECS 环境变量覆盖）
# ENV KC_DB=postgres
# ENV KC_DB_URL=jdbc:postgresql://your-db-host:5432/keycloak
# ENV KC_DB_USERNAME=your-db-user
# ENV KC_DB_PASSWORD=your-db-password

# 设置主机名（用于生成 token issuer）
# ENV KC_HOSTNAME=your-keycloak-hostname.com

ENV KC_HTTP_ENABLED=true
ENV PROXY_ADDRESS_FORWARDING=true


# 启用代理转发（适用于 ALB）
ENV KC_PROXY=edge

# ENV JAVA_OPTS_APPEND="-Dquarkus.management.enabled=true -Dquarkus.management.port=8080 -Dquarkus.management.root-path=/health"

# 启动命令
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized"]
# ENTRYPOINT ["/entrypoint.sh"]
# CMD ["/bin/sh", "-c", "nginx && /opt/keycloak/bin/kc.sh start --optimized"]
# ENTRYPOINT ["/bin/sh", "-c", "nginx && /opt/keycloak/bin/kc.sh start --optimized"]
# CMD ["start"]

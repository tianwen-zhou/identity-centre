#!/bin/bash
set -e

# 启动 nginx（后台）
nginx -g 'daemon off;' &

# 启动 Keycloak（前台，接管 PID 1）
exec /opt/keycloak/bin/kc.sh start --optimized

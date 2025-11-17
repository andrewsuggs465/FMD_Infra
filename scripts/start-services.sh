#!/usr/bin/env bash

# Helper script to START all services.
# E.g., run this AFTER taking a backup.

set -eux

systemctl start prometheus.service
systemctl start grafana-server.service
systemctl start fmd-server-beta.service
systemctl start fmd-server-prod.service

echo "Services started!"

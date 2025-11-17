#!/usr/bin/env bash

# Helper script to STOP all services.
# E.g., run this BEFORE taking a backup.

set -eux

systemctl stop fmd-server-prod.service
systemctl stop fmd-server-beta.service
systemctl stop grafana-server.service
systemctl stop prometheus.service

echo "Services stopped!"

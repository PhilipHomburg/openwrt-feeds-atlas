#!/bin/sh
# Usage: verify-with-https <mac>
curl https://atlas.ripe.net/probes/probe-init-super-secret-X4YY4SDGSGQ/"$1"

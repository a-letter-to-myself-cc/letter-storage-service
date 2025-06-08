#!/bin/sh

echo "$GCP_SA_KEY" > /tmp/gcp-key.json
export GOOGLE_APPLICATION_CREDENTIALS="/tmp/gcp-key.json"

exec "$@"
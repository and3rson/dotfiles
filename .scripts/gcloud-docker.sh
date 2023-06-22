#!/bin/bash

set -e

gcloud auth login
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://us-docker.pkg.dev

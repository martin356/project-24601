#! /bin/bash

set -eu

SCRIPT_DIR="$(dirname "$0")"
PROJECT=$1
ENV=dev

PROJECT_INFRA_DIR=$SCRIPT_DIR/../$PROJECT/tf

echo -e "\nProject infra dir: $PROJECT_INFRA_DIR"

terraform -chdir=$PROJECT_INFRA_DIR apply -var="env=$ENV" ${@:2}

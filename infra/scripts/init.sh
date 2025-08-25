#! /bin/bash

set -eu

SCRIPT_DIR="$(dirname "$0")"
PROJECT=$1
ENV=dev

PROJECT_INFRA_DIR=$SCRIPT_DIR/../$PROJECT/tf
STATE_FILE="../../.tfstates/$PROJECT-$ENV.tfstate"

echo -e "\nProject infra dir: $PROJECT_INFRA_DIR"
echo -e "State file: $STATE_FILE\n"

terraform -chdir=$PROJECT_INFRA_DIR init ${@:2} -backend-config="path=$STATE_FILE"

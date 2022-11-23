PODS_ROOT=Pods
SRCROOT="."
TARGET_NAME="BankAPI"

cd "${SRCROOT}/${TARGET_NAME}"
SCRIPT_PATH="../${PODS_ROOT}/Apollo/scripts"
"${SCRIPT_PATH}"/run-bundled-codegen.sh schema:download "../app-daily-banking-graphql/schema.json" --endpoint="https://graphql.dev-foundation.com/graphql"

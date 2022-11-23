PODS_ROOT=Pods
SRCROOT="."
TARGET_NAME="BankAPI"

cd "${SRCROOT}/${TARGET_NAME}"
SCRIPT_PATH="../${PODS_ROOT}/Apollo/scripts"

"${SCRIPT_PATH}"/run-bundled-codegen.sh codegen:generate --target=swift --includes=../app-daily-banking-graphql/**/*.graphql --localSchemaFile="../app-daily-banking-graphql/schema.json" GraphQL/API.Generated.swift

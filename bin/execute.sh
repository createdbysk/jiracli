#!/usr/bin/env bash

JIRA_URL=$1
JIRA_USERNAME=$2
JIRA_PASSWORD=$3
TEMPLATE=$4
JQL=$5
REPO_BASE_URL=$6
REF=$7
BIN_DIR=bin


mkdir -p ${BIN_DIR}
curl -L -o ${BIN_DIR}/jiracli.zip ${REPO_BASE_URL}/-/jobs/artifacts/${REF}/download?job=publish
unzip ${BIN_DIR}/jiracli.zip

JIRA_URL=${JIRA_URL} \
JIRA_USERNAME=${JIRA_USERNAME} \
JIRA_PASSWORD=${JIRA_PASSWORD} \
    ./bin/jiracli ${TEMPLATE} ${JQL}

# rm -rf ${BIN_DIR}



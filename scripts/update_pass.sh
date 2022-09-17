#!/bin/bash

if [ -n "$1" ]; then
    export ARGO_SERVER=$1
else
    echo 'Type the argocd server:'
    read ARGO_SERVER
fi

if [ -n "$2" ]; then
    export ARGO_USER=$2
else
    echo 'Type the username:'
    read ARGO_USER
fi

if [ -n "$3" ]; then
    export NEW_PASS=$3
else
    echo 'Type the new password:'
    read NEW_PASS
fi

export ARGO_PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Current password: ${ARGO_PASS}"

if [ ARGO_USER = "admin" ]; then
    kubectl -n argocd patch secret argocd-initial-admin-secret -p "{\"data\": {\"password\": \"$(echo ${NEW_PASS} | base64)\"}}"
fi

argocd login ${ARGO_SERVER} --username admin --password ${ARGO_PASS} --grpc-web
argocd account update-password --server ${ARGO_SERVER} --account ${ARGO_USER} --current-password ${ARGO_PASS} --new-password ${NEW_PASS} --grpc-web

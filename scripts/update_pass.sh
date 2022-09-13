#!/bin/bash

export ARGO_PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Current password: ${ARGO_PASS}"
argocd login --username admin localhost:8888 --password ${ARGO_PASS}
argocd account update-password --account admin --current-password ${ARGO_PASS} --new-password admin123
# argocd account update-password --account team-product --current-password ${ARGO_PASS} --new-password password123

#!/bin/bash

kubectl create namespace argocd      
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f projects/argo-application.yaml
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d | pbcopy

# update read pass
argocd login localhost:8888
argocd account update-password --account read --new-password password123
argocd account update-password --account sync --new-password password123
argocd account update-password --account project --new-password password123
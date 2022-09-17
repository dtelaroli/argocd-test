SHELL:=/bin/bash
.ONESHELL:

.PHONY: install
install:
	@kubectl patch svc traefik -n kube-system -p '{"spec": {"type": "ClusterIP"}}' | true
	@kubectl config use-context rancher-desktop
	@kubectl create namespace argocd | true   
	@kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	@kubectl apply -f projects/argo-application.yaml

	@make wait
	@make forward &
	@bash scripts/update_pass.sh "localhost:8888" "admin" "admin123"
	@make wait
	@kubectl rollout restart deployment/istio-ingressgateway -n istio-system
	@make wait
	@kubectl rollout restart deployment/argocd-server -n argocd

wait:
	@echo 'Waiting 30 seconds'
	@sleep 30

.PHONY: update_pass
update_pass:
	@bash scripts/update_pass.sh "argocd.mydomain.com" "team-product" "admin123"

forward:
	@kubectl port-forward svc/argocd-server -n argocd 8888:80

.PHONY: git
git:
	@eval `ssh-agent`
	@git add --all && git commit --amend --no-edit && git push origin main -f

cert:
	@openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=mydomain Inc./CN=mydomain.com' -keyout mydomain.com.key -out mydomain.com.crt
	
	@openssl req -out argocd.mydomain.com.csr -newkey rsa:2048 -nodes -keyout argocd.mydomain.com.key -subj "/CN=argocd.mydomain.com/O=my organization"
	@openssl x509 -req -sha256 -days 365 -CA mydomain.com.crt -CAkey mydomain.com.key -set_serial 0 -in argocd.mydomain.com.csr -out argocd.mydomain.com.crt
	@kubectl create -n istio-system secret tls argocd-credential --key=argocd.mydomain.com.key --cert=argocd.mydomain.com.crt --dry-run=client -o yaml > argocd-secret.yaml
	
	@openssl req -out guestbook.mydomain.com.csr -newkey rsa:2048 -nodes -keyout guestbook.mydomain.com.key -subj "/CN=guestbook.mydomain.com/O=my organization"
	@openssl x509 -req -sha256 -days 365 -CA mydomain.com.crt -CAkey mydomain.com.key -set_serial 0 -in guestbook.mydomain.com.csr -out guestbook.mydomain.com.crt
	@kubectl create -n istio-system secret tls guestbook-credential --key=guestbook.mydomain.com.key --cert=guestbook.mydomain.com.crt --dry-run=client -o yaml > guestbook-secret.yaml

	@rm *.crt *.key *.csr
	@mv argocd-secret.yaml guestbook-secret.yaml apps/3rd/istio/gateways/

.PHONY: help
help: ## Display help screen
	@echo "Usage:"
	@echo "	make [COMMAND]"
	@echo "	make help "
	@echo "Commands:"
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

SHELL:=/bin/bash
.ONESHELL:

.PHONY: init
init:
	make install
	make change_pass

.PHONY: install
install:
	bash ./scripts/install.sh

.PHONY: forward
forward:
	kubectl port-forward svc/argocd-server -n argocd 8888:https

.PHONY: change_pass
change_pass:
	bash ./scripts/update_pass.sh

.PHONY: cert
git:
	eval `ssh-agent`
	git add --all && git commit --amend --no-edit && git push origin main -f

cert:
	openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=mydomain Inc./CN=mydomain.com' -keyout mydomain.com.key -out mydomain.com.crt
	
	openssl req -out argocd.mydomain.com.csr -newkey rsa:2048 -nodes -keyout argocd.mydomain.com.key -subj "/CN=*.mydomain.com/O=httpbin organization"
	openssl x509 -req -sha256 -days 365 -CA mydomain.com.crt -CAkey mydomain.com.key -set_serial 0 -in argocd.mydomain.com.csr -out argocd.mydomain.com.crt
	kubectl create -n istio-system secret tls argocd-credential --key=argocd.mydomain.com.key --cert=argocd.mydomain.com.crt --dry-run=client -o yaml > argocd-secret.yaml
	
	openssl req -out guestbook.mydomain.com.csr -newkey rsa:2048 -nodes -keyout guestbook.mydomain.com.key -subj "/CN=*.mydomain.com/O=httpbin organization"
	openssl x509 -req -sha256 -days 365 -CA mydomain.com.crt -CAkey mydomain.com.key -set_serial 0 -in guestbook.mydomain.com.csr -out guestbook.mydomain.com.crt
	kubectl create -n istio-system secret tls guestbook-credential --key=guestbook.mydomain.com.key --cert=guestbook.mydomain.com.crt --dry-run=client -o yaml > guestbook-secret.yaml

	rm *.crt *.key *.csr
	mv argocd-secret.yaml guestbook-secret.yaml apps/3rd/istio/gateways/

.PHONY: help
help: ## Display help screen
	@echo "Usage:"
	@echo "	make [COMMAND]"
	@echo "	make help "
	@echo "Commands:"
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

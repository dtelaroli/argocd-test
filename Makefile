# .PHONY
install:
	bash ./scripts/install.sh

forward:
	kubectl port-forward svc/argocd-server -n argocd 8888:80 &

change_pass:
	bash ./scripts/update_pass.sh

# .PHONY
create_root:
	kubectl apply -f projects/argo-application.yaml

test:
	curl -i http://guestbook-ui-example.com:8880/
	curl -i https://guestbook-ui-example.com:4443/

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
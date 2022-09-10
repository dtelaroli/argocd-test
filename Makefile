# .PHONY
install:
	sh scripts/install.sh

# .PHONY
create:
	kubectl apply -f projects/argo-application.yaml
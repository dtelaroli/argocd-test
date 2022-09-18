# argocd-test

Project to demonstrate ArgoCD implementation.

<img src="https://argocd.mydomain.com/api/badge?name=3rd" alt="status"/>

## Installation

Execute the command below:

```shell
make init
```

## Componentes

- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
- [Argo Rollouts](https://argoproj.github.io/argo-rollouts/)
- [Istio](https://istio.io)
- [Github Actions](https://github.com/features/actions)


## Tree

```shell
.
├── Makefile
├── README.md
├── apps
│   ├── 3rd
│   │   ├── argo-rollouts
│   │   │   └── kustomization.yaml
│   │   ├── argocd
│   │   │   ├── kustomization.yaml
│   │   │   ├── patches
│   │   │   │   ├── argocd-cm.yaml
│   │   │   │   ├── argocd-cmd-params-cm.yaml
│   │   │   │   └── argocd-rbac-cm.yaml
│   │   │   └── virtual-service.yaml
│   │   └── istio
│   │       ├── base
│   │       │   ├── Chart.yaml
│   │       │   └── requirements.yaml
│   │       ├── d
│   │       │   ├── Chart.yaml
│   │       │   └── requirements.yaml
│   │       ├── gateways
│   │       │   ├── argocd-secret.yaml
│   │       │   ├── gateway.yaml
│   │       │   ├── guestbook-secret.yaml
│   │       │   └── kustomization.yaml
│   │       └── ingress-gateway
│   │           ├── Chart.yaml
│   │           └── requirements.yaml
│   └── teams
│       └── team-product
│           ├── api
│           │   ├── argo-rollout.yaml
│           │   ├── destination-rule.yaml
│           │   ├── kustomization.yaml
│           │   ├── service.yaml
│           │   └── virtual-service.yaml
│           └── kustomization.yaml
├── environments
│   └── dev
│       └── config.yaml
├── projects
│   ├── argo-application.yaml
│   ├── kustomization.yaml
│   └── root
│       ├── 3rd
│       │   ├── argo-application.yaml
│       │   ├── argo-project.yaml
│       │   ├── argo-rollouts
│       │   │   ├── argo-applicationset.yaml
│       │   │   └── kustomization.yaml
│       │   ├── argocd
│       │   │   ├── argo-application.yaml
│       │   │   └── kustomization.yaml
│       │   ├── istio
│       │   │   ├── _requisites
│       │   │   │   ├── kustomization.yaml
│       │   │   │   ├── namespace-istio-gateways.yaml
│       │   │   │   └── namespace-istio-system.yaml
│       │   │   ├── base
│       │   │   │   ├── argo-application.yaml
│       │   │   │   └── kustomization.yaml
│       │   │   ├── d
│       │   │   │   ├── argo-application.yaml
│       │   │   │   └── kustomization.yaml
│       │   │   ├── gateways
│       │   │   │   ├── argo-application.yaml
│       │   │   │   └── kustomization.yaml
│       │   │   ├── ingress-gateway
│       │   │   │   ├── argo-application.yaml
│       │   │   │   └── kustomization.yaml
│       │   │   └── kustomization.yaml
│       │   └── kustomization.yaml
│       ├── kustomization.yaml
│       └── teams
│           ├── argo-application.yaml
│           ├── argo-project.yaml
│           ├── kustomization.yaml
│           └── team-product
│               ├── _requisites
│               │   ├── kustomization.yaml
│               │   └── namespace.yaml
│               ├── api
│               │   ├── argo-applicationset.yaml
│               │   └── kustomization.yaml
│               ├── argo-application.yaml
│               ├── argo-project.yaml
│               └── kustomization.yaml
└── scripts
    └── update_pass.sh
```
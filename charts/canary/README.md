# Canary helm template

## Usage

Create these files:

```yml
# Chart.yaml
name: canary
version: 0.0.1-SNAPSHOT
appVersion: 0.0.1-SNAPSHOT
```

```yml
# requirements.yaml
dependencies:
  - name: canary
    version: 0.0.1-SNAPSHOT
    repository: file://../../../../charts/canary
```

## Values

```yml
canary:
  environment: dev
  application: foo
  image_repository: foo
  version: latest
  port: 80
```

Execute the commands:

```shell
helm dependency build
helm template ./
```

## Overriding the parameters

```shell
helm template ./\
    --set canary.environment=dev\
    --set canary.application=foo\
    --set canary.image_repository=foo\
    --set canary.version=latest\
    --set canary.port=80
```
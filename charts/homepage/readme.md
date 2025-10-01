# Homepage

A modern (fully static, fast), secure (fully proxied), highly customizable application dashboard with integrations for more than 25 services and translations for over 15 languages. Easily configured via YAML files (or discovery via docker labels).

**Source:** [gethomepage/homepage](https://gethomepage.dev) | [GitHub](https://github.com/gethomepage/homepage)

## TL;DR

```bash
helm repo add jameswynn http://jameswynn.github.io/helm-charts
helm install my-release jameswynn/homepage
```

## Introduction

This chart bootstraps a [Homepage](https://github.com/gethomepage/homepage) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install my-release jameswynn/homepage
```

The command deploys Homepage on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

## Parameters

This chart is based on [bjw-s library](https://bjw-s.github.io/helm-charts/docs/common-library/introduction/) and
shares many configuration options with its derived [app-template](https://bjw-s.github.io/helm-charts/docs/app-template/introduction/).

### Environment Variables

This chart supports three methods for injecting environment variables:

**1. Simple key-value format (recommended for basic use cases):**
```yaml
envVars:
  TZ: "America/New_York"
  LOG_LEVEL: "info"
  HOMEPAGE_VAR_TITLE: "My Dashboard"
```

**2. Advanced array format (for complex configurations):**
```yaml
env:
  - name: MY_VAR
    value: "simple-value"
  - name: SECRET_VAR
    valueFrom:
      secretKeyRef:
        name: my-secret
        key: password
```

**3. Reference existing ConfigMaps/Secrets:**
```yaml
envFrom:
  - secretRef:
      name: homepage-secrets
  - configMapRef:
      name: homepage-config
```

All three methods can be used together and will be merged into the deployment.

See the [values.yaml](values.yaml) for more examples and configuration options.

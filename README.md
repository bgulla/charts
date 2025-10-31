# My Personal Charts

![action build](https://github.com/bgulla/charts/actions/workflows/release.yaml/badge.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/bgulla/charts)
![Helm](https://img.shields.io/badge/Helm-3-blue)
![License](https://img.shields.io/github/license/bgulla/charts)
![Works on my machine](https://img.shields.io/badge/works%20on-my%20machine-success)
![Coffee Driven](https://img.shields.io/badge/powered%20by-coffee-brown)
![Yaml Files](https://img.shields.io/badge/yaml%20files-too%20many-red)
![Stack Overflow](https://img.shields.io/badge/stolen%20from-stack%20overflow-orange)
![Bugs](https://img.shields.io/badge/bugs-it's%20a%20feature-purple)

![HelmCharts](/static/meme.png?raw=true)

A collection of personal Helm charts for Kubernetes deployments.

## Automated Chart Releases

This repository uses GitHub Actions to automatically build and publish Helm charts in **two formats**:

### Traditional Repository (GitHub Pages)
- Creates GitHub releases with chart artifacts (.tgz)
- Updates the Helm repository index on GitHub Pages
- Available via `helm repo add`

### OCI Registry (GitHub Container Registry)
- Publishes charts as OCI artifacts to ghcr.io
- No repository index needed
- Native support in modern Helm and GitOps tools

No manual intervention needed - just bump the version in `Chart.yaml` and push!

## Available Charts

| Chart | Description | Source |
|-------|-------------|--------|
| **immich** | Self-hosted photo and video backup solution | https://github.com/bgulla/immich-charts |
| **kitchensink** | Kitchen sink demo application | |
| **kubeups** | Kubernetes UPS monitoring | |
| **meshmonitor** | Meshtastic Radio monitoring solution | https://github.com/yeraze/meshmonitor |
| **openwebrx** | Web-based SDR receiver | https://github.com/jketterl/openwebrx |
| **rancher-demo** | Rancher demonstration environment | |

## Installation

### Method 1: Traditional Helm Repository (GitHub Pages)

Add this Helm repository:

```bash
helm repo add bgulla https://bgulla.github.io/charts
helm repo update
```

Install a chart:

```bash
helm install my-release bgulla/<chart-name>
```

### Method 2: OCI Registry (Recommended for CI/CD)

Install directly from the OCI registry (no `helm repo add` needed):

```bash
# Install a specific version
helm install my-release oci://ghcr.io/bgulla/charts/<chart-name> --version <version>

# Example: Install kitchensink v0.1.0
helm install whoami oci://ghcr.io/bgulla/charts/kitchensink --version 0.1.0
```

**OCI Benefits:**
- No repository management needed
- Atomic, versioned artifacts
- Better for GitOps workflows (ArgoCD, Flux)
- Same infrastructure as container images

To see available versions:
```bash
# List tags (requires crane or similar OCI tool)
crane ls ghcr.io/bgulla/charts/<chart-name>
```

## Development

To package and test charts locally:

```bash
helm package charts/<chart-name>
helm install test-release ./<chart-name>-<version>.tgz
```

## License

This project is licensed under the **ANYONEBUTPHIL LICENSE** - a legally binding Apache 2.0 derivative with a singular, non-negotiable restriction: Philip Brooks is explicitly prohibited from using, modifying, or distributing this software. Everyone else is welcome to use it freely under standard Apache 2.0 terms. Yes, this is a real license. No, we're not joking. Phil knows what he did. See the [LICENSE](LICENSE) file for full details.

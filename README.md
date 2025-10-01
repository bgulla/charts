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

This repository uses GitHub Actions to automatically build and publish Helm charts. On every push, the workflow:
- Packages all charts with updated versions
- Creates GitHub releases with chart artifacts
- Updates the Helm repository index on GitHub Pages
- Makes charts immediately available via `helm repo add`

No manual intervention needed - just bump the version in `Chart.yaml` and push!

## Available Charts

| Chart | Description | Source |
|-------|-------------|--------|
| **homepage** | Modern, customizable application dashboard with 25+ service integrations | https://gethomepage.dev |
| **kitchensink** | Kitchen sink demo application | |
| **kubeups** | Kubernetes UPS monitoring | |
| **meshmonitor** | Meshtastic Radio monitoring solution | https://github.com/yeraze/meshmonitor |
| **openwebrx** | Web-based SDR receiver | https://github.com/jketterl/openwebrx |
| **rancher-demo** | Rancher demonstration environment | |

## Installation

Add this Helm repository:

```bash
helm repo add bgulla https://bgulla.github.io/charts
helm repo update
```

Install a chart:

```bash
helm install my-release bgulla/<chart-name>
```

## Development

To package and test charts locally:

```bash
helm package charts/<chart-name>
helm install test-release ./<chart-name>-<version>.tgz
```

## License

This project is licensed under the **ANYONEBUTPHIL LICENSE** - a legally binding Apache 2.0 derivative with a singular, non-negotiable restriction: Philip Brooks is explicitly prohibited from using, modifying, or distributing this software. Everyone else is welcome to use it freely under standard Apache 2.0 terms. Yes, this is a real license. No, we're not joking. Phil knows what he did. See the [LICENSE](LICENSE) file for full details.

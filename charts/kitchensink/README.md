# KitchenSink CHART!

A flexible Helm chart for deploying media applications and other workloads on Kubernetes.

## Features

- Configurable persistence (PVC and NFS mounts)
- Support for environment variables via `env` and `envFrom` (ConfigMaps and Secrets)
- Ingress configuration with annotations
- Customizable resource limits and node affinity

## Setting Up via Helm
```bash
> helm repo add bgulla https://bgulla.github.io/charts
> helm search repo bgulla
NAME                	CHART VERSION	APP VERSION	DESCRIPTION
bgulla/homeassistant	0.1.0        	1.16.0     	A Helm chart for Kubernetes
bgulla/kitchensink  	0.1.0        	1.0        	A Helm chart for deploying media applications
bgulla/kubeups      	0.1.0        	1.16.0     	A Helm chart for Kubernetes
bgulla/mosquitto    	2.4.1        	1.6.12     	Eclipse Mosquitto is an open source message bro...
bgulla/openwebrx    	0.1.0        	           	Helm chart for deploying OpenWebRX
bgulla/rancher-demo 	0.1.0        	           	A Helm chart for Kubernetes to deploy the bgull...
```

## Fleet Reference
#### `fleet.yaml`
```yaml
## fleet.yaml
defaultNamespace: media

labels:
  app: metube

helm:
  releaseName: metube
  chart: kitchensink 
  repo: https://bgulla.github.io/charts
  valuesFiles:
    - values.yaml
```

#### `values.yaml`
```yaml
## values.yaml
replicaCount: 1
fullnameOverride: metube

image:
  repository: ghcr.io/alexta69/metube
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 8081 # metube

# Add the following for configurable UID and GID
PUID: 1027
PGID: 100

env:
  AUDIO_DOWNLOAD_DIR: "/audio"

# envFrom allows you to set environment variables from ConfigMaps or Secrets
# envFrom:
#   - configMapRef:
#       name: app-config
#   - secretRef:
#       name: app-secrets

ingress:
  enabled: true
  className: ""
  annotations:
    gethomepage.dev/enabled: "true"
    gethomepage.dev/description: download the tube
    gethomepage.dev/group: Media
    gethomepage.dev/name: metube
    gethomepage.dev/icon: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/1024px-YouTube_full-color_icon_%282017%29.svg.png"
  hosts:
    - host: metube.tpi.l0l0.lol
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: []
    # - secretName: tls-tpi-wildcard
      # hosts:
      #   - metube.tpi.l0l0.lol

persistence:
  config:
    enabled: true
    storageClass: ""
    accessMode: ReadWriteMany
    size: 1Gi
  nfs:
    enabled: true
    mounts: 
      - name: metube-videos
        server: nas1.l0l0.lol
        path: "/volume1/media/downloads/ytdl/videos"
        mountPath: "/downloads"
      - name: metube-audio
        server: nas1.l0l0.lol
        path: "/volume1/media/downloads/ytdl/audio"
        mountPath: "/audio"

resources: {}
nodeSelector: {}
tolerations: []
affinity: {}

```

## Configuration

### Environment Variables

The chart supports two ways to configure environment variables:

#### Direct Environment Variables (`env`)
Set individual environment variables using key-value pairs:

```yaml
env:
  TZ: "America/New_York"
  AUDIO_DOWNLOAD_DIR: "/audio"
```

#### Environment Variables from ConfigMaps/Secrets (`envFrom`)
Load all environment variables from ConfigMaps or Secrets:

```yaml
envFrom:
  - configMapRef:
      name: transmission-openvpn-config
  - secretRef:
      name: transmission-openvpn-secret
```

This is useful for applications that require many environment variables or when you want to manage configuration separately from the Helm values.

### Security Context

The chart supports setting security context options for containers that require additional capabilities (e.g., VPN containers):

```yaml
securityContext:
  capabilities:
    add:
      - NET_ADMIN
      - NET_RAW
```

This is required for applications like transmission-openvpn that need to create TUN devices and modify network routing tables.

### Persistence

The chart supports two types of persistence:

#### PVC Storage
```yaml
persistence:
  config:
    enabled: true
    storageClass: ""
    accessMode: ReadWriteMany
    size: 1Gi
    mountPath: /config
```

#### NFS Mounts
```yaml
persistence:
  nfs:
    enabled: true
    mounts:
      - name: media-videos
        server: nas1.example.com
        path: "/volume1/media/videos"
        mountPath: "/downloads"
```

built by github actions

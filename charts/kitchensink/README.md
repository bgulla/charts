# KitchenSink CHART!

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

built by github actions

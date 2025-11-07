# KitchenSink CHART!

A flexible Helm chart for deploying media applications and other workloads on Kubernetes.

## Features

- Configurable persistence (PVC and NFS mounts)
- Support for environment variables via `env` and `envFrom` (ConfigMaps and Secrets)
- ConfigMap and Secret volume mounts for configuration files and credentials
- Ingress configuration with annotations
- LoadBalancer service support with optional IP assignment and source range restrictions
- Built-in Homepage dashboard integration with automatic pod discovery
- External DNS integration for automatic DNS record management
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
  annotations: {}
  hosts:
    - host: metube.tpi.l0l0.lol
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: []
    # - secretName: tls-tpi-wildcard
      # hosts:
      #   - metube.tpi.l0l0.lol

homepage:
  enabled: true
  name: "Metube"
  description: "Download the tube"
  group: "Media"
  icon: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/1024px-YouTube_full-color_icon_%282017%29.svg.png"

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

### Service Configuration

The chart supports multiple service types including ClusterIP, NodePort, and LoadBalancer.

#### LoadBalancer Service

Use a LoadBalancer service to expose your application with an external IP address:

```yaml
service:
  type: LoadBalancer
  port: 80
```

#### LoadBalancer with Specific IP

Reserve and use a specific IP address for your LoadBalancer (requires your cloud provider or MetalLB to support IP allocation):

```yaml
service:
  type: LoadBalancer
  port: 80
  loadBalancerIP: "192.168.1.100"
```

#### LoadBalancer with Source Range Restrictions

Restrict which IP addresses can access your LoadBalancer:

```yaml
service:
  type: LoadBalancer
  port: 80
  loadBalancerIP: "192.168.1.100"
  loadBalancerSourceRanges:
    - "10.0.0.0/8"
    - "192.168.1.0/24"
```

**Parameters:**
- `type` - Service type: `ClusterIP`, `NodePort`, or `LoadBalancer`
- `port` - Service port number
- `loadBalancerIP` - (Optional) Specific IP address for LoadBalancer type
- `loadBalancerSourceRanges` - (Optional) List of IP CIDR ranges allowed to access the LoadBalancer

**Note:** LoadBalancer support requires a load balancer implementation in your cluster (e.g., cloud provider load balancer, MetalLB, etc.)

### Homepage Integration

The chart includes built-in support for [Homepage](https://gethomepage.dev/), a modern, customizable application dashboard. Homepage provides [Kubernetes service discovery](https://gethomepage.dev/latest/widgets/services/kubernetes/) through annotations.

#### Configuration

Enable Homepage integration by setting `homepage.enabled: true` and providing the display information:

```yaml
homepage:
  enabled: true
  name: "Metube"
  description: "YouTube downloader"
  group: "Media"
  icon: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/1024px-YouTube_full-color_icon_%282017%29.svg.png"
```

**Parameters:**
- `enabled` - Toggle Homepage integration (default: `false`)
- `name` - Display name shown in Homepage dashboard
- `description` - Short description of the service
- `group` - Category/group for organizing services in Homepage
- `icon` - Icon URL or [Material Design Icons](https://pictogrammers.com/library/mdi/) name (e.g., `mdi-plex`)

#### How It Works

When enabled, the chart automatically adds the required annotations to both the Ingress and Service resources:
- `gethomepage.dev/enabled: "true"`
- `gethomepage.dev/name: <name>`
- `gethomepage.dev/description: <description>`
- `gethomepage.dev/group: <group>`
- `gethomepage.dev/icon: <icon>`
- `gethomepage.dev/pod-selector: "app.kubernetes.io/instance=<release-name>"`

The `pod-selector` annotation is automatically configured to match your Helm release, ensuring Homepage can correctly discover and monitor the service.

**Note:** The old method of manually adding Homepage annotations to `ingress.annotations` is deprecated. Use the `homepage` section instead for cleaner configuration.

For more information about Homepage's Kubernetes integration, see the [Homepage Kubernetes documentation](https://gethomepage.dev/latest/widgets/services/kubernetes/).

### External DNS Integration

The chart includes built-in support for [external-dns](https://github.com/kubernetes-sigs/external-dns), which automatically manages DNS records for your ingress resources.

#### Basic Configuration

Enable external-dns to automatically manage DNS records for your ingress hostnames:

```yaml
externalDns:
  enabled: true
```

By default, external-dns will use all hostnames defined in `ingress.hosts`. The chart automatically generates the `external-dns.alpha.kubernetes.io/hostname` annotation with a comma-separated list of hostnames.

#### Custom Hostnames

You can override the automatic hostname detection and specify custom hostnames:

```yaml
externalDns:
  enabled: true
  hostnames:
    - app.example.com
    - app-alt.example.com
```

#### Custom TTL

Set a specific TTL (Time To Live) for DNS records:

```yaml
externalDns:
  enabled: true
  ttl: "300"  # 5 minutes
```

#### Complete Example

```yaml
ingress:
  enabled: true
  hosts:
    - host: myapp.example.com
      paths:
        - path: /
          pathType: Prefix

externalDns:
  enabled: true
  ttl: "600"
```

**How It Works:**
- When enabled, the chart adds `external-dns.alpha.kubernetes.io/hostname` annotation to the Ingress
- external-dns controller watches for this annotation
- DNS records are automatically created/updated in your DNS provider (configured in external-dns controller)
- If you don't specify custom hostnames, all hosts from `ingress.hosts` are used

**Prerequisites:**
- external-dns controller must be deployed in your cluster
- external-dns must be configured with your DNS provider credentials

For more information, see the [external-dns documentation](https://github.com/kubernetes-sigs/external-dns).

### ConfigMap and Secret Volume Mounts

The chart supports mounting ConfigMaps and Secrets as files in the container. This is useful for configuration files, credentials, certificates, and other sensitive data.

#### Mounting Entire ConfigMaps or Secrets

Mount all keys from a ConfigMap or Secret as files in a directory:

```yaml
volumeMounts:
  # Mount all keys from ConfigMap as files
  - name: app-config
    type: configMap
    configMapName: my-app-config
    mountPath: /etc/config

  # Mount all keys from Secret as files
  - name: app-secrets
    type: secret
    secretName: my-app-secrets
    mountPath: /etc/secrets
```

#### Mounting Specific Files

Mount a single key from a ConfigMap or Secret as a specific file:

```yaml
volumeMounts:
  # Mount a specific config file
  - name: nginx-config
    type: configMap
    configMapName: nginx-settings
    mountPath: /etc/nginx/nginx.conf
    subPath: nginx.conf

  # Mount SSH private key with specific permissions
  - name: ssh-key
    type: secret
    secretName: ssh-credentials
    mountPath: /root/.ssh/id_rsa
    subPath: id_rsa
    defaultMode: 0600
    readOnly: true
```

#### Advanced: Selective Key Mapping

Mount specific keys with custom filenames using the `items` parameter:

```yaml
volumeMounts:
  - name: app-config
    type: configMap
    configMapName: my-app-config
    mountPath: /etc/config
    items:
      - key: database.yaml
        path: db-config.yaml
      - key: api-settings.json
        path: api.json
```

**Parameters:**
- `name` - Unique name for the volume mount
- `type` - Either `configMap` or `secret`
- `configMapName` / `secretName` - Name of the ConfigMap or Secret
- `mountPath` - Where to mount in the container
- `subPath` - (Optional) Mount a single file instead of entire directory
- `defaultMode` - (Optional) File permissions in octal (e.g., `0600`, `0644`)
- `readOnly` - (Optional) Mount as read-only (default: false)
- `items` - (Optional) Map specific keys to custom filenames

### Persistence

The chart supports multiple persistence options that can be used independently or combined:

#### Multiple PVC Support (Recommended)

Define multiple PersistentVolumeClaims for different mount points:

```yaml
persistence:
  pvcs:
    # Configuration storage
    - name: config
      storageClass: "local-path"
      accessMode: ReadWriteOnce
      size: 1Gi
      mountPath: /config

    # Application data
    - name: data
      storageClass: "fast-ssd"
      accessMode: ReadWriteOnce
      size: 10Gi
      mountPath: /data

    # Logs or cache
    - name: logs
      storageClass: ""  # Uses default storage class
      accessMode: ReadWriteOnce
      size: 5Gi
      mountPath: /var/log
```

**Parameters:**
- `name` - Name suffix for the PVC (will be `<release-name>-<name>`)
- `storageClass` - Storage class name (empty string uses default)
- `accessMode` - Access mode: `ReadWriteOnce`, `ReadWriteMany`, or `ReadOnlyMany` (defaults to `ReadWriteOnce`)
- `size` - Storage size (e.g., `1Gi`, `10Gi`)
- `mountPath` - Container mount path

#### Legacy Single PVC (Backward Compatible)

For existing deployments, the legacy single PVC configuration is still supported:

```yaml
persistence:
  config:
    enabled: true
    storageClass: ""
    accessMode: ReadWriteOnce
    size: 1Gi
    mountPath: /config
```

**Note:** For new deployments, use the `pvcs` array above for greater flexibility.

#### NFS Mounts

Mount NFS shares directly without requiring PVCs. Multiple NFS mounts are supported and can be used alongside PVCs:

```yaml
persistence:
  nfs:
    enabled: true
    mounts:
      # Media library
      - name: media-videos
        server: nas1.example.com
        path: "/volume1/media/videos"
        mountPath: "/downloads"

      # Backup directory
      - name: backups
        server: nas1.example.com
        path: "/volume1/backups"
        mountPath: "/backups"
```

#### Combined Example

You can use multiple PVCs and NFS mounts together:

```yaml
persistence:
  # Multiple PVCs for app data
  pvcs:
    - name: config
      size: 1Gi
      mountPath: /config
    - name: cache
      size: 5Gi
      mountPath: /cache

  # NFS mounts for shared media
  nfs:
    enabled: true
    mounts:
      - name: media
        server: nas1-10g.lark.lol
        path: "/volume1/media"
        mountPath: "/media"
```

built by github actions

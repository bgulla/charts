# Makefile for kitchensinkchart Helm chart

# Variables
CHART_NAME := kitchensink
RELEASE_NAME := kitchensink
NAMESPACE := default
HELM := helm

# Targets
.PHONY: all lint package install upgrade uninstall clean

all: lint package

# Lint the Helm chart
lint:
	$(HELM) lint .
	
# Package the Helm chart
package:
	$(HELM) package .
	

# Upgrade the Helm chart
install:
	$(HELM) upgrade --values ./values.yaml $(RELEASE_NAME) $(CHART_NAME) --namespace $(NAMESPACE) 

# Uninstall the Helm chart
uninstall:
	$(HELM) uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)

# Clean up the packaged chart
clean:
	rm -f $(CHART_NAME)-*.tgz

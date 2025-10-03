.PHONY: lint template install upgrade uninstall clean

CHART_NAME := meshmonitor
NAMESPACE := meshmonitor
RELEASE_NAME := $(CHART_NAME)

lint:
	helm lint .

template:
	helm template $(RELEASE_NAME) .

install:
	helm install $(RELEASE_NAME) . -n $(NAMESPACE) 

upgrade:
	helm upgrade --install $(RELEASE_NAME) . -n $(NAMESPACE) --values ./values-prob.yaml --create-namespace

uninstall:
	helm uninstall $(RELEASE_NAME) -n $(NAMESPACE)

clean:
	rm -rf charts/*.tgz

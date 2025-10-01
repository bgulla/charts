.PHONY: lint template install upgrade uninstall clean

CHART_NAME := meshmonitor
NAMESPACE := default
RELEASE_NAME := $(CHART_NAME)

lint:
	helm lint .

template:
	helm template $(RELEASE_NAME) .

install:
	helm install $(RELEASE_NAME) . -n $(NAMESPACE)

upgrade:
	helm upgrade --install $(RELEASE_NAME) . -n $(NAMESPACE)

uninstall:
	helm uninstall $(RELEASE_NAME) -n $(NAMESPACE)

clean:
	rm -rf charts/*.tgz

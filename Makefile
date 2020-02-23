IMAGE_NAME ?= vanities/wireguard-ui
IMAGE_VERSION ?= latest
DOCKER_TAG := $(IMAGE_NAME):$(IMAGE_VERSION)

.PHONY: binary container release ui

binary: go-binary ui

go-binary:
	go-bindata-assetfs -prefix ui/dist ui/dist
	go build .

ui:
	cd ui && npm install && npm run build

container:
	docker build --tag $(DOCKER_TAG) .

release: container
	docker push $(DOCKER_TAG)

run-dev: go-binary
	sudo ./wireguard-ui --log-level=debug --dev-ui-server=http://localhost:5000

run-dev-ui: ui
	cd ui && npm run dev

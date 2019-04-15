IMAGE ?= esolitos/jackett
JACKETT_VER ?= $(shell echo "${JACKETT_VER:-latest}")

TAG ?= $(JACKETT_VER)

test:
	true

image:
	docker build -t $(IMAGE):$(TAG) --build-arg JACKETT_VER=$(JACKETT_VER) .

push:
	docker push $(IMAGE):$(TAG)


.PHONY: image push test

IMAGE_NAME=fit4110/access-gate
IMAGE_TAG=lab04
CONTAINER_NAME=fit4110-gate-lab04
PORT=8000

.PHONY: install lint mock build run test-mock test-local stop clean

install:
	npm install

lint:
	npm run lint:openapi

mock:
	npm run mock:gate

build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

run:
	docker run -d --rm \
		--name $(CONTAINER_NAME) \
		-p $(PORT):8000 \
		--env-file .env.example \
		$(IMAGE_NAME):$(IMAGE_TAG)

test-mock:
	npm run test:mock

test-local:
	npm run test:local

test-docker: run
	sleep 5
	npx wait-on tcp:$(PORT) --timeout 30000
	npm run test:local
	docker stop $(CONTAINER_NAME) || true

stop:
	docker stop $(CONTAINER_NAME) || true

clean:
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG) || true

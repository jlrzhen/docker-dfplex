APP=docker-dfplex
IMAGE=$(APP):v1.0
PORT=8000

default:
	echo default
build: clean remove
	docker build -t $(IMAGE) .
clean:
	docker container prune -f
	docker image prune -f
remove:
	docker image rm $$(docker images | grep $(APP) | head -2 | tail -1 | awk '{print $$3}') || \
	echo "no image found"
start: build
	docker run \
	--publish $(PORT):$(PORT) \
	--publish 1234:1234 \
	--publish 5000:5000 \
	--network host \
	--security-opt=seccomp=unconfined \
	$(IMAGE)
stop:
	@docker stop $$(docker ps | grep $(APP) | head -2 | tail -1 | awk '{print $$1}')
deploy: build start
all: build push

build:
	docker build . -t gcr.io/mwasser-personal/mail-monitor
	docker tag gcr.io/mwasser-personal/mail-monitor gcr.io/mwasser-personal/mail-monitor:latest

push:
	docker push gcr.io/mwasser-personal/mail-monitor
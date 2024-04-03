# swf-editor-envelope
## This is a PoC, expect low quality 😅

### Description
Containerizes [this repo](https://github.com/apache/incubator-kie-kogito-online/tree/gh-pages/swf-chrome-extension/0.32.0) and serves those files using a static file server. 

### Instructions

#### Build the container
```sh
docker build --tag=swf-editor-envelope:0.32.0-latest .
```

#### Run the container
```sh
docker run \
  -p 8080:8080 \
  -d \
  --rm \
  --add-host=host.docker.internal:host-gateway \
  swf-editor-envelope:0.32.0-latest
```

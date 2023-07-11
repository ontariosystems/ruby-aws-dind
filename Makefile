DOCKER_LIB_COMMIT=8becbdadcc71b5376c9ee193ca2740cd90549da5
DOCKER_VERSION=24
RUBY_VERSION=3.2.2

.PHONY: clean
clean:
	rm -rf pkg

.PHONY: prep
prep: pkg/Dockerfile pkg/docker-entrypoint.sh pkg/modprobe.sh pkg/dockerd-entrypoint.sh

.PHONY: image
image: prep
	docker build \
		--build-arg RUBY_VERSION=$(RUBY_VERSION) \
		--tag local/ruby-dind:$(RUBY_VERSION) \
		-f pkg/Dockerfile \
		pkg

pkg:
	mkdir -p $@

pkg/docker: | pkg
	mkdir -p $@
	curl -fsSL https://github.com/docker-library/docker/archive/$(DOCKER_LIB_COMMIT).tar.gz | \
		tar -xxz -C $@ --strip-components 1

pkg/docker-entrypoint.sh pkg/modprobe.sh: pkg/docker
	cp pkg/docker/$(DOCKER_VERSION)/cli/$(notdir $@) $@

pkg/dockerd-entrypoint.sh: pkg/docker
	cp pkg/docker/$(DOCKER_VERSION)/dind/$(notdir $@) $@

pkg/Dockerfile: pkg/docker Dockerfile
	cp Dockerfile $@
	sed '/^FROM .*/d'  pkg/docker/$(DOCKER_VERSION)/cli/Dockerfile >> $@
	sed '/^FROM .*/d'  pkg/docker/$(DOCKER_VERSION)/dind/Dockerfile >> $@
	sed '/^FROM .*/d'  pkg/docker/$(DOCKER_VERSION)/dind-rootless/Dockerfile >> $@

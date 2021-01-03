# Makefile

# local config
SWIFT_BUILD=swift build
SWIFT_CLEAN=swift package clean
SWIFT_BUILD_DIR=.build
CONFIGURATION=release

# docker config
SWIFT_BUILD_IMAGE="swift:5.3.1"
#SWIFT_BUILD_IMAGE="swift:5.1.3"
#SWIFT_BUILD_IMAGE="swift:5.0.3"
DOCKER_BUILD_DIR=".docker.build"
SWIFT_DOCKER_BUILD_DIR="$(DOCKER_BUILD_DIR)/x86_64-unknown-linux/$(CONFIGURATION)"
DOCKER_BUILD_PRODUCT="$(DOCKER_BUILD_DIR)/$(TOOL_NAME)"

XENIAL_DOCKER_IMAGE=swiftlang/swift:nightly-5.3-xenial
XENIAL_DESTINATION=/usr/local/lib/swift/dst/x86_64-unknown-linux/swift-5.3-ubuntu16.04.xtoolchain/destination.json


SWIFT_SOURCES=Sources/*/*.swift

all:
	$(SWIFT_BUILD) -c $(CONFIGURATION)
	
clean :
	$(SWIFT_CLEAN)
	# We have a different definition of "clean", might be just German
	# pickyness.
	rm -rf $(SWIFT_BUILD_DIR) 

lambda: express-simple-lambda


# Building for Linux

#-d 5.2
express-simple-lambda:
	swift lambda build -p express-simple-lambda 

xc-xenial:
	$(SWIFT_BUILD) -c $(CONFIGURATION) --destination $(XENIAL_DESTINATION)

$(DOCKER_BUILD_PRODUCT): $(SWIFT_SOURCES)
	time docker run --rm \
          -v "$(PWD):/src" \
          -v "$(PWD)/$(DOCKER_BUILD_DIR):/src/.build" \
          "$(SWIFT_BUILD_IMAGE)" \
          bash -c 'cd /src && swift build -c $(CONFIGURATION)'
	ls -lah $(DOCKER_BUILD_PRODUCT)

docker-all: $(DOCKER_BUILD_PRODUCT)

docker-clean:
	rm $(DOCKER_BUILD_PRODUCT)	
	
docker-distclean:
	rm -rf $(DOCKER_BUILD_DIR)

distclean: clean docker-distclean

docker-emacs:
	docker run --rm -it \
          -v "$(PWD):/src" \
          -v "$(PWD)/$(DOCKER_BUILD_DIR):/src/.build" \
          $(SWIFT_BUILD_IMAGE) \
          emacs /src

docker-run: docker-all
	docker run --rm -it \
          -v "$(PWD):/src" \
          -v "$(PWD)/$(DOCKER_BUILD_DIR):/src/.build" \
          --workdir "/src" \
          -p 1337:1337 \
          $(SWIFT_BUILD_IMAGE) \
          .build/$(CONFIGURATION)/httpd-helloworld
		
xc-xenial-docker-run: xc-xenial
	docker run --rm -it \
          --name test-x-build \
          --volume "$(PWD)/.build/x86_64-unknown-linux/$(CONFIGURATION):/run" \
          --workdir "/run" \
          -p 1337:1337 \
          $(XENIAL_DOCKER_IMAGE) \
          bash -c "LD_LIBRARY_PATH=/usr/lib/swift/linux ./httpd-helloworld"

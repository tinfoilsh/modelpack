clean:
	rm -rf output

build:
	docker rm -f mp
	docker build -t tinfoil-modelpack .
	docker run --rm --name mp -v $(shell pwd)/output:/output -e MODEL=qwen:0.5b tinfoil-modelpack

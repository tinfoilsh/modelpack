include .env

clean:
	rm -rf output cache

build:
	docker build -t tinfoil-modelpack .

run:
	docker run --rm -it \
		-v $(shell pwd)/cache:/cache \
		-v $(shell pwd)/output:/output \
		-e HF_TOKEN=${HF_TOKEN} \
		-e MODEL=meta-llama/Llama-3.2-1B@4e20de362430cd3b72f300e6b0f18e50e7166e08 \
		tinfoil-modelpack

SHELL := /bin/bash
ROOT  := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

REMOTE_HOST  ?= pp-ltx2
REMOTE_PATH  ?= projects/ltx2

CONDA_ENV_NAME = ltx2

.DEFAULT_GOAL = env-shell

# -----------------------------------------------------------------------------
# conda environment
# -----------------------------------------------------------------------------

.PHONY: env-init-conda
env-init-conda:
	@conda create --yes --copy --name "$(CONDA_ENV_NAME)" \
		conda-forge::python=3.12.12 \
		conda-forge::poetry=2.2.1

.PHONY: env-init-ltx2
env-init-ltx2:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" --cwd "$(ROOT)/LTX-2" \
		pip install -e packages/ltx-core
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" --cwd "$(ROOT)/LTX-2" \
		pip install -e packages/ltx-pipelines

.PHONY: env-remove
env-remove:
	@conda env remove --yes --name "$(CONDA_ENV_NAME)"

.PHONY: env-shell
env-shell:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" --cwd "$(ROOT)/LTX-2" \
		bash

.PHONY: env-info
env-info:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		conda info

# -----------------------------------------------------------------------------
# run
# -----------------------------------------------------------------------------

.PHONY: gemma
gemma:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		hf download google/gemma-3-12b-it --local-dir "$(ROOT)/models/gemma"

.PHONY: models
models:
	@wget --timestamping --continue \
		--output-document=$(ROOT)/models/ltx-2-spatial-upscaler-x2-1.0.safetensors \
		'https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-spatial-upscaler-x2-1.0.safetensors?download=true'
	@wget --timestamping --continue \
		--output-document=$(ROOT)/models/ltx-2-19b-distilled-lora-384.safetensors \
		'https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-19b-distilled-lora-384.safetensors?download=true'
	@wget --timestamping --continue \
		--output-document=$(ROOT)/models/ltx-2-19b-distilled.safetensors \
		'https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-19b-distilled.safetensors?download=true'

.PHONY: example
example:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		python -m ltx_pipelines.ti2vid_two_stages \
			--checkpoint-path "${ROOT}/models/ltx-2-19b-distilled.safetensors" \
			--distilled-lora "${ROOT}/models/ltx-2-19b-distilled-lora-384.safetensors" \
			--spatial-upsampler-path "${ROOT}/models/ltx-2-spatial-upscaler-x2-1.0.safetensors" \
			--gemma-root "$(ROOT)/models/gemma" \
			--prompt "A beautiful sunset over the ocean" \
			--output-path output.mp4

# -----------------------------------------------------------------------------
# rsync
# -----------------------------------------------------------------------------

.PHONY: rsync-push
rsync-push:
	@rsync -avz \
		--exclude='/.git' \
		--exclude='/.idea' \
		--exclude='/cache/*' \
		--exclude='/target/*' \
		--exclude='/models/*' \
		--exclude='*.log' \
		--exclude='.ipynb_checkpoints' \
		'$(ROOT)/' \
		'$(REMOTE_HOST):$(REMOTE_PATH)'

.PHONY: rsync-pull
rsync-pull:
	@rsync -avz \
		--exclude='/.git' \
		--exclude='/.idea' \
		--exclude='/cache/*' \
		--exclude='/target/*' \
		--exclude='/models/*' \
		--exclude='*.log' \
		--exclude='.ipynb_checkpoints' \
		'$(REMOTE_HOST):$(REMOTE_PATH)' \
		'$(ROOT)/'

# -----------------------------------------------------------------------------
# browsing
# -----------------------------------------------------------------------------

.PHONY: browse
browse:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		python3 -m http.server --bind "0.0.0.0" "18181"

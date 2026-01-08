# LTX-2 bootstrap

allows to run LTX-2 from command line on Linux

- https://huggingface.co/Lightricks/LTX-2

- https://ltx.io/model/model-blog/prompting-guide-for-ltx-2

- https://blog.comfy.org/p/ltx-2-open-source-audio-video-ai

- https://github.com/Lightricks/LTX-2/blob/main/packages/ltx-pipelines/README.md
- https://github.com/Lightricks/ComfyUI-LTXVideo?tab=readme-ov-file#required-models

## checkout

```shell
git clone --recurse-submodules -j8 git://github.com/mazurkin/ltx2.git
```

## conda

https://docs.anaconda.com/miniconda/#miniconda-latest-installer-links

Download the [latest Miniconda version](https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh)

## installation

my GPU is NVIDIA A100 80GB (Ampere)

refer to [Makefile](Makefile) for the details of the operations

```shell
# make an isolated Conda environment with Python 3.12
$ make env-init-conda

# then install LTX-2 packages
$ make env-init-ltx2

# clone Gemma repository (you must get HF_TOKEN and you must agree to the Gemma's license on HF)
# visit https://huggingface.co/google/gemma-3-12b-it
$ HF_TOKEN=hf_xxxyyyzzz make gemma

# download all the LTX-2 models from HF
$ make models
```

## run

```shell`
# run the generator
$ PROMPT="A beautiful sunset over the ocean with light breeze" CUDA_VISIBLE_DEVICES=0 make render
```

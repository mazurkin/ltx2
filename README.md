# LTX-2 bootstrap

allows to run LTX-2 from command line on Linux

- https://huggingface.co/Lightricks/LTX-2
- https://github.com/Lightricks/LTX-2/blob/main/packages/ltx-pipelines/README.md
- https://github.com/Lightricks/ComfyUI-LTXVideo?tab=readme-ov-file#required-models

# checkout

```shell
git clone --recurse-submodules -j8 git://github.com/mazurkin/ltx2.git
```

# installation

my GPU is NVIDIA A100 80GB (Ampere)

refer to [Makefile](Makefile) for the details

```shell
# make an isolated Conda environment with Python
$ make env-init-conda

# then install LTX-2
$ make env-init-ltx2

# clone Gemma repository (you must get HF_TOKEN and you must agree to the Gemma's license on HF)
# visit https://huggingface.co/google/gemma-3-12b-it
$ HF_TOKEN=hf_xxxyyyzzz make gemma

# download the LTX-2 models from HF
$ make models
```

# run

```shell`
# run the generator
$ PROMPT="A beautiful sunset over the ocean with light breeze" CUDA_VISIBLE_DEVICES=0 make render
```

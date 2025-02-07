# Ollama Model Pack

Builds dm-verity EROFS images of ollama models.

## Pack image

```bash
docker run --rm -v $(pwd)/output:/output -e MODEL=llama3.3:70b ghcr.io/tinfoilanalytics/modelpack
```

`modelpack` emits two files in the output directory, where MODEL is the the name of the model (replacing the colon with a dash):
- `MODEL.mpk`: dm-verity EROFS image
- `MODEL.info`: metadata file in the format `SHA256_HASH-OFFSET`

## Mount image

```bash
veritysetup open /dev/sdc model_verity /dev/sdc \
    $(cut -d '-' -f 1 llama3.3-70b.info) \
    --hash-offset=$(cut -d '-' -f 2 llama3.3-70b.info)
mount -o ro /dev/mapper/model_verity /mnt
```

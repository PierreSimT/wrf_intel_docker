# Centos 7 - Intel Compiled WRF

Repository for Intel Compiled WRF Dockerfiles.

## Deployment

```
docker build -t <CENTOS_INTEL_IMAGE_NAME> ./centos-intel/Dockerfile
docker build -t <WRF_IMAGE_NAME> .

docker run -it --shm-size=4gb <WRF_IMAGE_NAME>
```
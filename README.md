# Docker-pykickstart

## introduction

Pykickstart is a project that can check kickstart files on syntax errors. More information can be found [here](https://github.com/pykickstart/pykickstart)

## How to use this

You can use this Container image in many ways. For example, it can be run to check your kickstart file on your local file system. You have to mount the directory containing the kickstart file in this container and simply run it by the absolute path.


### Docker example:
```bash
$ docker run --rm -it -v `pwd`:/app docker.io/michaeltrip/pykickstart /app/kickstart.ks
```

### Podman example:
```bash
$ podman run --rm -it -v `pwd`:/app docker.io/michaeltrip/pykickstart /app/kickstart.ks
```

### Gitlab CI example

```yaml

stages:
  - verify

lint_kickstart_file:
  stage: verify
  image: docker.io/michaeltrip/pykickstart
  script:
    - ksvalidator --version=RHEL8 $CI_PROJECT_DIR/kickstart/kickstart.ks

```


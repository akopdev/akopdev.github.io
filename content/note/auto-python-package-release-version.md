---
title: "Automatic release name based on package version number"
tags: ["python", "DevOps", "dockerfile"]
---

You can automate release creation by adding this snippet to pipeline.

It will create a new release (git tag) based on current package version.

```bash
git tag -a v$(python setup.py --version) -m 'description of version'
```

## Labeling docker images

You can also use the same approach to label docker images with current package version.

```bash
docker build -t myimage:latest -t myimage:$(python setup.py --version) .
```

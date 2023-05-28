---
title: "Don’t use alpine as a base image for python apps"
date: 2023-05-21T23:06:36+02:00
tags: ["docker", "python"]
---

## Main reasons

### 1. Not supporting DNS-over-TCP

`Musl` (an implementation of C standard library) doesn't support DNS-over-TCP. 
As a result it may suddenly starts throwing "Unknown Host" exceptions randomly, 
anytime when some external network change causes the resolution of some particular 
domain to require more than the 512 bytes available in a single UDP packet.

This DNS issue does not manifest in Docker container. It can only happen in Kubernetes,
so if you test locally, everything will work fine, and you will only find out about 
unfixable issues when you deploy the application to a cluster.

### 2. Bad compatibility with popular packages

For Python, for example, many popular libraries such as NumPy, or Cryptography rely on C
code for optimizations. Even if you manage to build an image its size will be ~400MB, 
at which point using Alpine for its small size doesn't really help much. 

Also, the build time for such an image will be atrocious, running up to 10 minutes. 

Similar issues can also happen in other languages. For example, Node.js uses add-ons, 
which are written in C++ and compiled with node-gyp, these will depend on C libraries and,
therefore, on glibc. 

## What to use instead alpine?

The biggest appeal of Alpine is its small size, so if you really care about that, then 
`Wolfi`[^1] (is just 12MB) or `Distroless`[^2] are good choices.

If you’re looking for a general-purpose base image with a reasonable size that’s not based 
on musl, then you might consider using `UBI`[^3] (Universal Base Image) made by Red Hat, which has
only 26.7MB in its "micro" version, which is also fairly close to Alpine.

[^1]: https://cgr.dev/chainguard/wolfi-base
[^2]: https://github.com/GoogleContainerTools/distroless
[^3]: https://registry.access.redhat.com/ubi8-micro

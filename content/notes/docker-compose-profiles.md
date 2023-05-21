---
title: "Using profiles with Compose"
tags: ["docker", "compose"]
date: 2023-05-22T00:59:53+02:00
---
Profiles allow adjusting the Compose application model for various usages and environments
by selectively enabling services. It means that define additional services in a single 
`docker-compose.yml` file that should only be started in specific scenarios, e.g. for debugging or development tasks.

## Assigning profiles to services

Services are associated with profiles through the profiles attribute which takes an array of profile names:

```yaml
version: "3.9"
services: 
	frontend: 
		image: frontend 
		profiles: ["frontend"] 
	phpmyadmin: 
		image: phpmyadmin 
		depends_on: 
			- db 
		profiles: 
			- debug 
	backend: 
		image: backend 
	db: 
		image: mysql
```

Here the services `frontend` and `phpmyadmin` are assigned to the profiles `frontend` and `debug` 
respectively and as such are only started when their respective profiles are enabled.

Services without a profiles attribute will always be enabled, i.e. in this case running `docker compose up`
would only start `backend` and `db`.

The core services of your application should not be assigned profiles so they will always be enabled and 
automatically started.

## Enabling profiles

To enable a profile supply the `--profile` command-line option or use the COMPOSE_PROFILES environment variable:

```sh
$ docker compose --profile debug up
$ COMPOSE_PROFILES=debug docker compose up
```

The above command would both start your application with the debug profile enabled. Using the docker-compose.yml file above, this would start the services backend, db and phpmyadmin.

Multiple profiles can be specified by passing multiple --profile flags or a comma-separated list for the COMPOSE_PROFILES environment variable:

```sh 
$ docker compose --profile frontend --profile debug up
$ COMPOSE_PROFILES=frontend,debug docker compose up
```

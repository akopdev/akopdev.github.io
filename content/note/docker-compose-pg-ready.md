---
title: "How to know when postgres database is ready"
tags: ["database", "compose"]
---
Postgres provides an easy-to-use command called `pg_isready` to know exactly when to accept connections. Useful for orchestrating container dependencies, without maintaining custom scripts.
```yaml 
database:
    image: postgres:14.3-alpine
    environment:
      - POSTGRES_USER=test
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=example
    ports:
      - '5432:5432'
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U test -d example']
      interval: 5s
      timeout: 5s
      retries: 5
```

Bash script that can be used as a part of CI/CD pipeline job.

```bash
#!/bin/sh
pg_uri="postgres://postgres:password@localhost:5432/example"
until pg_isready -h postgres-host -p 5432 -U postgres
do
  echo "Waiting for postgres at: $pg_uri"
  sleep 2;
done
# Now able to connect to postgres
```


Dockerfile

```
FROM node:14

WORKDIR /usr/src/app

COPY exoplanets/package*.json ./

RUN npm install

COPY exoplanets/. .

EXPOSE 3000

CMD ["node", "app.js"]
```

docker-compose.yaml
```
services:
  app:
    build: .
    ports:
      - "8080:3000"
    depends_on:
      postgres_db:
        condition: service_healthy

  postgres_db:
    image: postgres:17
    environment:
      POSTGRES_DB: exoplanetdb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./initdb:/docker-entrypoint-initdb.d
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 30s
      timeout: 30s
      retries: 3

volumes:
  postgres_data:
```
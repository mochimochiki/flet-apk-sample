# flet-apk-sample

Build Flet apps into Android APKs with Docker.

## How to use

### Build the Docker Image

```bash
docker build -t flet-apk:latest .
```

### Run the Docker Container

```bash
docker run -t -v $(pwd)/app:/app flet-apk
```
# Laravel Reverb Action

A Docker image providing Laravel Reverb as a service container for GitHub Actions CI/CD workflows.

## Usage

Use the Docker image as a service container in your GitHub Actions workflow:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest

    services:
      reverb:
        image: ghcr.io/artisan-build/reverb-action:latest
        ports:
          - 8080:8080
        env:
          REVERB_APP_ID: my-app-id
          REVERB_APP_KEY: my-app-key
          REVERB_APP_SECRET: my-app-secret

    steps:
      - uses: actions/checkout@v5

      - name: Wait for Reverb
        run: |
          for i in {1..30}; do
            if nc -z localhost 8080; then
              echo "Reverb is ready"
              exit 0
            fi
            echo "Waiting for Reverb... ($i/30)"
            sleep 1
          done
          echo "Reverb failed to start"
          exit 1

      - name: Run tests
        env:
          REVERB_HOST: 127.0.0.1
          REVERB_PORT: 8080
        run: vendor/bin/pest
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `REVERB_APP_ID` | `app-id` | Application ID |
| `REVERB_APP_KEY` | `app-key` | Application key |
| `REVERB_APP_SECRET` | `app-secret` | Application secret |
| `REVERB_HOST` | `0.0.0.0` | Host to bind to |
| `REVERB_PORT` | `8080` | Port to listen on |
| `REVERB_SCHEME` | `http` | URL scheme (http/https) |

## Why Reverb instead of Soketi?

- **Official Laravel package** - First-party support and maintained by the Laravel team
- **Modern PHP** - Built on PHP 8.5, uses native fibers for async
- **Same protocol** - Pusher-compatible, works with existing clients
- **No Node.js dependency** - Pure PHP, no Node version compatibility issues

## Local Development

Build the image locally:

```bash
docker build -t reverb-action .
```

Run it:

```bash
docker run -p 8080:8080 \
  -e REVERB_APP_ID=my-app \
  -e REVERB_APP_KEY=my-key \
  -e REVERB_APP_SECRET=my-secret \
  reverb-action
```

## License

MIT

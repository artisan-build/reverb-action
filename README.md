# Laravel Reverb Action

Run Laravel Reverb WebSocket server in GitHub Actions for testing.

## Usage

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5

      - uses: artisan-build/reverb-action@v1
        id: reverb
        with:
          app-id: my-app-id
          app-key: my-app-key
          app-secret: my-app-secret

      - name: Run tests
        env:
          REVERB_HOST: ${{ steps.reverb.outputs.host }}
          REVERB_PORT: ${{ steps.reverb.outputs.port }}
        run: vendor/bin/pest
```

The action:
- Pulls and starts the Reverb container
- Waits for it to be ready (with configurable timeout)
- Outputs connection details
- Cleans up after the job

## Inputs

| Input | Default | Description |
|-------|---------|-------------|
| `app-id` | `app-id` | Reverb application ID |
| `app-key` | `app-key` | Reverb application key |
| `app-secret` | `app-secret` | Reverb application secret |
| `port` | `8080` | Port to expose Reverb on |
| `timeout` | `30` | Seconds to wait for Reverb to be ready |

## Outputs

| Output | Description |
|--------|-------------|
| `host` | Host where Reverb is running (`127.0.0.1`) |
| `port` | Port where Reverb is running |
| `container-id` | Docker container ID |

## Why Reverb instead of Soketi?

- **Official Laravel package** - First-party support from the Laravel team
- **Modern PHP** - Built on PHP 8.5 with native fibers
- **Pusher-compatible** - Works with existing clients
- **No Node.js dependency** - Pure PHP

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

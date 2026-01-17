#!/bin/sh
set -e

# Generate app key if not set
if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

# Clear cached config to ensure runtime env vars are used
php artisan config:clear 2>/dev/null || true

# Execute the main command
exec "$@"

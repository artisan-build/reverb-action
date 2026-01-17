#!/bin/sh
set -e

# Clear cached config to ensure runtime env vars are used
php artisan config:clear 2>/dev/null || true

# Execute the main command
exec "$@"

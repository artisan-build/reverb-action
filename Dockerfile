FROM php:8.4-cli-alpine

LABEL org.opencontainers.image.source="https://github.com/artisan-build/reverb-action"
LABEL org.opencontainers.image.description="Laravel Reverb WebSocket server for CI/CD"
LABEL org.opencontainers.image.licenses="MIT"

# Install system dependencies
RUN apk add --no-cache \
    git \
    unzip \
    libzip-dev \
    linux-headers \
    $PHPIZE_DEPS

# Install PHP extensions
RUN docker-php-ext-install pcntl zip sockets

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Create minimal Laravel app with Reverb
RUN composer create-project laravel/laravel . --prefer-dist --no-interaction \
    && composer require laravel/reverb --no-interaction \
    && php artisan reverb:install --no-interaction

# Copy custom configuration (overwrite the published one)
COPY config/reverb.php /app/config/reverb.php
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default environment variables
ENV REVERB_APP_ID=app-id \
    REVERB_APP_KEY=app-key \
    REVERB_APP_SECRET=app-secret \
    REVERB_HOST=0.0.0.0 \
    REVERB_PORT=8080 \
    REVERB_SCHEME=http

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php", "artisan", "reverb:start", "--host=0.0.0.0", "--port=8080"]

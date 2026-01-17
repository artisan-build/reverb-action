FROM php:8.5-cli-alpine

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

# Create Laravel app with Reverb
RUN composer create-project laravel/laravel . --prefer-dist --no-interaction \
    && composer require laravel/reverb --no-interaction \
    && php artisan key:generate

# Copy configuration files
COPY config/broadcasting.php /app/config/broadcasting.php
COPY config/reverb.php /app/config/reverb.php
COPY routes/channels.php /app/routes/channels.php
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default environment variables
ENV REVERB_APP_ID=app-id \
    REVERB_APP_KEY=app-key \
    REVERB_APP_SECRET=app-secret \
    REVERB_SERVER_HOST=0.0.0.0 \
    REVERB_SERVER_PORT=8080 \
    REVERB_HOST=127.0.0.1 \
    REVERB_PORT=8080 \
    REVERB_SCHEME=http

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php", "artisan", "reverb:start", "--host=0.0.0.0", "--port=8080"]

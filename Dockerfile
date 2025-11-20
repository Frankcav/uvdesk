# Stage 1: Build PHP environment with UVDesk
FROM php:8.2-fpm AS app

# Install necessary PHP extensions and tools
RUN apt-get update && apt-get install -y \
    libicu-dev zip unzip git curl libzip-dev libxml2-dev libpng-dev locales \
 && docker-php-ext-install intl pdo_mysql zip opcache \
 && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/uvdesk

# Copy application files
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction \
 && php bin/console cache:clear --env=prod --no-debug \
 && chown -R www-data:www-data var public

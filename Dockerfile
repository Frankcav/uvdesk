FROM php:8.2-apache

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    libicu-dev git unzip libzip-dev \
 && docker-php-ext-install intl pdo_mysql opcache \
 && a2enmod rewrite \
 && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy project files
WORKDIR /var/www/html
COPY . .

# Install dependencies & optimize
RUN composer install --no-dev --optimize-autoloader --no-interaction \
 && chown -R www-data:www-data var public \
 && php bin/console cache:clear --env=prod --no-debug

# Expose Apache
EXPOSE 80
CMD ["apache2-foreground"]

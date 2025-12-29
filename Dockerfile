FROM composer:2 AS vendor

WORKDIR /app
COPY composer.json composer.lock ./

# Install dependencies
RUN composer install \
  --no-interaction \
  --no-plugins \
  --no-scripts \
  --no-dev \
  --prefer-dist \
  --ignore-platform-reqs

FROM serversideup/php:8.2-fpm-nginx

# Switch to root to copy files and set permissions if needed
# (serversideup image runs as root by default but drops privs for php-fpm)
# However, standard practice with this image is copying to /var/www/html

WORKDIR /var/www/html

# Copy dependencies
COPY --from=vendor /app/vendor/ /var/www/html/vendor/

# Copy project files
COPY . .

# Set permissions (serversideup/php runs as www-data)
RUN chown -R www-data:www-data /var/www/html

# Post-autoload dump to ensure class map is updated
# RUN composer dump-autoload (skipped as we copied vendor, but good practice if needed)

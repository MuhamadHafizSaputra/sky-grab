#!/bin/bash
set -e

# Copy .env if it doesn't exist
if [ ! -f .env ]; then
    cp .env.example .env
    echo ">> .env file created from .env.example"
fi

# Generate app key if not set
if grep -qP "^APP_KEY=\r?$" .env; then
    php artisan key:generate --no-interaction
    echo ">> Application key generated"
fi

# Wait for database to be ready (extra safety beyond healthcheck)
echo ">> Waiting for database connection..."
max_tries=30
counter=0
until php artisan db:monitor --databases=mysql > /dev/null 2>&1 || [ $counter -eq $max_tries ]; do
    sleep 2
    counter=$((counter + 1))
    echo ">> Attempt $counter/$max_tries..."
done

# Run migrations
php artisan migrate --force --no-interaction
echo ">> Migrations completed"

# Clear and cache config
php artisan config:clear
php artisan cache:clear
php artisan view:clear

# Set permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Create storage symlink
php artisan storage:link --force 2>/dev/null || true

echo ">> Sky-Grab is ready!"

# Start Apache
exec apache2-foreground

#!/bin/bash
set -e

echo ">> Running startup tasks..."

# Run database migrations
php artisan migrate --force --no-interaction
echo ">> Migrations completed"

# Cache configuration for performance
php artisan config:cache
echo ">> Config cached"

php artisan route:cache
echo ">> Routes cached"

php artisan view:cache
echo ">> Views cached"

echo ">> Startup tasks completed! Starting Apache..."

# Start Apache
exec apache2-foreground

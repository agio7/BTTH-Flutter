#!/bin/bash

# Chờ MySQL sẵn sàng
echo "Waiting for MySQL to be ready..."
while ! mysqladmin ping -h"mysql" -u"laravel_user" -p"laravel_password" --silent; do
    sleep 1
done

echo "MySQL is ready!"

# Chạy migrations
echo "Running migrations..."
php artisan migrate --force

# Chạy seeders (nếu có)
echo "Running seeders..."
php artisan db:seed --force

# Khởi động Apache
echo "Starting Apache..."
apache2-foreground



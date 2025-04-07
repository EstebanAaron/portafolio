FROM php:8.3-fpm

# ===== 1. Instalar dependencias =====
RUN apt-get update && apt-get install -y \
    # Dependencias para PHP
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libwebp-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    libxml2-dev \
    libicu-dev \
    zlib1g-dev \
    libonig-dev \
    libpq-dev \ 
    #dependencia para pdo_pgsql
    # Nginx y herramientas
    nginx \
    curl \
    gettext-base \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ===== 2. Instalar extensiones PHP =====
RUN apt-get update && docker-php-ext-install -j$(nproc) pdo_pgsql gd pdo_mysql mbstring exif pcntl bcmath zip intl xml opcache

# ===== 3. Configurar Nginx =====
COPY docker/nginx/default.conf.template /etc/nginx/templates/default.conf.template
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# ===== 4. Instalar Composer =====
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# ===== 5. Configurar Laravel =====
WORKDIR /var/www/laravel-app
COPY ./laravel-app .

# Instalar dependencias (optimizado para caché de Docker)
RUN composer install --no-dev --no-scripts --no-autoloader \
    && composer dump-autoload --optimize \
    && composer run-script post-autoload-dump

# ===== 6. Permisos =====
RUN chown -R www-data:www-data /var/www/laravel-app/storage \
    /var/www/laravel-app/bootstrap/cache

# ===== 7. Puerto y comando de inicio =====
CMD ["sh", "-c", "php-fpm -D && envsubst '$PORT' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx"]
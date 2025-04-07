# Usamos imagen base de PHP 8.3 con FPM
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
    # Nginx y herramientas
    nginx \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ===== 2. Instalar extensiones PHP =====
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
    gd \
    pdo \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    zip \
    intl \
    xml \
    opcache

# ===== 3. Configurar Nginx =====
RUN rm /etc/nginx/sites-enabled/default
COPY docker/nginx/default.conf /etc/nginx/sites-available/laravel
RUN ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/ \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

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
EXPOSE 8000
CMD ["sh", "-c", "php-fpm -D && nginx"]
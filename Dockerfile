# Usamos imagen base de PHP 8.3 con FPM
FROM php:8.3-fpm

# ===== INSTALACIÓN DE DEPENDENCIAS =====
RUN apt-get update && apt-get install -y \
    # Dependencias para extensiones PHP
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
    # Herramientas útiles
    curl \
    # Instalar Nginx
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ===== EXTENSIONES PHP =====
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

# ===== COMPOSER =====
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# ===== CONFIGURACIÓN DE LARAVEL =====
WORKDIR /var/www/laravel-app

# Copia solo los archivos necesarios para composer install primero (optimización de caché)
COPY ./laravel-app/composer.json ./laravel-app/composer.lock ./laravel-app/

# Instala dependencias (sin scripts para evitar problemas)
RUN composer install --no-dev --no-scripts --no-autoloader --optimize-autoloader

# Copia el resto de la aplicación
COPY ./laravel-app ./

# Completa la instalación
RUN composer dump-autoload --optimize \
    && composer run-script post-autoload-dump

# ===== PERMISOS =====
RUN chown -R www-data:www-data /var/www/laravel-app/storage \
    /var/www/laravel-app/bootstrap/cache

# ===== CONFIGURACIÓN PARA RENDER =====
# Render usa puerto dinámico, lo pasaremos via CMD
EXPOSE 8000

# Copiar archivo de configuración de Nginx
COPY ./nginx.conf /etc/nginx/sites-available/default

# Script de inicio personalizado
COPY ./docker/start.sh /usr/local/bin/start
RUN chmod +x /usr/local/bin/start

# Comando para iniciar el script de inicio
CMD ["start"]

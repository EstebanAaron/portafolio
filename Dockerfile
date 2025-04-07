# Usa una imagen base de PHP con FPM
FROM php:8.3-fpm

# Instala dependencias del sistema y limpia caché
RUN apt-get update && apt-get install -y \
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configura e instala extensiones de PHP con optimización
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
    opcache \
    && docker-php-source delete

# Instala Composer desde la imagen oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configura el directorio de trabajo
WORKDIR /var/www/laravel-app

# Copia solo los archivos necesarios para composer install primero
COPY ./laravel-app/composer.json ./laravel-app/composer.lock ./ 

# Instala dependencias de Composer (sin scripts para evitar problemas)
RUN composer install --no-dev --no-scripts --no-autoloader --optimize-autoloader

# Copia el resto de los archivos del proyecto
COPY ./laravel-app . 

# Completa la instalación de Composer
RUN composer dump-autoload --optimize \
    && composer run-script post-autoload-dump

# Establece permisos adecuados para Laravel
RUN chown -R www-data:www-data /var/www/laravel-app/storage \
    /var/www/laravel-app/bootstrap/cache

# Exponer el puerto 80 para HTTP (Cambiar de 9000 a 80)
EXPOSE 80

# Comando de inicio
CMD ["php-fpm", "-F"]

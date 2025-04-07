# Usa una imagen base de PHP
FROM php:8.3-fpm

# Instala dependencias necesarias del sistema
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    libxml2-dev \
    libicu-dev \
    libzip-dev \
    zlib1g-dev \
    && apt-get clean

# Instala las extensiones de PHP necesarias (gd, pdo, pdo_mysql, mbstring, exif, pcntl, bcmath, zip)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mbstring exif pcntl bcmath zip

# Instala Composer desde la imagen oficial de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configura el directorio de trabajo a la carpeta laravel-app
WORKDIR /var/www/laravel-app

# Copia los archivos del proyecto (la carpeta laravel-app) al contenedor
COPY ./laravel-app /var/www/laravel-app

# Instala las dependencias de Composer
RUN composer install --no-dev --optimize-autoloader

# Expone el puerto 9000 para PHP-FPM
EXPOSE 9000

# Inicia PHP-FPM
CMD ["php-fpm"]

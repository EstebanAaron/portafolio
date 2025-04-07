FROM php:8.3-cli  # Cambia a imagen CLI (no FPM)

# Instala dependencias (igual que antes)
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev zip unzip git libxml2-dev libicu-dev libzip-dev zlib1g-dev libonig-dev \
    && apt-get clean

# Instala extensiones PHP (igual que antes)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mbstring exif pcntl bcmath zip intl

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia la aplicación
WORKDIR /var/www/laravel-app
COPY . .

# Instala dependencias
RUN composer install --optimize-autoloader --no-dev

# Usa el servidor web integrado de PHP en el puerto dinámico de Render
CMD ["php", "-S", "0.0.0.0:${PORT}", "-t", "public"]
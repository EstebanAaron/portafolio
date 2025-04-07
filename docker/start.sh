#!/bin/bash

# Configura el puerto dinámico para Render
export PORT=${PORT:-8000}

# Inicia PHP-FPM en segundo plano
php-fpm -D

# Inicia Nginx en primer plano
nginx -g "daemon off;"
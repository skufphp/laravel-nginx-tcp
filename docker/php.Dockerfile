FROM php:8.5-fpm-alpine

# Установка необходимых пакетов и PHP-расширений для PostgreSQL и Laravel
RUN apk add --no-cache \
    curl \
    $PHPIZE_DEPS \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    oniguruma-dev \
    libzip-dev \
    linux-headers \
    fcgi \
    postgresql-dev \
    icu-dev \
    && pecl channel-update pecl.php.net \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install \
    pdo \
    pdo_pgsql \
    pgsql \
    mbstring \
    xml \
    gd \
    bcmath \
    zip \
    intl \
    opcache \
    && apk del $PHPIZE_DEPS

# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Устанавливаем рабочую директорию
WORKDIR /var/www/laravel

# Открываем порт FPM по TCP (только внутри сети Docker)
EXPOSE 9000

CMD ["php-fpm", "-F"]
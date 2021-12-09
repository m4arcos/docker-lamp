ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-apache

# docker network create -d nat --subnet=192.168.1.0/24 --gateway=192.168.1.254 app_net

RUN apt-get update -y && apt-get upgrade -y; \
        docker-php-ext-install pdo pdo_mysql mysqli; \
        rm /etc/apt/preferences.d/no-debian-php

RUN a2enmod rewrite; \
        a2enmod ssl;

RUN DEBIAN_FRONTEND='noninteractive' apt-get update -y && apt-get upgrade -y && apt-get install wget -y --fix-missing --no-install-recommends \
        openssh-client \
        git \
        libzip-dev \
        zip \
        unzip \
        gcc \
        vim \
        curl \
        build-essential \
        libxml2-dev \
        libcurl4-openssl-dev \
        pkg-config \
        libssl-dev \
        npm \
        && docker-php-ext-install -j$(nproc) pdo_mysql gettext soap \
        && docker-php-ext-configure zip \
        && docker-php-ext-install zip

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash; \
        apt-get install nodejs; \
        node -v; \
        npm -v; 

RUN pecl uninstall xdebug; \
        pecl install xdebug-beta;

# Instala o Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
        php composer-setup.php --install-dir=. --filename=composer; \
        mv composer /usr/local/bin/
ENV PATH="~/.composer/vendor/bin:${PATH}"

# Instala PHPCS
RUN composer global require "squizlabs/php_codesniffer=*"

# We enable the errors only in development
ENV DISPLAY_ERRORS="On"

# Adiciona aliases de comandos para o bash
RUN echo 'alias ll="ls -lhaGF"' >> ~/.bashrc
RUN echo 'SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1' >> /etc/apache2/apache2.conf

WORKDIR /var/www/html

EXPOSE 80
EXPOSE 8000
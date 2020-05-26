FROM php:7.4-apache

# docker network create -d nat --subnet=192.168.1.0/24 --gateway=192.168.1.254 app_net

RUN apt-get update -y && apt-get upgrade -y

RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN rm /etc/apt/preferences.d/no-debian-php

RUN a2enmod rewrite
RUN a2enmod ssl

RUN DEBIAN_FRONTEND='noninteractive' apt-get update -y && apt-get upgrade -y && apt-get install wget -y --fix-missing --no-install-recommends \
        net-tools \
        iputils-ping \
        openssh-client \
        git \
        default-mysql-client \
        libzip-dev \
        zip \
        gcc \
        vim \
        curl \
        unzip \
        build-essential \
        libxml2-dev \
        libcurl4-openssl-dev \
        pkg-config \
        libssl-dev \
        npm \
        && docker-php-ext-install -j$(nproc) pdo_mysql gettext soap \
        && docker-php-ext-configure zip \
        && docker-php-ext-install zip

RUN npm install npm@latest -g
# RUN npm install --global cross-env

RUN pecl uninstall xdebug
RUN pecl install xdebug-beta

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=. --filename=composer
RUN mv composer /usr/local/bin/

# RUN composer global require laravel/installer

# Adiciona aliases de comandos para o bash
RUN echo 'alias ll="ls -lhaGF"' >> ~/.bashrc
RUN echo 'SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1' >> /etc/apache2/apache2.conf

WORKDIR /var/www/html

EXPOSE 80
EXPOSE 8000
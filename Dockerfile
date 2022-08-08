FROM php:7.2-apache
COPY . /var/www/html/
WORKDIR /var/www/html

RUN apt-get update \
  && apt-get -y install --no-install-recommends apt-utils zip unzip nano ncdu 2>&1 \
    && apt-get -y install --no-install-recommends python graphviz 2>&1 \
  && apt-get -y install git iproute2 procps lsb-release \
  && apt-get install -y -qq software-properties-common \
  && apt-get install -y -qq wget git lynx ack-grep \
  && yes | pecl install xdebug \
  && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && apt-get -y install libicu-dev \
    && docker-php-ext-install intl pdo_mysql opcache \
    && pecl install apcu && docker-php-ext-enable apcu \
    && echo "apc.enable_cli=1" > /usr/local/etc/php/php.ini \
    && echo "apc.enable=1" > /usr/local/etc/php/php.ini \
  && echo "post_max_size = 100M" > /usr/local/etc/php/php.ini \
    && a2enmod rewrite \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install gnupg2 -y

RUN rm -rf /etc/apache2/sites-enabled \
    && ln -s /var/www/html/.devcontainer/sites-enabled /etc/apache2/sites-enabled

RUN echo 'alias ll="ls -la --color=auto"' >> ~/.bashrc && \
    echo "alias ack='ack-grep'" >> ~/.bashrc

RUN chown www-data:www-data -R .

ENV DEBIAN_FRONTEND=dialog
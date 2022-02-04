FROM php:7.4-cli-buster

ARG COMPOSER_FLAGS="--prefer-dist --no-interaction"
ARG DEBIAN_FRONTEND=noninteractive
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_PROCESS_TIMEOUT 3600

WORKDIR /code/

COPY docker/php-prod.ini /usr/local/etc/php/php.ini
COPY docker/composer-install.sh /tmp/composer-install.sh

# Xdebug
#RUN pecl install xdebug \
#  && docker-php-ext-enable xdebug
#COPY docker/xdebug/xdebug.ini.dist /usr/local/etc/php/conf.d/xdebug.ini

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    locales \
    unzip \
    ssh \
    apt-transport-https \
    wget \
    libxml2-dev \
    gnupg2 \
    unixodbc-dev \
    libgss3

RUN curl -sS ftp://ftp.freetds.org/pub/freetds/stable/freetds-patched.tar.gz > freetds-patched.tar.gz
RUN tar xzvf freetds-patched.tar.gz
RUN mkdir /tmp/freetds && mv freetds-*/* /tmp/freetds/

RUN cd /tmp/freetds && \
    ./configure --enable-msdblib --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
      docker-php-ext-install pdo_dblib && \
      sed -i '$ d' /etc/apt/sources.list

# MSSQL
ADD mssql/freetds.conf /etc/freetds.conf

RUN echo "memory_limit = -1" >> /usr/local/etc/php/php.ini


RUN rm -r /var/lib/apt/lists/* \
    && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && chmod +x /tmp/composer-install.sh \
    && /tmp/composer-install.sh

RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl

ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# PDO mssql
RUN pecl install pdo_sqlsrv sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv \
    && docker-php-ext-install xml

# Set path
ENV PATH $PATH:/opt/mssql-tools/bin

# Fix SSL configuration to be compatible with older servers
RUN \
    # https://wiki.debian.org/ContinuousIntegration/TriagingTips/openssl-1.1.1
    sed -i 's/CipherString\s*=.*/CipherString = DEFAULT@SECLEVEL=1/g' /etc/ssl/openssl.cnf \
    # https://stackoverflow.com/questions/53058362/openssl-v1-1-1-ssl-choose-client-version-unsupported-protocol
    && sed -i 's/MinProtocol\s*=.*/MinProtocol = TLSv1/g' /etc/ssl/openssl.cnf

## Composer - deps always cached unless changed
# First copy only composer files
COPY composer.* /code/

# Download dependencies, but don't run scripts or init autoloaders as the app is missing
RUN composer install $COMPOSER_FLAGS --no-scripts --no-autoloader

# Copy rest of the app
COPY . /code/

# Run normal composer - all deps are cached already
RUN composer install $COMPOSER_FLAGS

CMD php ./src/run.php

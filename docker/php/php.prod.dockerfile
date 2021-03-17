FROM php:7.4.12-fpm-alpine

# Copy php-fpm config.
ADD ./config/fpm-www.conf /usr/local/etc/php-fpm.d/www.conf

# Copy PHP ini changes.
ADD ./config/ini-changes.ini /usr/local/etc/php/conf.d/ini-changes.ini

# Create web user/group.
RUN addgroup -g 1000 web && adduser -G web -g web -s /bin/sh -D web

# Get install-php-extensions binary.
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# Install OS dependencies.
RUN apk update && apk add bash nano gnupg libzip-dev zip libpng libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev gd

# Install WkHtmlToPdf.
RUN apk add wkhtmltopdf xvfb
RUN apk add fontconfig freetype ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family

# Install SOAP PHP extension.
RUN apk add --no-cache libxml2-dev php-soap ${PHPIZE_DEPS} \
    && docker-php-ext-install soap  

# Install REDIS PHP extension.
RUN apk --no-cache add pcre-dev ${PHPIZE_DEPS} \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del pcre-dev ${PHPIZE_DEPS}

# Install others PHP extensions.
RUN docker-php-ext-install pdo bcmath zip pcntl gd

# Download and install sqlsrv and pdo_sqlsrv drivers.
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.7.2.1-1_amd64.apk
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.7.1.1-1_amd64.apk
RUN apk add --allow-untrusted msodbcsql17_17.7.2.1-1_amd64.apk
RUN apk add --allow-untrusted mssql-tools_17.7.1.1-1_amd64.apk
RUN ln -sfnv /opt/mssql-tools/bin/* /usr/bin
RUN install-php-extensions sqlsrv pdo_sqlsrv 

# Change path owner.
RUN chown -R web:web /var/www/html

# Set container timezone
ARG TZ='America/Sao_Paulo'
ENV DEFAULT_TZ ${TZ}
RUN apk upgrade --update \
    && apk add -U tzdata \
    && cp /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime \
    && apk del tzdata \
    && rm -rf \
    /var/cache/apk/*
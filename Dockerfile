FROM php:8-apache

# Install extensions
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql pdo_pgsql pgsql \
    && rm -rf /var/lib/apt/lists/*

# Prepare files and folders
RUN mkdir -p /speedtest/

# Copy sources
COPY backend/ /speedtest/backend

COPY results/*.php /speedtest/results/
COPY results/*.ttf /speedtest/results/

COPY *.js /speedtest/
COPY favicon.ico /speedtest/

COPY docker/servers.json /servers.json

COPY docker/*.php /speedtest/
COPY docker/entrypoint.sh /

# Install SSL certificate (self-signed)
RUN openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout /etc/ssl/private/apache-selfsigned.key \
    -out /etc/ssl/certs/apache-selfsigned.crt \
    -subj "/C=VN/ST=Asia/L=Ho Chi Minh/O=FPT Telecom/CN=speedtest.fpt.vn"

# Update Apache configuration
COPY docker/apache2.conf /etc/apache2/sites-available/000-default.conf
COPY docker/apache2-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Enable Apache SSL module and configure HTTPS
RUN a2enmod ssl && a2enmod rewrite
RUN a2ensite default-ssl.conf

# Prepare default environment variables
ENV TITLE=LibreSpeed
ENV MODE=standalone
ENV PASSWORD=password
ENV TELEMETRY=false
ENV ENABLE_ID_OBFUSCATION=false
ENV REDACT_IP_ADDRESSES=false
ENV WEBPORT=80

# Final touches
EXPOSE 80
CMD ["bash", "/entrypoint.sh"]

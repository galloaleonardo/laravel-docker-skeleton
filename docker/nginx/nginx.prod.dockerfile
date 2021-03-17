FROM nginx:stable-alpine

# Get domain name from docker-compose.prod.yml
ARG DOMAIN_NAME

# Create certificate name.
ARG CERT_NAME=${DOMAIN_NAME}.zip
RUN echo ${CERT_NAME}

# Install Bash, Nano and Unzip.
RUN apk update && apk add bash nano unzip

# Copy nginx conf to container.
ADD ./config/default.conf /etc/nginx/conf.d/default.conf

# Create certificate directory.
RUN mkdir /etc/ssl/certs/nginx/

# Copy certificado to container.
COPY ./${CERT_NAME} /etc/ssl/certs/nginx/${CERT_NAME}

# Change workdir to certificate directory.
WORKDIR /etc/ssl/certs/nginx/

# Unzip certificate.
RUN sh -c 'unzip -q "*.zip"'

# Make public key certificate.
RUN { cat /etc/ssl/certs/nginx/certificate.crt; echo; cat /etc/ssl/certs/nginx/ca_bundle.crt; } > /etc/ssl/certs/nginx/${CERT_NAME}

# Rename private key certificate.
RUN mv /etc/ssl/certs/nginx/private.key /etc/ssl/certs/nginx/${CERT_NAME}

# Remove temporary certificate files.
RUN rm /etc/ssl/certs/nginx/ca_bundle.crt
RUN rm /etc/ssl/certs/nginx/certificate.crt
RUN rm /etc/ssl/certs/nginx/${CERT_NAME}

# Set permission to certificate directory.
RUN chmod 700 /etc/ssl/certs/nginx/

# Set container timezone
ARG TZ='America/Sao_Paulo'
ENV DEFAULT_TZ ${TZ}
RUN apk upgrade --update \
    && apk add -U tzdata \
    && cp /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime \
    && apk del tzdata \
    && rm -rf \
    /var/cache/apk/*
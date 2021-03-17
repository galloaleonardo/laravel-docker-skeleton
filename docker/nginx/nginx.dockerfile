FROM nginx:stable-alpine

# Install Bash and Nano.
RUN apk update && apk add bash nano

# Copy nginx conf to container.
ADD ./config/default.conf /etc/nginx/conf.d/default.conf

# Setting container timezone
ARG TZ='America/Sao_Paulo'
ENV DEFAULT_TZ ${TZ}
RUN apk upgrade --update \
    && apk add -U tzdata \
    && cp /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime \
    && apk del tzdata \
    && rm -rf \
    /var/cache/apk/*
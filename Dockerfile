FROM outeredge/edge-docker-magento:2.2.10 AS magento
FROM outeredge/edge-docker-magento:1.9.4.4-php7 AS magento1
FROM outeredge/edge-docker-php:7.1-alpine

ENV PHP_DISPLAY_ERRORS=On \
    CHROME_HOST=http://chrome.default:9222 \
    APPLICATION_ENV=dev \
    MAGE_IS_DEVELOPER_MODE=true \
    UNISON=/projects/.unison \
    UNISONLOCALHOSTNAME=dev-server

RUN sudo apk add --no-cache \
        jq \
        less \
        libsass \
        mysql-client \
        php7-gd \
        coreutils \
        unison && \
    sudo wget https://files.magerun.net/n98-magerun.phar -O /usr/local/bin/magerun && \
    sudo chmod +x /usr/local/bin/magerun && \
    sudo wget https://raw.githubusercontent.com/netz98/n98-magerun/master/res/autocompletion/bash/n98-magerun.phar.bash -P /etc/profile.d && \
    sudo wget https://files.magerun.net/n98-magerun2.phar -O /usr/local/bin/magerun2 && \
    sudo chmod +x /usr/local/bin/magerun2 && \
    sudo wget https://raw.githubusercontent.com/netz98/n98-magerun2/master/res/autocompletion/bash/n98-magerun2.phar.bash -P /etc/profile.d && \
    mv /home/edge/.composer /home/edge/.composer.orig

WORKDIR /projects

COPY --from=magento /etc/nginx/magento_default.conf /etc/nginx/
COPY --from=magento /templates/nginx-magento.conf.j2 /templates/
COPY --from=magento1 /etc/nginx/magento_security.conf /etc/nginx/
COPY --from=magento1 /templates/nginx-magento.conf.j2 /templates/nginx-magento1.conf.j2

COPY --chown=edge /.bashrc /home/edge/.bashrc
COPY /dev.sh /

CMD ["/dev.sh"]

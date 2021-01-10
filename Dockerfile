FROM ubuntu:20.04

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update \
&& apt install --yes \
apache2 \
certbot \
php7.4 \
php7.4-mysql \
php7.4-ldap \
php7.4-xmlrpc \
php7.4-imap \
curl \
php7.4-curl \
php7.4-gd \
php7.4-mbstring \
php7.4-xml \
php7.4-apcu-bc \
php-cas \
php7.4-intl \
php7.4-zip \
php7.4-bz2 \ 
wget \
jq \
nano

COPY glpi-install.sh /opt/
RUN chmod +x /opt/glpi-install.sh
ENTRYPOINT ["/opt/glpi-install.sh"]

EXPOSE 80 443

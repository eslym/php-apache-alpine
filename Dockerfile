FROM alpine:3.9

COPY start.sh /usr/local/bin/start-httpd.sh

RUN chmod +x /usr/local/bin/start-httpd.sh &&\
    apk update &&\
    apk add --no-cache \
	php7 \
	php7-json \
	php7-phar \
	php7-apache2 \
	php7-ftp \
	php7-xdebug \
	php7-mcrypt \
	php7-mbstring \
	php7-soap \
	php7-gmp \
	php7-pdo_odbc \
	php7-dom \
	php7-pdo \
	php7-zip \
	php7-mysqli \
	php7-sqlite3 \
	php7-pdo_pgsql \
	php7-bcmath \
	php7-gd \
	php7-odbc \
	php7-pdo_mysql \
	php7-pdo_sqlite \
	php7-gettext \
	php7-xmlreader \
	php7-xmlwriter \
	php7-tokenizer \
	php7-xmlrpc \
	php7-bz2 \
	php7-pdo_dblib \
	php7-curl \
	php7-ctype \
	php7-session \
	php7-redis \
	php7-exif \
	php7-gd \
	php7-simplexml \
	php7-pecl-mcrypt \
	apache2 \
	tzdata &&\
    rm -f /var/cache/apk/* &&\
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer &&\
    rm composer-setup.php &&\
    mkdir -p /var/www/html &&\
    echo "<?php phpinfo();" > /var/www/html/index.php &&\
    chown -R apache:apache /var/www/html &&\
    sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf &&\
    sed -i "s/#LoadModule\ session_module/LoadModule\ session_module/" /etc/apache2/httpd.conf &&\
    sed -i "s/#LoadModule\ session_cookie_module/LoadModule\ session_cookie_module/" /etc/apache2/httpd.conf &&\
    sed -i "s/#LoadModule\ session_crypto_module/LoadModule\ session_crypto_module/" /etc/apache2/httpd.conf &&\
    sed -i "s/#LoadModule\ deflate_module/LoadModule\ deflate_module/" /etc/apache2/httpd.conf &&\
    sed -i "s#^DocumentRoot \".*#DocumentRoot \"/var/www/html\"#g" /etc/apache2/httpd.conf &&\
    sed -i "s#/var/www/localhost/htdocs#/var/www/html#" /etc/apache2/httpd.conf &&\
    echo "<Directory \"/var/www/html\">"      >> /etc/apache2/httpd.conf &&\
    echo "	AllowOverride All"            >> /etc/apache2/httpd.conf &&\
    echo "</Directory>"                       >> /etc/apache2/httpd.conf &&\
    echo "ErrorLog \"/dev/stderr\""           >> /etc/apache2/httpd.conf &&\
    echo "CustomLog \"/dev/stdout\" combined" >> /etc/apache2/httpd.conf &&\
    mkdir /extras

EXPOSE 80

CMD ["/usr/local/bin/start-httpd.sh"]

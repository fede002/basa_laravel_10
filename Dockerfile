# Usa una imagen base con Apache y PHP 8.2
FROM php:8.2-apache

# Copia el código de tu proyecto a la imagen
COPY . /var/www/html/

# Instala las extensiones de PHP necesarias para Laravel
RUN apt-get update && apt-get install -y \
    nano \
    libzip-dev \
    unzip \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip pdo pdo_mysql

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala Xdebug
RUN pecl install -o -f xdebug \
    && docker-php-ext-enable xdebug

# Configura Xdebug
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=VSCODE" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Configurar el servidor Apache para usar el directorio public como la raíz del servidor
#RUN sed -i -e 's/html$/html\/public/g' /etc/apache2/sites-available/000-default.conf && \
#    a2enmod rewrite

RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf && \
    a2enmod rewrite

# Configurar los permisos de almacenamiento en caché y registro
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chown -R root:root /var/www/html/vendor
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Expone el puerto 80 para Apache
EXPOSE 80

# Definir el comando de inicio para el contenedor
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
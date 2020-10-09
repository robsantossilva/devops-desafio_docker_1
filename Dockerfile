FROM php:7.3.6-fpm-alpine3.9

RUN apk add --no-cache openssl bash mysql-client nodejs npm

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN docker-php-ext-install pdo pdo_mysql bcmath

WORKDIR /var/www

RUN rm -rf /var/www/html

#Quando o nginx apontar para html direciona para public
RUN ln -s public html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . /var/www

RUN cp .env.example .env

RUN composer install
#RUN php artisan key:generate
#RUN php artisan cache:clear
RUN chmod -R 777 storage

EXPOSE 9000

ENTRYPOINT [ "php-fpm" ]
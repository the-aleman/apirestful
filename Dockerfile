FROM ubuntu:20.04

RUN apt update --fix-missing
RUN apt update && apt-get install software-properties-common curl -y
RUN add-apt-repository -y ppa:ondrej/php && apt-get update
RUN apt install nginx php7.4 php7.4-fpm php7.4-common php7.4-mysql php7.4-mbstring php7.4-xml php7.4-zip php7.4-gd php7.4-bcmath php7.4-curl\
    php7.4-sqlite3 php7.4-xdebug supervisor -y
RUN apt update 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.5 
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN apt remove yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y yarn
RUN apt update && apt-get install chromium-browser -y

COPY Docker/nginx/site.conf /etc/nginx/sites-available/site.conf
COPY Docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY Docker/conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN ln -s /etc/nginx/sites-available/site.conf /etc/nginx/sites-enabled/

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/apirestful.local.key -out /etc/ssl/certs/apirestful.local.crt -subj "/C=CO/ST=Bogota D.C/L=Colombia/O=Local/OU=Development/CN=apirestful.local"

WORKDIR /var/www/html

EXPOSE 80 443

CMD ["supervisord"]
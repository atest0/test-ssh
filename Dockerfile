FROM debian

#ssh {

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server pwgen
RUN apt-get clean
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh

ENV AUTHORIZED_KEYS **None**

#ssh }

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim nano curl wget zip build-essential git \
	nginx \
	php5-cli php5-cgi php5-fpm php5-mcrypt php5-mysql

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 \
	mariadb-server \
	php5 \
	php5-gd \
	php5-mysql \
	php5-curl \
	php-apc \
	zlibc \
	zlib1g \
	zlib1g-dev \
	libpcre3 \
	libpcre3-dev \
	libapache2-mod-php5 \
	zip

RUN apt-get clean

RUN wget -qP ~/tmp https://files.phpmyadmin.net/phpMyAdmin/4.7.0/phpMyAdmin-4.7.0-all-languages.zip
RUN unzip -jqod /var/www/html/pma ~/tmp/phpMyAdmin*
RUN rm -rf ~/tmp

ADD nginx_default /etc/nginx/sites-available/default

ADD run.sh /run.sh
RUN chmod +x /*.sh


RUN echo "syntax on\nset number\nset ruler\n" >> /etc/vim/vimrc

EXPOSE 80 8080 22

ENTRYPOINT ["/run.sh"]

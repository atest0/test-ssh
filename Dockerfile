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
	php7.0-cli php7.0-cgi php7.0-fpm php7.0-mcrypt php7.0-mysql

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 \
	mariadb-server \
	php7.0 \
	php7.0-gd \
	php7.0-mysql \
	php7.0-curl \
	php7.0-apc \
	zlibc \
	zlib1g \
	zlib1g-dev \
	libpcre3 \
	libpcre3-dev \
	libapache2-mod-php7.0 \
	zip

RUN apt-get clean


RUN mkdir /usr/local/pro
RUN mkdir ~/tmp && cd ~/tmp

RUN wget -O a https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz && \
        mkdir /usr/local/pro/go && \
        tar xzf a -C /usr/local/pro/go --strip-components 1 && \
        rm a && \
        echo "export GOPATH=~/.zo/go" >> /etc/bashrc && \
        echo "export PATH=$PATH:/usr/local/pro/go/bin" >> /etc/bashrc && \
        source /etc/bashrc

RUN wget -O a https://nodejs.org/dist/v10.16.0/node-v10.16.0-linux-x64.tar.xz && \
        mkdir /usr/local/pro/node && \
        tar Jxf a -C /usr/local/pro/node --strip-components 1 && \
        rm a && \
        echo "export PATH=$PATH:/usr/local/pro/node/bin" >> /etc/bashrc && \
        source /etc/bashrc

RUN cd ~ && rm -rf tmp

RUN wget -qP ~/tmp https://files.phpmyadmin.net/phpMyAdmin/4.7.0/phpMyAdmin-4.7.0-all-languages.zip
RUN unzip -qod ~/tmp/pma ~/tmp/phpMyAdmin*
RUN mv ~/tmp/pma/p* /var/www/html/pma
RUN rm -rf ~/tmp

ADD nginx_default /etc/nginx/sites-available/default

ADD run.sh /run.sh
RUN chmod +x /*.sh


RUN echo "syntax on\nset number\nset ruler\n" >> /etc/vim/vimrc

EXPOSE 80 8080 22

ENTRYPOINT ["/run.sh"]

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
	nginx

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	mariadb-server \
	zlibc \
	zlib1g \
	zlib1g-dev \
	libpcre3 \
	libpcre3-dev \
	zip

RUN apt-get clean

SHELL ["/bin/bash", "-c"]

RUN mkdir /usr/local/pro
RUN mkdir ~/tmp && cd ~/tmp

RUN wget -qO a https://dl.google.com/go/go1.13.linux-amd64.tar.gz && \
        mkdir /usr/local/pro/go && \
        tar xzf a -C /usr/local/pro/go --strip-components 1 && \
        rm a && \
        echo 'export GOPATH=~/.zo/go' >> /etc/bashrc && \
        echo 'export PATH=$PATH:/usr/local/pro/go/bin' >> /etc/bash.bashrc && \
	source /etc/bash.bashrc

RUN wget -qO a https://nodejs.org/dist/v10.16.3/node-v10.16.3-linux-x64.tar.xz && \
        mkdir /usr/local/pro/node && \
        tar Jxf a -C /usr/local/pro/node --strip-components 1 && \
        rm a && \
        echo 'export PATH=$PATH:/usr/local/pro/node/bin' >> /etc/bash.bashrc && \
	source /etc/bash.bashrc

RUN cd ~ && rm -rf tmp

RUN wget -qP ~/tmp https://files.phpmyadmin.net/phpMyAdmin/4.7.0/phpMyAdmin-4.7.0-all-languages.zip
RUN unzip -qod ~/tmp/pma ~/tmp/phpMyAdmin*
RUN mv ~/tmp/pma/p* /var/www/html/pma
RUN rm -rf ~/tmp

ADD nginx_default /etc/nginx/sites-available/default

ADD run.sh /run.sh
RUN chmod +x /*.sh


RUN echo -e "syntax on\nset number\nset ruler\n" >> /etc/vim/vimrc

EXPOSE 80 8080 22

ENTRYPOINT ["/run.sh"]

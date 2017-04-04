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
RUN apt-get clean

ADD nginx_default /etc/nginx/sites-available/default
RUN mkdir /var/nginx/www
RUN chmod 777 /var/nginx/www

ADD run.sh /run.sh
RUN chmod +x /*.sh


EXPOSE 80 8080 22

ENTRYPOINT ["/run.sh"]

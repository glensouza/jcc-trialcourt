FROM nginx:alpine

# ssh
ENV SSH_PASSWD "root:Docker!"
ENV SSH_PORT 2222
ENV SUPERVISOR_LOG_DIR "/home/LogFiles/supervisor"

RUN set -ex \
    && apk update \
    && apk add --no-cache supervisor openssl git net-tools tcpdump tcptraceroute vim curl wget bash patch\
	&& cd /usr/bin \
	&& wget http://www.vdberg.org/~richard/tcpping \
	&& chmod 777 tcpping \
# ------
# ssh
# ------
    && apk add --no-cache openssh-server \
    && echo "$SSH_PASSWD" | chpasswd \
#---------------
# openrc service
#---------------
    && apk add --no-cache openrc \
    && sed -i 's/"cgroup_add_service/" # cgroup_add_service/g' /lib/rc/sh/openrc-run.sh \
    && mkdir -p /home/site/wwwroot/

COPY nginx.conf /etc/nginx/nginx.conf
COPY redirects/. /etc/nginx/conf.d/

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY sshd_config /etc/ssh/
COPY init_container.sh /bin/

RUN chmod +x /bin/init_container.sh
EXPOSE 80 2222
CMD ["/bin/init_container.sh"]

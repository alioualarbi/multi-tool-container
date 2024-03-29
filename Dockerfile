
FROM alpine

# Install some tools in the container.
RUN     apk update \
    &&  apk add nginx bind-tools curl wget nmap procps tcpdump busybox-extras mtr openssh-client postgresql-client mysql-client rsync jq git iputils lftp netcat-openbsd socat iproute2 net-tools bash perl-net-telnet iperf3 ethtool apache2-utils \
    && mkdir /certs \
    && chmod 700 /certs 

# Interesting:
# Users of this image may wonder, why this multitool runs a web server? 
# Well, normally, if a container does not run a daemon, 
#   ,then running it involves creating a special deployment.yaml file, 
#   ,which keeps the pod alive, so we can connect to it and do our testing, etc.
# If you don't want to create that extra file, 
#   ,then it is best to 'also' run a web server (as a daemon) in the container - as default process.
# This helps when you are on kubernetes platform and simply execute:
#   $ kubectl run multitool --image=praqma/network-multitool --replicas=1

# The multitool container starts - as web server. Then, you simply connect to it using:
#   $ kubectl exec -it multitool-3822887632-pwlr1  bash 

# This is why it is good to have a webserver in this tool. 
# Besides, I believe that having a web server in a multitool is like having yet another tool! 
# Personally, I think this is cool! Henrik thinks the same!

# Copy a simple index.html to eliminate text (index.html) noise which comes with default nginx image.
# (I created an issue for this purpose here: https://github.com/nginxinc/docker-nginx/issues/234)
COPY index.html /usr/share/nginx/html/


# Copy a custom nginx.conf with log files redirected to stderr and stdout
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-connectors.conf /etc/nginx/conf.d/default.conf
COPY server.* /certs/

EXPOSE 80 443

#WORKDIR /
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh


# Run the startup script as ENTRYPOINT, which does few things and then starts nginx.
ENTRYPOINT ["sh", "/docker-entrypoint.sh"]

# Start nginx in foreground:
CMD ["nginx", "-g", "daemon off;"]

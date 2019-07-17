FROM nginx:alpine

RUN apk update
RUN apk add bash curl nmap apache2-utils bind-tools tcpdump mtr iperf3 strace tree busybox-extras netcat-openbsd

RUN echo alias telnet='busybox-extras telnet' >> .bashrc
RUN echo alias netcat='nc' >> .bashrc

RUN apk update

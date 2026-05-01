FROM alpine:latest
#
WORKDIR /app
COPY config/ ./
#
RUN apk update && \
    apk add mitmproxy wireguard-tools openssh net-tools iputils-ping ufw iptables busybox-suid
#
ARG WIREGUARD_DIR=/etc/wireguard
ARG SERVER_CONFIG=wg0.conf
ARG CLIENT_CONFIG=client.conf
RUN ls "${SERVER_CONFIG}" &> /dev/null && ls "${CLIENT_CONFIG}" &> /dev/null && \
    ufw allow 8080/tcp && \
    ufw allow 51820/udp && \
    wg genkey | tee server_private.key | wg pubkey > server_public.key && \
    chmod go= server_private.key && \
    wg genkey | tee client_private.key | wg pubkey > client_public.key && \
    chmod go= client_private.key && \
    cat server_private.key | while read line; \
    do sed -i "/PrivateKey/s|<>|$line|" "${SERVER_CONFIG}"; \
    done && \ 
    cat server_public.key | while read line; \
    do sed -i "/PublicKey/s|<>|$line|" "${CLIENT_CONFIG}"; \
    done && \ 
    cat client_private.key | while read line; \
    do sed -i "/PrivateKey/s|<>|$line|" "${CLIENT_CONFIG}"; \
    done && \ 
    cat client_public.key | while read line; \
    do sed -i "/PublicKey/s|<>|$line|" "${SERVER_CONFIG}"; \
    done && \
    sed -i "s/TODO/DONE/" "${SERVER_CONFIG}" && \
    ip route list | grep "src" | sed "s/.*src.//" | while read line; \
    do sed -i "/EndPoint/s|<>|$line|" "${CLIENT_CONFIG}"; \
    done && \
    sed -i "s/TODO/DONE/" "${CLIENT_CONFIG}" && \
    mv *.conf "${WIREGUARD_DIR}" && \
    mv *.key "${WIREGUARD_DIR}" && \
    sed -i '/net.ipv4.ip_forward=1/s/#//' /etc/sysctl.conf && \
    sed -i '/net\/ipv4\/ip_forward=1/s/#//' /etc/ufw/sysctl.conf && \
    sysctl -p
#
ARG SSH_USER=root
ARG SSH_PASSWORD=admin
ARG ROOT_PASSWORD=admin
ARG SSH_CONFIG=/etc/ssh/sshd_config
RUN adduser -D -s /bin/sh ${SSH_USER} && \
    echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd && \
    echo "root:${ROOT_PASSWORD}" | chpasswd && \
    ssh-keygen -A && \
    ufw allow ssh && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' "${SSH_CONFIG}" && \
    sed -i '/PermitRootLogin/s/yes/no/' "${SSH_CONFIG}" && \
    sed -i '/#Port 22/s/#//' "${SSH_CONFIG}"
#
ENV CMD_COPY_CLIENT="cp \"${WIREGUARD_DIR}/${CLIENT_CONFIG}\" /app/storage"
ENTRYPOINT [ "sh", "-c", "eval \"$CMD_COPY_CLIENT\" && wg-quick up wg0 && /usr/sbin/sshd && ufw enable && sh" ]

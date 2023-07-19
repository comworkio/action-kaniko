FROM alpine as certs

RUN apk --update add ca-certificates

FROM gcr.io/kaniko-project/executor:v1.9.1-debug

SHELL ["/busybox/sh", "-c"]

RUN wget -O /kaniko/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x /kaniko/jq && \
    wget -O /kaniko/reg \
    https://github.com/genuinetools/reg/releases/download/v0.16.1/reg-linux-386 && \
    chmod +x /kaniko/reg && \
    wget -O /crane.tar.gz \ 
    https://github.com/google/go-containerregistry/releases/download/v0.8.0/go-containerregistry_Linux_x86_64.tar.gz && \
    tar -xvzf /crane.tar.gz crane -C /kaniko && \
    rm /crane.tar.gz

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=certs /usr/sbin/useradd /usr/sbin/useradd

RUN useradd --user-group --system --create-home --no-log-init kaniko

COPY entrypoint.sh /

RUN chown -R kaniko:kaniko /kaniko && \
    chown -R kaniko:kaniko /entrypoint.sh && \
    chmod +x /entrypoint.sh

USER kaniko

ENTRYPOINT ["/entrypoint.sh"]

LABEL repository="https://github.com/idrissneumann/action-kaniko" \
    maintainer="Idriss Neumann <idriss.neumann@comwork.io>"

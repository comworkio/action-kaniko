ARG NGINX_VERSION="alpine"

FROM nginx:${NGINX_VERSION} AS nginx

COPY .docker/nginx.conf /etc/nginx/conf.d/default.conf

COPY ./ /usr/share/nginx/html

CMD [ "nginx", "-g","daemon off;" ]

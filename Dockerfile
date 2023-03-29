FROM nginx:1.23.4-alpine
COPY nginx.conf /etc/nginx/templates/default.conf.template
COPY documentroot /usr/share/nginx/html

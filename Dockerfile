FROM nginx:1.27.4-alpine
COPY nginx.conf /etc/nginx/templates/default.conf.template
COPY documentroot /usr/share/nginx/html

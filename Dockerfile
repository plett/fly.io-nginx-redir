FROM nginx:1.29.1-alpine
COPY nginx.conf /etc/nginx/templates/default.conf.template
COPY documentroot /usr/share/nginx/html

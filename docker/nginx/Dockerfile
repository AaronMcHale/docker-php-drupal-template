FROM nginx:alpine

# Copy configuration files
COPY "nginx.conf" "/etc/nginx/"
COPY "snippets/php-fpm.conf" "/etc/nginx/snippets/"
COPY "snippets/drupal.conf" "/etc/nginx/snippets/"
COPY "conf.d/default.conf" "/etc/nginx/conf.d/"

EXPOSE 8080
USER nginx

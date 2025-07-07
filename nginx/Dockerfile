FROM nginx:alpine

# Copy NGINX config from inside ./nginx/ folder
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy static frontend files from ./frontend/ folder
COPY frontend/index.html /usr/share/nginx/html/
COPY frontend/styles.css /usr/share/nginx/html/
COPY frontend/logo.png /usr/share/nginx/html/
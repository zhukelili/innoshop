# 使用官方 PHP 镜像
FROM php:8.2-apache

# 安装 zip 和 git
RUN apt-get update && apt-get install -y \
    libzip-dev \
    git \
    unzip && \
    docker-php-ext-install zip

# 将项目文件复制到容器中
COPY . /var/www/html/

# 设定工作目录
WORKDIR /var/www/html/

# 启用 Apache mod_rewrite
RUN a2enmod rewrite

# 编辑 Apache 配置以修改 DocumentRoot
RUN echo "<VirtualHost *:80>" > /etc/apache2/sites-available/000-default.conf && \
    echo "    DocumentRoot /var/www/html/public" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    <Directory /var/www/html/public>" >> /etc/apache2/sites-available/000-default.conf && \
    echo "        Options Indexes FollowSymLinks" >> /etc/apache2/sites-available/000-default.conf && \
    echo "        AllowOverride All" >> /etc/apache2/sites-available/000-default.conf && \
    echo "        Require all granted" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    </Directory>" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    ErrorLog \${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    CustomLog \${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/000-default.conf && \
    echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

# 安装 Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 安装项目依赖
RUN composer install

# 安装额外的 PHP 扩展（根据需要）
RUN docker-php-ext-install pdo pdo_mysql

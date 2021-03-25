FROM debian
RUN apt-get update && apt-get install -y apache2 libapache2-mod-php7.3 php7.3 php7.3-mysql git mariadb-client && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN rm /var/www/html/index.html
ENV MARIADB_USER bookmedik
ENV MARIADB_PASS bookmedik
ENV MARIADB_NAME bookmedik
ENV MARIADB_HOST servidor_mysql

EXPOSE 80
RUN git clone https://github.com/evilnapsis/bookmedik.git /var/www/html
ADD script.sh /usr/local/bin/script.sh
ADD schema.sql /opt
RUN chmod +x /usr/local/bin/script.sh
CMD ["/usr/local/bin/script.sh"]

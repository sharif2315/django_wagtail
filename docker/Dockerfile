FROM centos:centos8


COPY requirements.txt /requirements.txt

RUN yum install -y epel-release && \
    yum install -y python3 httpd make gcc httpd-devel redhat-rpm-config python3-devel openssl && \
    cd / && \
    python3 -m venv /opt/sw/pyenv && \
    . /opt/sw/pyenv/bin/activate && \
    pip install -r /requirements.txt && \
    curl -L -O https://github.com/GrahamDumpleton/mod_wsgi/archive/4.7.1.tar.gz && \
    tar zxpf 4.7.1.tar.gz && \
    cd mod_wsgi-4.7.1/ && \
    ./configure && \
    make install && \
    mkdir -p /etc/httpd/ssl && \
    openssl req -new -newkey rsa:4096 -days 7 -nodes -x509 \
        -subj "/C=UK/ST=/L=/O=WAGTAILAPP Demo Cert/CN=wagtailapp" \
        -keyout /etc/httpd/ssl/wagtailapp.key  -out /etc/httpd/ssl/wagtailapp.crt


FROM centos:centos8

COPY media /app/media
COPY django_wagtail /app/django_wagtail
COPY home /app/search
COPY search /app/search
COPY docker/resources/app.sh /app/app.sh
COPY manage.py /app/manage.py

RUN yum install -y httpd mod_ssl python3 net-tools && \
    mkdir -p /app/media && \
    chown -R apache:apache /app && \
    chmod 775 /app/app.sh && \
    rm -f /etc/httpd/conf.d/ssl.conf

COPY --from=0 /opt/sw/pyenv /opt/sw/pyenv
COPY --from=0 /etc/httpd/ssl /etc/httpd/ssl
COPY --from=0 /usr/lib64/httpd/modules/mod_wsgi.so /usr/lib64/httpd/modules/mod_wsgi.so
COPY docker/resources/wagtailapp_httpd.conf /etc/httpd/conf.d/

ENV PYTHONUNBUFFERED 1

CMD ["/app/app.sh", "-DFOREGROUND"]

FROM centos:7

EXPOSE 1978

RUN yum update -y \
    && yum remove -y linux-firmware \
    && yum install -y curl gcc g++ make zlib zlib-devel bzip2-devel \
    && rm -rf /var/cache/yum/* \
    && yum clean all

RUN cd /tmp \
    && curl -kLO https://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz \
    && tar zxvf tokyocabinet-1.4.48.tar.gz \
    && cd /tmp/tokyocabinet-1.4.48 \
    && ./configure && make && make install && make clean \
    && rm /tmp/tokyocabinet-1.4.48.tar.gz
RUN cd /tmp \
    && curl -kLO https://fallabs.com/tokyotyrant/tokyotyrant-1.1.41.tar.gz \
    && tar zxvf tokyotyrant-1.1.41.tar.gz \
    && cd /tmp/tokyotyrant-1.1.41 \
    && ./configure && make && make install && make clean \
    && rm /tmp/tokyotyrant-1.1.41.tar.gz

RUN mkdir -p /var/ttserver/ulog

CMD ["ttserver", "-port", "1978", "-pid", "/var/run/ttserver1978.pid", "-ulog", "/var/ttserver/ulog", "-ulim", "256m", "-sid", "999", "/var/ttserver/casket.tch#bnum=50000000"]

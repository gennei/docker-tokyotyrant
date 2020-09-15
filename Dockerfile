FROM centos:7

EXPOSE 1978

RUN yum update && \
    yum install -y curl gcc g++ make zlib zlib-devel bzip2 bzip2-devel

WORKDIR /tmp

# tar がうまく展開できなくて -L を追加
# https://qiita.com/KEINOS/items/85293296368d266ec9fb
RUN curl -LO https://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz
RUN tar zxvf tokyocabinet-1.4.48.tar.gz

WORKDIR /tmp/tokyocabinet-1.4.48
RUN ./configure && make && make install 

WORKDIR /tmp
RUN curl -LO https://fallabs.com/tokyotyrant/tokyotyrant-1.1.41.tar.gz
RUN tar zxvf tokyotyrant-1.1.41.tar.gz

WORKDIR /tmp/tokyotyrant-1.1.41
RUN ./configure && make && make install 

WORKDIR /

RUN mkdir -p /var/ttserver/ulog

CMD ["ttserver", "-port", "1978", "-pid", "/var/run/ttserver1978.pid", "-ulog", "/var/ttserver/ulog", "-ulim", "256m", "-sid", "999", "/var/ttserver/casket.tch#bnum=50000000"]

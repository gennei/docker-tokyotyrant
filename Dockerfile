FROM alpine:3.12.0

EXPOSE 1978

RUN apk update && \
    apk --no-cache add curl gcc g++ make zlib-dev bzip2-dev 

WORKDIR /tmp

# tar がうまく展開できなくて -L を追加
# https://qiita.com/KEINOS/items/85293296368d266ec9fb
RUN curl -LO https://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz
RUN tar zxvf tokyocabinet-1.4.48.tar.gz

WORKDIR /tmp/tokyocabinet-1.4.48
RUN ./configure && make
RUN make install

WORKDIR /tmp
RUN curl -LO https://fallabs.com/tokyotyrant/tokyotyrant-1.1.41.tar.gz
RUN tar zxvf tokyotyrant-1.1.41.tar.gz

WORKDIR /tmp/tokyotyrant-1.1.41
RUN ./configure && make
RUN make install

WORKDIR /

CMD ["ttserver" "-port 1978" "/var/ttserver/casket.tch#bnum=50000000"]

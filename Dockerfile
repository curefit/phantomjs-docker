# Based off https://github.com/ariya/phantomjs/blob/2.1.1/deploy/docker-build.sh
FROM debian:stretch AS builder

RUN echo "deb-src http://httpredir.debian.org/debian stretch main" >> /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y build-essential git flex bison gperf python ruby libfontconfig1-dev

WORKDIR /build

# Build static OpenSSL
ENV OPENSSL_TARGET=linux-generic64
ENV OPENSSL_FLAGS='no-idea no-mdc2 no-rc5 no-zlib enable-tlsext no-ssl2 no-ssl3 no-ssl3-method enable-rfc3779 enable-cms'
RUN apt-get source openssl1.0
RUN cd /build/openssl1.0-1.0.2u \
  && ./Configure --prefix=/usr --openssldir=/etc/ssl --libdir=lib ${OPENSSL_FLAGS} ${OPENSSL_TARGET} \
  && make depend \
  && make -j$(nproc) \
  && make install

# Build static ICU
RUN apt-get source icu
RUN cd /build/icu-57.1/source \
 && ./configure --prefix=/usr --enable-static --disable-shared \
 && make -j$(nproc) \
 && make install

# get the phantomjs source
RUN git clone --depth 1 --shallow-submodules --recursive --branch 2.1.1 git://github.com/ariya/phantomjs.git
WORKDIR /build/phantomjs

# build the binary
RUN ./build.py --confirm --release --qt-config="-no-pkg-config"

# strip the binary
RUN strip bin/phantomjs

FROM debian:stretch-slim
COPY --from=builder /build/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
RUN apt-get update && apt-get install -y libfontconfig
CMD [ "/usr/local/bin/phantomjs" ]

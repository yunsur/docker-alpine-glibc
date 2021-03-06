FROM alpine:3.13

ARG ALPINE_GLIBC_PKG_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download"
ARG ALPINE_GLIBC_PKG_VERSION="2.33-r0"

ENV LANG=C.UTF-8
ENV TZ=Asia/Shanghai

RUN ALPINE_GLIBC_BASE_PKG_FILENAME="glibc-$ALPINE_GLIBC_PKG_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PKG_FILENAME="glibc-bin-$ALPINE_GLIBC_PKG_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PKG_FILENAME="glibc-i18n-$ALPINE_GLIBC_PKG_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && echo "$TZ" > /etc/timezone && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget --no-check-certificate \
        "$ALPINE_GLIBC_PKG_URL/$ALPINE_GLIBC_PKG_VERSION/$ALPINE_GLIBC_BASE_PKG_FILENAME" \
        "$ALPINE_GLIBC_PKG_URL/$ALPINE_GLIBC_PKG_VERSION/$ALPINE_GLIBC_BIN_PKG_FILENAME" \
        "$ALPINE_GLIBC_PKG_URL/$ALPINE_GLIBC_PKG_VERSION/$ALPINE_GLIBC_I18N_PKG_FILENAME" && \
    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PKG_FILENAME" \
        "$ALPINE_GLIBC_BIN_PKG_FILENAME" \
        "$ALPINE_GLIBC_I18N_PKG_FILENAME" && \
    \
    mv /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /usr/glibc-compat/lib/ld-linux-x86-64.so && \
    ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so /usr/glibc-compat/lib/ld-linux-x86-64.so.2 && \
    \
    apk add --no-cache libstdc++ gettext && \
    \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PKG_FILENAME" \
        "$ALPINE_GLIBC_BIN_PKG_FILENAME" \
        "$ALPINE_GLIBC_I18N_PKG_FILENAME" && \
    \
    apk add --no-cache --virtual .gettext gettext && \
    mv /usr/bin/envsubst /tmp/ && \
    \
    runDeps="$( \
        scanelf --needed --nobanner /tmp/envsubst \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache $runDeps && \
    apk del .gettext && \
    mv /tmp/envsubst /usr/local/bin/

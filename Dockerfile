FROM ghcr.io/unb-libraries/nginx:3.23.x

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

COPY build/conf/nginx/app.conf ${NGINX_APP_CONF_FILE}

LABEL ca.unb.lib.generator="nuxt-ssg" \
  org.opencontainers.image.title="nuxt-ssg" \
  org.opencontainers.image.description="The base image serving prerendered Nuxt (SSG) sites at UNB Libraries." \
  org.opencontainers.image.vendor="University of New Brunswick Libraries" \
  org.opencontainers.image.authors="UNB Libraries <libsupport@unb.ca>" \
  org.opencontainers.image.url="https://github.com/unb-libraries/docker-nuxt-ssg" \
  org.opencontainers.image.source="https://github.com/unb-libraries/docker-nuxt-ssg" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.version="$VERSION" \
  org.opencontainers.image.revision="$VCS_REF" \
  org.opencontainers.image.created="$BUILD_DATE"

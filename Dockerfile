FROM denoland/deno:1.42.1

ARG ASSETS_REPO_URL="https://github.com/apache/incubator-kie-kogito-online.git"
ARG ASSETS_BRANCH_NAME="gh-pages"
ARG ASSETS_VER="0.32.0"
ARG DENO_FILE_SERVER_VER="@0.221.0"
ARG DENO_FILE_SERVER_PORT="8080"

ENV ASSETS_REPO_URL=ASSETS_REPO_URL
ENV ASSETS_BRANCH_NAME=ASSETS_BRANCH_NAME
ENV ASSETS_VER=ASSETS_VER
ENV DENO_FILE_SERVER_VER=DENO_FILE_SERVER_VER
ENV DENO_FILE_SERVER_PORT=DENO_FILE_SERVER_PORT

WORKDIR /deno-dir

COPY --chown=deno:deno entrypoint.sh .

RUN ./entrypoint.sh install_deps

USER deno

RUN ./entrypoint.sh fetch_assets

ENTRYPOINT [ "./entrypoint.sh", "serve" ]

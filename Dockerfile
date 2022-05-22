# Build swift backend
FROM swift:5.6 AS swift-builder

COPY . /gitignore.io

WORKDIR /gitignore.io

RUN set -ex \
    && apt update \
    && apt install libssl-dev -y \
    && swift package clean \
    && swift package update \
    && swift build -Xswiftc -static-stdlib -j $(nproc) -c release \
    && mv $(swift build -Xswiftc -static-stdlib -c release --show-bin-path)/Run /tmp/Run

# Build node frontend
FROM node:lts AS node-builder

COPY . /gitignore.io

WORKDIR /gitignore.io

RUN set -ex \
    && yarn install \
    && yarn build \
    && rm -rf node_models

# Build final image
FROM debian:stable-slim

# Install some necessary dependencies
RUN set -ex \
    && apt update \
    && apt install git ca-certificates libcurl4 --no-install-recommends -y \
    && apt autoremove -y \
    && apt autoclean -y

WORKDIR /app

# Copy the project and remove the node frontend
COPY . ./
COPY .git ./

RUN rm -rf /app/Public /app/Resources

# Copy all newly compiled files to the final image
COPY --from=swift-builder /tmp/Run /app/Run
COPY --from=node-builder /gitignore.io/Public /app/Public
COPY --from=node-builder /gitignore.io/Resources /app/Resources

SHELL ["/bin/bash", "-c"]

EXPOSE 8080/tcp

CMD /app/Run serve -e prod -b 0.0.0.0

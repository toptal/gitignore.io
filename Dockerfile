# Build swift backend
FROM swift:5.6-focal AS swift-builder

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
    && rm -rf node_modules

# Build final image
FROM debian:stable-slim

WORKDIR /app

# Copy the project and remove the node frontend
COPY . ./
COPY .git ./

# Install some necessary dependencies
RUN set -ex \
    && apt update \
    && apt install git ca-certificates libcurl4 dumb-init --no-install-recommends -y \
    && git submodule update --init --recursive \
    && rm -rf /app/Public /app/Resources \
    && apt autoremove -y \
    && apt autoclean -y

# Copy all newly compiled files to the final image
COPY --from=swift-builder /tmp/Run /app/Run
COPY --from=node-builder /gitignore.io/Public /app/Public
COPY --from=node-builder /gitignore.io/Resources /app/Resources

SHELL ["/bin/bash", "-c"]

EXPOSE 8080/tcp

# Add dump-init to ensure container can respond to exit signals
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD /app/Run serve -e prod -b 0.0.0.0

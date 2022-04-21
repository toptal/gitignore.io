FROM swift:4.2.4
WORKDIR /app
COPY . ./
RUN git submodule update --init --recursive
RUN swift package clean
RUN swift build -c release
RUN mkdir /app/bin
RUN mv `swift build -c release --show-bin-path` /app/bin
EXPOSE 8080
ENTRYPOINT ["/app/bin/release/Run", "serve", "-e", "prod", "-b", "0.0.0.0"]

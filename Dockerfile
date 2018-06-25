FROM vapor/vapor:1.0.9-xenial

WORKDIR /app

COPY ./ ./

RUN vapor build

EXPOSE 8080

# CMD vapor run


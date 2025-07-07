### stage 1 ##############
FROM golang:1.22-alpine AS builder

# Enable Go build cache
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    mkdir -p /root/.cache/go-build

WORKDIR /usr/src/app

# cache go modules
COPY go.mod go.sum ./
RUN go mod download

# copy source code
COPY . .

# build the binary
RUN go build -o publication-service .

### stage 2 ##############
FROM alpine:latest AS release

WORKDIR /usr/src/app

# copy the binary from the builder stage
COPY --from=builder /usr/src/app/publication-service .
COPY .env .

EXPOSE 5002
CMD ["./publication-service"]
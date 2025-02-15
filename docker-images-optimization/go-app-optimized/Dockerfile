# build
FROM golang:1.23.5-alpine AS golang-builder
RUN mkdir /build
WORKDIR /build
COPY src/go.mod src/go.sum ./
RUN go mod download
COPY src/**/*.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# app run
FROM alpine:3.19
RUN addgroup -S appuser && adduser -S appuser -G appuser
USER appuser
RUN mkdir /home/appuser/app
WORKDIR /home/appuser/app
COPY --from=golang-builder --chown=appuser /build .
CMD ["./main"]
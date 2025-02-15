FROM golang:1.23.5-alpine

RUN addgroup -S appuser && adduser -S appuser -G appuser

RUN mkdir /home/appuser/app

WORKDIR /home/appuser/app

COPY src/go.mod src/go.sum ./

RUN go mod download

COPY src/**/*.go ./

RUN chown -R appuser:appuser /home/appuser/app

USER appuser

RUN CGO_ENABLED=0 GOOS=linux go build -o main .

CMD ["./main"]
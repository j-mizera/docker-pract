FROM golang:latest

RUN useradd -m appuser

WORKDIR /home/appuser/app

COPY src/go.mod src/go.sum ./

RUN go mod download

COPY src/**/*.go ./

RUN chown -R appuser:appuser /home/appuser/app

USER appuser

RUN CGO_ENABLED=0 GOOS=linux go build -o main .

CMD ["./main"]
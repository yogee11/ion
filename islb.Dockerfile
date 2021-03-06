FROM golang:1.13.7-stretch

ENV GO111MODULE=on

COPY . $GOPATH/src/github.com/pion/ion
RUN cd $GOPATH/src/github.com/pion/ion && go mod download

WORKDIR $GOPATH/src/github.com/pion/ion/cmd/islb
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /islb .

FROM alpine:3.9.5
RUN apk --no-cache add ca-certificates
COPY --from=0 /islb /islb

ENTRYPOINT ["/islb"]
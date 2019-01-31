FROM golang:latest
WORKDIR $GOPATH/src 
RUN mkdir -p  $GOPATH/src/app/ 
ADD . $GOPATH/src/app/ 
WORKDIR $GOPATH/src/app
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh 
RUN dep ensure -v
RUN go install -v

EXPOSE 80

CMD ["app"]
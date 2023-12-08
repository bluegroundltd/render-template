FROM --platform=linux/arm64 public.ecr.aws/docker/library/golang:1.17 as build-env

WORKDIR /go/src/app
ADD . /go/src/app

RUN go test -mod=vendor -cover ./...
RUN go build -mod=vendor -o /go/bin/app

FROM --platform=linux/arm64 gcr.io/distroless/static

LABEL name="render-template"
LABEL repository="http://github.com/bluegroundltd/render-template"
LABEL homepage="http://github.com/bluegroundltd/render-template"

LABEL maintainer="BluegroundLTD <engineering@bluegroundltd.com>"
LABEL com.github.actions.name="Render template"
LABEL com.github.actions.description="Renders file based on template and passed variables"
LABEL com.github.actions.icon="file-text"
LABEL com.github.actions.color="purple"

COPY --from=build-env /go/bin/app /app

CMD ["/app"]

# BUILDER
FROM golang:1.14 AS builder
ARG SERVICE=zigbee-gw
WORKDIR /go/src/$SERVICE
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -mod=vendor -o $SERVICE -v

# RUNNER
FROM alpine:3.11
ARG SERVICE=zigbee-gw
ENV bin_dir /opt/zigbee-gw/bin
ENV etc_dir /opt/zigbee-gw/etc
ENV var_dir /opt/zigbee-gw/var

RUN mkdir -p ${bin_dir} && mkdir -p ${etc_dir} && mkdir -p ${var_dir}

WORKDIR ${bin_dir}

COPY --from=builder /go/src/$SERVICE/$SERVICE .
RUN chmod +x $SERVICE

CMD ["./zigbee-gw"]

# UPDATE DOCKER HUB IMAGE
# =======================
#
# docker build -f Dockerfile -t "redkite/zigbee-gw:latest" .
# docker login
# docker push redkite/zigbee-gw:latest
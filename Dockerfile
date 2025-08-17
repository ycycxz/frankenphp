FROM dunglas/frankenphp:latest-builder AS builder
COPY --from=caddy:builder /usr/bin/xcaddy /usr/bin/xcaddy
ENV CGO_ENABLED=1 XCADDY_SETCAP=1 XCADDY_GO_BUILD_FLAGS="-ldflags '-w -s'"
RUN xcaddy build     --output /usr/local/bin/frankenphp     --with github.com/dunglas/frankenphp=./     --with github.com/dunglas/frankenphp/caddy=./caddy/     --with github.com/dunglas/caddy-cbrotli     --with github.com/dunglas/mercure/caddy     --with github.com/dunglas/vulcain/caddy     --with github.com/caddy-dns/cloudflare

FROM dunglas/frankenphp AS runner
COPY --from=builder /usr/local/bin/frankenphp /usr/local/bin/frankenphp
RUN frankenphp list-modules | grep cloudflare

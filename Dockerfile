FROM elixir:1.12.2-alpine

ENV MIX_ENV dev

RUN mkdir -p /opt/app && \
    chmod -R 777 /opt/app

RUN apk update && \
    apk add inotify-tools git nodejs npm build-base && npm install npm -g --no-progress && \
    rm -rf /var/cache/apk/*

# Add local node module binaries to PATH
ENV PATH=./node_modules/.bin:$PATH

WORKDIR /app

COPY . /app

RUN mix do local.hex --force, local.rebar --force

COPY config/ /app/config/
COPY mix.exs /app/
COPY mix.* /app/

RUN mix do deps.get, deps.compile

RUN cd ./assets & npm install & cd ..

RUN mix phx.digest

RUN mix compile
RUN mix phx.digest

EXPOSE 4000

CMD ["mix", "phx.server"]

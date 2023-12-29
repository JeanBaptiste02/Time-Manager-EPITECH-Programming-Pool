FROM elixir:1.14.5

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

WORKDIR /app

COPY . .

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile && \
    mix compile && \
    mix release

EXPOSE 4000

CMD ["mix", "ecto.reset" ]
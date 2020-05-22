FROM ruby:2.7.1-buster

# Throw error if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# App directory
WORKDIR /usr/src/dnd-discord-bot

# Bundle setup/install
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Move scripts over
COPY . .

ENV DISCORD_BOT_TOKEN ""

CMD ["./scripts/launch.sh"]

FROM ruby:2.7.3
RUN apt-get update \
  && apt-get install -y vim \
  && rm -rf /var/lib/apt/lists/*

COPY echo-load-profile.sh /etc/profile.d/


FROM corelight/ubuntu-go-npm
LABEL maintainer="Corelight AWS Team <aws@corelight.com>"
LABEL description="Ubuntu-based builder including Go, NPM and Ruby tool FPM"

RUN apt-get update && apt-get -y install \
  build-essential \
  debhelper \
  gcc \
  git \
  make \
  nodejs \
  npm \
  rpm \
  ruby \
  ruby-dev \
  rubygems \
  sudo \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g create-react-app
# npm-run-all ?

RUN	go get -u github.com/GeertJohan/go.rice/rice && \
    go get -u github.com/golang/dep/cmd/dep && \
    go get -u github.com/mgechev/revive \
    go get -u github.com/swaggo/swag/cmd/swag

RUN gem install --no-ri --no-rdoc fpm

ENV PATH=/root/go/bin:$PATH

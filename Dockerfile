FROM corelight/ubuntu-go-npm:v0.5
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
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g create-react-app
RUN npm install -g newman
# npm-run-all ?

RUN	go get -u github.com/GeertJohan/go.rice/rice && \
    go get -u github.com/golang/dep/cmd/dep && \
    go get -u github.com/mgechev/revive && \
    go get -u github.com/swaggo/swag/cmd/swag

RUN mkdir -p /tmp/swaggo && \
    cd /tmp/swaggo && \
    wget https://github.com/swaggo/swag/releases/download/v1.6.3/swag_1.6.3_Linux_x86_64.tar.gz && \
    tar xzvf swag_1.6.3_Linux_x86_64.tar.gz && \
    mv swag /root/go/bin/swag-prebuild

RUN gem install --no-ri --no-rdoc fpm

ENV PATH=/root/go/bin:$PATH

FROM corelight/ubuntu-go-npm
LABEL maintainer="Corelight AWS Team <aws@corelight.com>"
LABEL description="Ubuntu-based builder including Go, NPM and Ruby tool FPM"

RUN apt-get update && apt-get -y install \
  build-essential \
  debhelper \
  gcc \
  git \
  make \
  rpm \
  ruby \
  ruby-dev \
  rubygems \
  sudo \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g create-react-app
# npm-run-all ?

RUN	go get -u github.com/GeertJohan/go.rice/rice && \
    go get -u github.com/golang/dep/cmd/dep

RUN gem install --no-ri --no-rdoc fpm

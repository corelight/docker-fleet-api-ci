FROM corelight/ubuntu-go-npm:v0.6
LABEL maintainer="Corelight AWS Team <aws@corelight.com>"
LABEL description="Ubuntu-based builder including Go, NPM and Ruby tool FPM"

RUN apt-get update && apt-get -y install \
  build-essential=12.4ubuntu1 \
  debhelper=11.1.6ubuntu2 \
  gcc=4:7.4.0-1ubuntu2.3 \
  git=1:2.17.1-1ubuntu0.5 \
  make=4.1-9.1ubuntu1 \
  rpm=4.14.1+dfsg1-2 \
  ruby=1:2.5.1 \
  ruby-dev=1:2.5.1 \
  sudo=1.8.21p2-3ubuntu1.1 \
  wget=1.19.4-1ubuntu2.2 \
  && rm -rf /var/lib/apt/lists/*

RUN . /root/.nvm/nvm.sh && \
    npm install -g create-react-app@3.3.0 && \
    npm install -g newman@4.5.7
# npm-run-all ?

RUN	GO111MODULE=on go get -u github.com/GeertJohan/go.rice/rice@v1.0.0 && \
    GO111MODULE=on go get -u github.com/mgechev/revive@v1.0.0 && \
    GO111MODULE=on go get -u github.com/swaggo/swag/cmd/swag@v1.6.3 && \
    rm -rf /root/go/pkg/*

RUN mkdir -p /tmp/swaggo && \
    cd /tmp/swaggo && \
    wget https://github.com/swaggo/swag/releases/download/v1.6.3/swag_1.6.3_Linux_x86_64.tar.gz && \
    tar xzvf swag_1.6.3_Linux_x86_64.tar.gz && \
    mv swag /root/go/bin/swag-prebuild

# Install the "swagger" command which is actually "go-swagger" on the web's
# and the generated we used to produce model structures from swagger spec
RUN curl -o /usr/local/bin/swagger -L "https://github.com/go-swagger/go-swagger/releases/download/v0.22.0/swagger_linux_amd64" && \
    chmod +x /usr/local/bin/swagger

RUN gem install -N fpm -v 1.11.0

ENV PATH=/root/go/bin:$PATH

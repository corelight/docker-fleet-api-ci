FROM corelight/ubuntu-go-npm:v0.9
LABEL maintainer="Corelight AWS Team <aws@corelight.com>"
LABEL description="Ubuntu-based builder including Go, NPM and Ruby tool FPM"

RUN apt-get update && apt-get -y install \
  build-essential \
  debhelper \
  gcc \
  git \
  make \
  python3 \
  python3-pip \
  rpm \
  ruby \
  ruby-dev \
  sudo \
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && \
    python2 get-pip.py && \
    /usr/local/bin/pip install --upgrade 'python-gitlab==1.15.0'; \
    rm get-pip.py

RUN . /root/.nvm/nvm.sh && \
    npm install -g create-react-app@3.3.0 && \
    npm install -g newman@4.5.7
# npm-run-all ?

# At last check, gocover-cobertura, go-licenses and stringer are not versioned
RUN GO111MODULE=on go get -u github.com/GeertJohan/go.rice/rice@v1.0.2 && \
    GO111MODULE=on go get -u github.com/mgechev/revive@v1.0.0 && \
    GO111MODULE=on go get -u github.com/swaggo/swag/cmd/swag@v1.6.3 && \
    GO111MODULE=on go get -u github.com/alvaroloes/enumer@v1.1.2 && \
    go get -u github.com/t-yuki/gocover-cobertura && \
    go get -u github.com/google/go-licenses && \
    go get -u golang.org/x/tools/cmd/stringer && \
    mv /root/go/pkg/mod/github.com/google/licenseclassifier* . && \
    rm -rf /root/go/pkg/* && \
    mkdir -p /root/go/pkg/mod/github.com/google/ && \
    mv licenseclassifier* /root/go/pkg/mod/github.com/google/

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

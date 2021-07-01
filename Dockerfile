FROM corelight/ubuntu-go-npm:v0.7
LABEL maintainer="Corelight AWS Team <aws@corelight.com>"
LABEL description="Ubuntu-based builder including Go, NPM and Ruby tool FPM"

RUN apt-get update && apt-get -y install \
  build-essential=12.4ubuntu1 \
  debhelper=11.1.6ubuntu2 \
  gcc=4:7.4.0-1ubuntu2.3 \
  git \
  make \
  python3 \
  python-pip \
  rpm=4.14.1+dfsg1-2 \
  ruby=1:2.5.1 \
  ruby-dev \
  sudo \
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade 'python-gitlab==1.15.0'

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

# Install postgresql and timescaledb
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql-12

RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:timescale/timescaledb-ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install timescaledb-postgresql-12

# Allow postgres db connections 
RUN sed -i '/local[ ]*all[ ]*all[ ]*peer/a host postgres postgres 0.0.0.0/0 trust' /etc/postgresql/12/main/pg_hba.conf

ENTRYPOINT service postgresql start && /bin/bash
# Expose the PostgreSQL port
EXPOSE 5432
ENV PATH=/root/go/bin:$PATH

FROM rocker/rstudio:latest

RUN apt-get update && apt-get install -y \
    fonts-ipaexfont \
    fonts-noto-cjk \
    libmagick++-dev \
    tk \
    locales \
    openssh-client \
    libxt-dev \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# ロケールとタイムゾーンの設定
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
RUN sed -i '$d' /etc/locale.gen \
    && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

COPY --chown=rstudio:rstudio /.rstudio/rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
COPY --chown=rstudio:rstudio /.vscode/_settings.json /home/rstudio/.vscode-server/data/Machine/settings.json

# R Package
RUN R -e "install.packages(c('renv', 'jsonlite', 'languageserver'))"

# Julia
ENV JULIA_MINOR_VERSION=1.10
ENV JULIA_PATCH_VERSION=0

RUN wget https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_MINOR_VERSION}/julia-${JULIA_MINOR_VERSION}.${JULIA_PATCH_VERSION}-linux-x86_64.tar.gz && \
    tar xvf julia-${JULIA_MINOR_VERSION}.${JULIA_PATCH_VERSION}-linux-x86_64.tar.gz && \
    rm julia-${JULIA_MINOR_VERSION}.${JULIA_PATCH_VERSION}-linux-x86_64.tar.gz && \
    ln -s $(pwd)/julia-$JULIA_MINOR_VERSION.$JULIA_PATCH_VERSION/bin/julia /usr/bin/julia

# DVC Path
ENV PATH $PATH:~/.pip/bin

RUN pip install ipykernel jupyter

RUN wget -O quarto.deb "https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.553/quarto-1.4.553-linux-amd64.deb" && \
    dpkg -i quarto.deb && \
    rm quarto.deb

# Package Cahce & Permission
RUN cd /home/rstudio && mkdir .pip .cache .cache/R .cache/R/renv .TinyTeX .julia && \
    chown rstudio:rstudio .pip .cache .cache/R .cache/R/renv .TinyTeX .julia

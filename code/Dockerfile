####################################################################################
# Set environment variables
####################################################################################
FROM ubuntu:22.04 AS base

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH=/opt/conda/bin:$PATH
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
ENV TZ=America/Denver

####################################################################################
# Install dependencies
####################################################################################
FROM base AS dependencies

RUN apt-get update --fix-missing && \
  apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    curl \
    git \
    apt-transport-https \
    software-properties-common \
    gnupg \
    ca-certificates && \
  wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
  add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" && \
  add-apt-repository universe && \
  apt-get update && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    r-base \
    r-base-dev \
    nano \
    vim \
    r-recommended \
    build-essential \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

####################################################################################
# Install R packages
####################################################################################
FROM dependencies AS r-packages

COPY install.R /
RUN Rscript /install.R

####################################################################################
# Install Python packages
####################################################################################
FROM r-packages AS python-env

RUN set -e && \
    echo "Detecting system architecture..." && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        echo "Architecture detected: x86_64" && \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" && \
        INSTALL_TF_CMD="conda install -y python=3.10 scikit-learn pandas tensorflow"; \
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
        echo "Architecture detected: $ARCH (ARM64)" && \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh" && \
        INSTALL_TF_CMD="conda install --debug -y python=3.10 scikit-learn pandas && pip install tensorflow-aarch64"; \
    else \
        echo "ERROR: Unsupported architecture: $ARCH" && \
        exit 1; \
    fi && \
    echo "Downloading Miniconda from $MINICONDA_URL..." && \
    wget --quiet $MINICONDA_URL -O ~/miniconda.sh || { echo "ERROR: Failed to download Miniconda"; exit 1; } && \
    echo "Installing Miniconda..." && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda || { echo "ERROR: Failed to install Miniconda"; exit 1; } && \
    rm ~/miniconda.sh && \
    echo "Cleaning Conda installation..." && \
    /opt/conda/bin/conda clean -t -i -p -y && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    /opt/conda/bin/conda config --add channels conda-forge && \
    echo "Installing Python packages..." && \
    eval $INSTALL_TF_CMD && \
    echo "Python environment setup complete."

####################################################################################
# Install Confounded within the image
####################################################################################
FROM python-env AS confounded-install

RUN cd /tmp && \
    git clone https://github.com/prestonraab/Confounded.git && \
    mkdir /confounded && \
    mv /tmp/Confounded/confounded /confounded && \
    mv /tmp/Confounded/data /confounded && \
    rm -rf /tmp/Confounded && \
    echo '#!/bin/bash\ncd /confounded\npython -m confounded "$@"' > /usr/bin/confounded && \
    chmod +x /usr/bin/confounded && \
    chmod 777 /confounded -R && \
    echo "Done importing Confounded code"

####################################################################################
# Copy files into the image
####################################################################################
FROM confounded-install AS final

COPY prepdata /prepdata
COPY adjust /adjust
COPY metrics /metrics
COPY figures /figures
COPY all.sh /

#ENTRYPOINT ["/all.sh"]

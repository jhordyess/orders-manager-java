FROM tomcat:8.5-jdk8-openjdk

# Define arguments
ARG USER_NAME=jhordyess
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG TEX_PATH=/opt/tinytex

# Update and com.microsoft.playwright dependencies
RUN apt-get update --no-install-recommends \
  && apt-get upgrade -y \
  && apt-get autoremove --purge -y \
  && apt-get install -y sudo wget \
  && apt-get install -y libglib2.0-0 \
  libnss3 \
  libnspr4 \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libcups2 \
  libdrm2 \
  libdbus-1-3 \
  libxcb1 \
  libxkbcommon0 \
  libx11-6 \
  libxcomposite1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxrandr2 \
  libgbm1 \
  libpango-1.0-0 \
  libcairo2 \
  libasound2 \
  libatspi2.0-0 \
  libwayland-client0

# User configuration
RUN groupadd --gid $USER_GID $USER_NAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USER_NAME \
  && echo $USER_NAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER_NAME \
  && chmod 0440 /etc/sudoers.d/$USER_NAME

# TinyTeX installation
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh -s - --admin --no-path \
  && ~/bin/tlmgr install multirow varwidth standalone colortbl \
  && mkdir ${TEX_PATH} \
  && mv ~/.TinyTeX/* ${TEX_PATH} \
  && ${TEX_PATH}/bin/*/tlmgr path add
ENV PATH="${PATH}:${TEX_PATH}/bin/x86_64-linux"

# Install Maven
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz \
  && tar -xvf apache-maven-3.9.1-bin.tar.gz \
  && rm -r apache-maven-3.9.1-bin.tar.gz \
  && mv apache-maven-3.9.1 /opt/
ENV PATH="${PATH}:/opt/apache-maven-3.9.1/bin"

# Switch to non-root user
USER ${USER_NAME}
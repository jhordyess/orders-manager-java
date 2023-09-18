# Dockerfile for development purposes in VSCode
# Image: Tomcat 8.5 with JDK 8, Maven 3.9.4, and TinyTeX; default user: jhordyess
# All sources were reviewed on September 13, 2023

FROM tomcat:8.5-jdk8-openjdk

# Define arguments for user configuration and TinyTeX installation
ARG USER_NAME=jhordyess
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG TEX_PATH=/opt/tinytex

# Copy the ROOT.xml file in order to change the default context path
COPY ROOT.xml ${CATALINA_HOME}/conf/Catalina/localhost/

# Update and install dependencies
RUN apt-get update --no-install-recommends && \
  apt-get upgrade -y && \
  apt-get autoremove --purge -y && \
  apt-get install -y sudo wget && \
  # Install Oh My Zsh dependencies
  apt-get install -y zsh && \
  # Install com.microsoft.playwright dependencies
  apt-get install -y libglib2.0-0 \
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

# Add a non-root user and grant sudo privileges
# Source: https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user#_creating-a-nonroot-user
RUN groupadd --gid $USER_GID $USER_NAME && \
  useradd --uid $USER_UID --gid $USER_GID -m $USER_NAME && \
  echo $USER_NAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER_NAME && \
  chmod 0440 /etc/sudoers.d/$USER_NAME

# Install TinyTeX
# Source: https://yihui.org/tinytex/#installation
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh && \
  # Install LaTeX packages for the app
  ~/bin/tlmgr install multirow varwidth standalone colortbl && \
  # Move TinyTeX to a global path and add it to the PATH
  mv -T ~/.TinyTeX ${TEX_PATH} && \
  ${TEX_PATH}/bin/*/tlmgr path add
ENV PATH="${PATH}:${TEX_PATH}/bin/x86_64-linux"

# Install Maven 3.9.4, for new versions see: https://maven.apache.org/download.cgi
# Source: https://maven.apache.org/install.html
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz && \
  # Unzip and remove the tar file
  tar -xzvf apache-maven-3.9.4-bin.tar.gz -C /opt/ && \
  rm apache-maven-3.9.4-bin.tar.gz
ENV PATH="${PATH}:/opt/apache-maven-3.9.4/bin"

# Switch to the non-root user
USER ${USER_NAME}

# Install Zsh and plugins
# Source: https://github.com/deluan/zsh-in-docker#examples
RUN sh -c "$(curl -L https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
  -p git \
  -p https://github.com/zsh-users/zsh-syntax-highlighting \
  -p https://github.com/zsh-users/zsh-autosuggestions

# Set the default working directory
WORKDIR /home/${USER_NAME}
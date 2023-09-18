# Dockerfile for testing purposes, maybe need some changes to be used in a real production environment
# Images: Maven 3.9.4 with OpenJDK 8 and Tomcat 8.5 with OpenJDK 8
# All sources were reviewed on September 13, 2023

FROM maven:3.9.4-eclipse-temurin-8-alpine as build

# Set the working directory
WORKDIR /app

# Copy the app source code
COPY src src/
COPY pom.xml ./

# Build the app
RUN mvn clean package


FROM tomcat:8.5-jdk8-openjdk

# Define arguments for TinyTeX installation and the app name
ARG TEX_PATH=/opt/tinytex
ARG FINAL_NAME="orders-manager" #? Same as <finalName> in pom.xml

# Update and install dependencies
RUN apt-get update --no-install-recommends && \
  apt-get upgrade -y && \
  apt-get autoremove --purge -y && \
  apt-get install -y wget && \
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

# Copy the built project to Tomcat webapps ROOT
COPY --from=build /app/target/${FINAL_NAME} /usr/local/tomcat/webapps/ROOT/

# Install TinyTeX
# Source: https://yihui.org/tinytex/#installation
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh && \
  # Install LaTeX packages for the app
  ~/bin/tlmgr install multirow varwidth standalone colortbl && \
  # Move TinyTeX to a global path and add it to the PATH
  mv -T ~/.TinyTeX ${TEX_PATH} && \
  ${TEX_PATH}/bin/*/tlmgr path add && \
  ln -s ${TEX_PATH}/bin/x86_64-linux/pdflatex /usr/local/bin/pdflatex

# Start Tomcat
CMD ["catalina.sh", "run"]
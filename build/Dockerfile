FROM maven:3.8.6-openjdk-8-slim as build
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get autoremove --purge -y
WORKDIR /app
COPY ./src ./src
COPY ./pom.xml ./
RUN mvn clean package
#
FROM tomcat:8.5-jdk8-openjdk
ARG TEX_PATH=/opt/tinytex
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get autoremove --purge -y
COPY --from=build /app/target/orders-manager.war /usr/local/tomcat/webapps/ROOT.war
# LaTeX
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh -s - --admin --no-path
RUN ~/bin/tlmgr install multirow varwidth standalone colortbl \
  && mkdir ${TEX_PATH} \
  && mv ~/.TinyTeX/* ${TEX_PATH} \
  && ${TEX_PATH}/bin/*/tlmgr path add
RUN ln -s ${TEX_PATH}/bin/x86_64-linux/pdflatex /usr/local/bin/pdflatex
# com.microsoft.playwright dependences
RUN apt-get install -y libglib2.0-0 \
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
CMD ["catalina.sh", "run"]
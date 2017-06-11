FROM r-base:latest

MAINTAINER Tom Purucker "purucker.tom@gmail.com"

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    libssl-dev

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

RUN R -e "install.packages(c('shiny','rmarkdown','plyr','leaflet','reshape2','tidyr','rpivotTable','dplyr','jsonlite','rgdal','RJSONIO','tibble','stringr','sp','maps','maptools','geojsonio','ggplot2','shinydashboard','rjson','dataRetrieval','rmapshaper','DT','xlsx'),repos='http://cran.rstudio.com/')"


COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY /wq_screen /srv/shiny-server/

EXPOSE 80

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
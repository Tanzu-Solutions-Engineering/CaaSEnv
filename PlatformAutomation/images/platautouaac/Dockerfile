FROM platauto:4.3.0
RUN apt-get -y update && apt-get install -y jq ruby-full software-properties-common && gem install cf-uaac
RUN add-apt-repository ppa:rmescandon/yq && apt-get -y update && apt-get install yq -y

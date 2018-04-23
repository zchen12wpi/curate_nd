# Builds a docker image to run hydra jetty (Fedora 3.6.2 and Solr 4.0.0) for Curate
FROM java:8-jre

RUN wget https://github.com/ndlib/hydra-jetty/archive/xacml-updates-for-curate-with-solr-updates.zip
RUN unzip -d . -qo xacml-updates-for-curate-with-solr-updates.zip

RUN rm xacml-updates-for-curate-with-solr-updates.zip
COPY config/jetty.yml /hydra-jetty-xacml-updates-for-curate-with-solr-updates

ENV JETTY_HOME /hydra-jetty-xacml-updates-for-curate-with-solr-updates
WORKDIR /hydra-jetty-xacml-updates-for-curate-with-solr-updates
ENTRYPOINT java -Djetty.port=8983 -Dsolr.solr.home=/hydra-jetty-xacml-updates-for-curate-with-solr-updates/solr -XX:+CMSPermGenSweepingEnabled -XX:+CMSClassUnloadingEnabled -XX:PermSize=64M -XX:MaxPermSize=128M -jar /hydra-jetty-xacml-updates-for-curate-with-solr-updates/start.jar

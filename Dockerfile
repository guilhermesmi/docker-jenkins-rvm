FROM jenkins:latest

USER root


# Install Ruby prerequisistes for Nokogiri and Capybara-Webkit
RUN apt-get update
RUN apt-get install nodejs postgresql build-essential patch ruby-dev zlib1g-dev \
 		liblzma-dev qt5-default libqt5webkit5-dev sudo \
 		gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x -y
# Install RVM into the container
VOLUME ["/root/.ssh"]
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \curl -sSL https://get.rvm.io | bash -s stable

# Setup Jenkins to use rvm-shell by default
ADD ./hudson.tasks.Shell.xml /usr/share/jenkins/ref/hudson.tasks.Shell.xml

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
# Remove jenkins user it only complicates setup in docker
RUN deluser jenkins

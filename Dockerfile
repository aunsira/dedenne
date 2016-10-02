FROM ruby:2.2.1

RUN echo deb http://ftp.uk.debian.org/debian jessie-backports main \
                  >>/etc/apt/sources.list
RUN apt-get update

# Install packages for building ruby
RUN apt-get update && \
    apt-get install -y ffmpeg

# Install gems
ENV APP_HOME /root/code/git/dedenne
ENV HOME /root
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME/
RUN bundle install

# Upload source
COPY . $APP_HOME

EXPOSE 4567
CMD ["ruby", "bin/app.rb", "-p", "4567"]

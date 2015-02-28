FROM ruby:2.2.0

RUN apt-get update -qq && apt-get install -y build-essential

# Phantom JS
RUN apt-get install -y wget parallel ruby ruby-dev fontconfig

RUN mkdir drivers
RUN wget -q -P drivers https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.0.0-source.zip
RUN tar -C drivers -xjf /drivers/phantomjs-1.9.7-linux-x86_64.tar.bz2
RUN rm -Rf /drivers/phantomjs-1.9.7-linux-x86_64.tar.bz2
RUN ln -s /drivers/phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/bin/phantomjs
RUN chmod 755 /usr/bin/phantomjs

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# Install nodejs
RUN apt-get install -qq -y nodejs


# Install Nginx.
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install -qq -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx
# Add default nginx config
ADD nginx-sites.conf /etc/nginx/sites-enabled/default

# Install Rails App
WORKDIR /app
ONBUILD ADD Gemfile /app/Gemfile
ONBUILD ADD Gemfile.lock /app/Gemfile.lock
ONBUILD RUN bundle install --without development test
ONBUILD ADD . /app

# Add default unicorn config
ADD unicorn.rb /app/config/unicorn.rb

# Add default foreman config
ADD Procfile /app/Procfile

ENV RAILS_ENV production

CMD bundle exec rake assets:precompile && foreman start -f Procfile
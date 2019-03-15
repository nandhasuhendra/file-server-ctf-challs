FROM ruby:2.5.1

RUN apt-get update \
    && apt-get install -qq -y build-essential --fix-missing --no-install-recommends 

RUN gem install rubyzip activesupport nokogiri

RUN mkdir -p challenge
WORKDIR challenge

COPY server .
COPY /storage/flag.txt /tmp/

RUN chmod 444 /tmp/flag.txt

CMD ["./start.sh", ">", "/dev/null", "&"]
EXPOSE 31337

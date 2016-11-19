# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM kdelfour/cloud9-docker
MAINTAINER Toby Hinloopen <toby@kutcomputers.nl>

# Setup locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Get wget
RUN apt-get update
RUN apt-get install -y wget

# Install Erlang
RUN wget http://packages.erlang-solutions.com/site/esl/esl-erlang/FLAVOUR_1_general/esl-erlang_18.3-1~ubuntu~trusty_amd64.deb
RUN dpkg -i esl-erlang_18.3-1~ubuntu~trusty_amd64.deb || :
RUN apt-get install -yf
RUN rm esl-erlang_18.3-1~ubuntu~trusty_amd64.deb

# Install Elixir
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install elixir
RUN rm erlang-solutions_1.0_all.deb
RUN mix local.hex --force
RUN mix local.rebar --force

# Install Postgresql
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-9.4
RUN /etc/init.d/postgresql start && sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password 'postgres';"

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 4000

# vim:set ft=dockerfile:
FROM tenna/ubuntu:latest 

RUN set -ex; \
	if ! command -v gpg > /dev/null; then \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			gnupg \
			dirmngr lsb-release \
		; \
		rm -rf /var/lib/apt/lists/*; \
	fi

ENV TZ 'America/New_York'
RUN export DEBIAN_FRONTEND=noninteractive && \
    echo $TZ > /etc/timezone && \
    apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata 


RUN export DEBIAN_FRONTEND=noninteractive && \
               apt-get -y install postgresql



ENV PATH $PATH:/usr/lib/postgresql/$PG_MAJOR/bin
ENV PGDATA /var/lib/postgresql/data

RUN mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA"


COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

RUN apt-get clean

EXPOSE 5432
CMD ["postgres"]
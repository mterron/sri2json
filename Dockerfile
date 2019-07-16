FROM alpine
RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk add --no-cache curl mawk@edge jq git postgresql-client tzdata \
	&& ln -sf /usr/bin/mawk /usr/bin/awk \
	&& mkdir -p -m 777 /sri
COPY sri2json.sh /usr/local/bin/
COPY sri_json2postgresql.sh /usr/local/bin/
COPY SRI_to_dtrack.sh /usr/local/bin
USER daemon
ENTRYPOINT ["SRI_to_dtrack.sh"]

# For the subsequent works, the following is to be executed once on the Dockerhost:
# docker run --rm --privileged -v /:/host solita/ubuntu-systemd setup
FROM	solita/ubuntu-systemd

ENV	DEFAULTDOMAIN="domain.de"
ENV	NAMESERVER="172.0.0.1"

# NIS + /export/home
RUN	apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nis network-manager

RUN	echo "$DEFAULTDOMAIN" > /etc/defaultdomain \
	&& echo "ypserver $NAMESERVER" >> /etc/yp.conf \
	&& echo "rpcbind: 127.0.0.1" >> /etc/hosts.allow \
	&& echo "+::::::" >> /etc/passwd \
	&& echo "+:::" >> /etc/group \
	&& echo "+::::::::" >> /etc/shadow

COPY    content/etc/* /etc/
COPY    content/init.d/* /etc/init.d/
RUN	update-rc.d latest defaults
RUN	mv /etc/rc5.d/S01latest /etc/rc5.d/S02latest \
	&& mv /etc/rc4.d/S01latest /etc/rc4.d/S02latest \
	&& mv /etc/rc3.d/S01latest /etc/rc3.d/S02latest \
	&& mv /etc/rc2.d/S01latest /etc/rc2.d/S02latest

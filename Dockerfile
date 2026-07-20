FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y ubuntu-gnome-desktop && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    xrdp \
    curl \
	dbus-x11 \
    wget \
    vim \
    net-tools
    
# Set root password
RUN echo "root:Gcet@321" | chpasswd

RUN sed -i 's/^allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config || echo "allowed_users=anybody" >> /etc/X11/Xwrapper.config

# Generate machine-id for dbus
RUN mkdir -p /var/run/dbus && dbus-uuidgen > /var/lib/dbus/machine-id

RUN sed -i 's/crypt_level=high/crypt_level=low/' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/' /etc/xrdp/xrdp.ini
    

RUN adduser xrdp ssl-cert

COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose the standard RDP port
EXPOSE 3389

# Copy supervisor configuration file into the container
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start Supervisor to manage backend processes
CMD ["/start.sh"]

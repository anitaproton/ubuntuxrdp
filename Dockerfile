FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y lubuntu-desktop && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    xrdp \
    curl \
	dbus-x11 \
    wget \
    vim \
    net-tools \
	openssh-server
	
    
# Set root password
RUN echo "root:Gcet@321" | chpasswd

RUN sed -i 's/^allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config || echo "allowed_users=anybody" >> /etc/X11/Xwrapper.config

# Generate machine-id for dbus
RUN mkdir -p /var/run/dbus && dbus-uuidgen > /var/lib/dbus/machine-id

# Create the sshd runtime directory required by the daemon
RUN mkdir /var/run/sshd

RUN sed -i 's/crypt_level=high/crypt_level=low/' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/' /etc/xrdp/xrdp.ini
    

RUN adduser xrdp ssl-cert

# Install code-server via the official installation script
RUN curl -fsSL https://code-server.dev/install.sh | sh

COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose the standard RDP port, omniroute, ollama ssh https and http
EXPOSE 20128 20129 11434 3389 443 80 22 

# Copy supervisor configuration file into the container
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start Supervisor to manage backend processes
CMD ["/start.sh"]

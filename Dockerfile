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
    wget \
    vim \
    net-tools
    
# Set root password
RUN echo "root:root" | chpasswd

COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose the standard RDP port
EXPOSE 3389

# Copy supervisor configuration file into the container
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start Supervisor to manage backend processes
CMD ["/start.sh"]

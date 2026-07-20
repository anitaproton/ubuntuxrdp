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
    supervisor \
    x11-xserver-utils \
    wget \
    vim \
    net-tools
    

# Configure XRDP to use the ssl-cert group
RUN adduser xrdp ssl-cert
# Set up the default user (Username: developer, Password: password)
# You can change these values as needed
RUN useradd -m -s /bin/bash developer && \
    usermod -aG sudo developer \
    echo "developer:gcet1234" | chpasswd 

RUN apt-get update && \
    apt-get install -y sudo && \
    mkdir -p /etc/sudoers.d && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer

	
# Configure the GNOME session specifically for XRDP connections
RUN echo "export GNOME_SHELL_SESSION_MODE=developer" > /home/developer/.xsessionrc && \
    echo "export XDG_CURRENT_DESKTOP=GNOME:developer:GNOME" >> /home/developer/.xsessionrc && \
    echo "export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg" >> /home/developer/.xsessionrc && \
    echo "gnome-session" > /home/developer/.xsession && \
    chown developer:developer /home/developer/.xsessionrc /home/developer/.xsession

# Expose the standard RDP port
EXPOSE 3389

# Copy supervisor configuration file into the container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start Supervisor to manage backend processes
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

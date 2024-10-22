# Use the latest Ubuntu Server image
FROM ubuntu:24.10

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install required packages
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xorg \
    dbus-x11 \
    xauth \
    xkb-data \
    chromium \
    python3 \
    python3-venv \
    python3-pip \
    tigervnc-standalone-server \
    tigervnc-common \
    openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the password for VNC
RUN mkdir -p /root/.vnc && \
    echo "shishkabob" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Set the root password
RUN echo 'root:shishkabob' | chpasswd

# Create Xauthority file to avoid warnings
RUN touch /root/.Xauthority

# Create a virtual environment and install latest pip and setuptools
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip setuptools wheel

# Add a script to start the VNC server and XFCE
COPY start-vnc.sh /start-vnc.sh
RUN chmod +x /start-vnc.sh

# Expose the VNC and SSH ports
EXPOSE 5901 22

# Default command to start VNC server and XFCE
CMD ["/start-vnc.sh"]

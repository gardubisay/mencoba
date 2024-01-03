FROM ubuntu:latest

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y locales python3-pip ssh wget unzip && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN pip3 install flask flask_restful

ENV PORT 8080
ENV LANG en_US.utf8
ARG NGROK_TOKEN
ENV NGROK_TOKEN=${NGROK_TOKEN}

WORKDIR /

# Download and install ngrok
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    unzip ngrok.zip && \
    rm ngrok.zip

# Create daxx.sh script
RUN echo "#!/bin/bash" >> /daxx.sh && \
    echo "./ngrok config add-authtoken ${NGROK_TOKEN}" >> /daxx.sh && \
    echo "./ngrok tcp 22 &>/dev/null &" >> /daxx.sh && \
    echo "/usr/sbin/sshd -D" >> /daxx.sh

# SSH configurations
RUN mkdir /run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'root:mamacantik10' | chpasswd

# Expose necessary ports
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306

# Start services in CMD
CMD ["bash", "-c", "python3 clever.py && /daxx.sh"]

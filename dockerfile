# Dockerfile to enable ssh remote
FROM ubuntu:22.04

# Install ssh service
RUN apt-get update && apt-get install -y openssh-server

# Configuration
RUN mkdir /var/run/sshd
RUN echo 'root:mypassword' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
EXPOSE 22

# Enable auto start command
CMD ["/usr/sbin/sshd", "-D"]

# To run
# docker build -t image_name .
# docker run -d -P --name my_ssh_container image_name
# docker port my_ssh_container
# ssh -p PORT root@localhost
# docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my_ssh_container
# or can remote from other container: ssh root@my_ssh_container_ip

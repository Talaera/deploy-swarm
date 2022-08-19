FROM docker:stable

LABEL "name"="Docker Connect Through SSH JumpHost."

LABEL "com.github.actions.name"="Docker Connect Through SSH JumpHost"
LABEL "com.github.actions.description"="Connect to the Docker daemon through SSH jumphost."

RUN apk --no-cache add openssh-client

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
RUN sudo apt-get update
RUN sudo apt-get install docker-ce

COPY entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
COPY config /etc/ssh/ssh_config

ENTRYPOINT ["/entrypoint.sh"]

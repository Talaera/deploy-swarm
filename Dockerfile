FROM docker:stable

LABEL "name"="Docker Connect Through SSH JumpHost."

LABEL "com.github.actions.name"="Docker Connect Through SSH JumpHost"
LABEL "com.github.actions.description"="Connect to the Docker daemon through SSH jumphost."

RUN apk --no-cache add openssh-client

COPY entrypoint.sh /entrypoint.sh
COPY config ~/.ssh/config

ENTRYPOINT ["/entrypoint.sh"]

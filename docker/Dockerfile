FROM alpine:3.9
LABEL maintainer="Gianluca Boiano <morf3089@gmail.com>"

COPY resources /
RUN /docker-entrypoint.sh

# Expose raspberry ssh port mapped on 2222 by qemu
EXPOSE 2222
EXPOSE 5683/udp
EXPOSE 5684/udp
EXPOSE 56830/udp
EXPOSE 8080
CMD ["simonpi", "-h"]

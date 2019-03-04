FROM alpine:3.9
LABEL maintainer="Gianluca Boiano <morf3089@gmail.com>"

COPY resources /
RUN /docker-entrypoint.sh

# Expose raspberry ssh port mapped on 2222 by qemu
EXPOSE 2222
EXPOSE 5683
EXPOSE 5684
EXPOSE 56830
EXPOSE 8080
CMD ["simonpi", "-h"]

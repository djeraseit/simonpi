FROM base/archlinux:latest
LABEL maintainer="Gianluca Boiano <morf3089@gmail.com>"
ENV ROOT_PASSWORD=root

COPY resources /
RUN  /docker-entrypoint.sh

# Expose raspberry ssh port mapped on 2222 by qemu
EXPOSE 2222:22
#RUN ["simonpi", "rpi-3", "-s", "2"]
CMD ["simonpi", "rpi-3", "-r"]

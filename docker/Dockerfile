FROM base/archlinux:latest
LABEL maintainer="Gianluca Boiano <morf3089@gmail.com>"

COPY resources /
RUN  /docker-entrypoint.sh

VOLUME ["/root/.simonpi:/root/.simonpi"]
# Expose raspberry ssh port mapped on 2222 by qemu
EXPOSE 2222
#RUN ["simonpi", "rpi-3", "-s", "2"]
CMD ["simonpi", "rpi-3", "-r"]

FROM ubuntu:20.04

LABEL Description="RTEMS Builder"
ARG UID=1000
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get install -yy \
	build-essential \
	gcc \
	g++ \
	gdb \
	git \
	unzip \
	pax \
	bison \
	flex \
	texinfo \
	unzip \
	python3-dev \
	libncurses5-dev \
	zlib1g-dev \
	python-dev \
	curl \
	locales \
	qemu-system-x86 \
	&& apt-get clean all

RUN useradd --create-home --uid ${UID} builder
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
USER builder
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

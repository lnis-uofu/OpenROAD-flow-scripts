FROM debian:testing AS base
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
	apt-get install -y --no-install-recommends \
	time \
	libreadline8 \
	libboost-atomic1.74.0 \
	libboost-chrono1.74.0 \
	libboost-container1.74.0 \
	libboost-context1.74.0 \
	libboost-contract1.74.0 \
	libboost-coroutine1.74.0 \
	libboost-date-time1.74.0 \
	libboost-fiber1.74.0 \
	libboost-filesystem1.74.0 \
	libboost-graph-parallel1.74.0 \
	libboost-graph1.74.0 \
	libboost-iostreams1.74.0 \
	libboost-locale1.74.0 \
	libboost-log1.74.0 \
	libboost-math1.74.0 \
	libboost-mpi-python1.74.0 \
	libboost-mpi1.74.0 \
	libboost-nowide1.74.0 \
	libboost-numpy1.74.0 \
	libboost-program-options1.74.0 \
	libboost-python1.74.0 \
	libboost-random1.74.0 \
	libboost-regex1.74.0 \
	libboost-serialization1.74.0 \
	libboost-stacktrace1.74.0 \
	libboost-system1.74.0 \
	libboost-test1.74.0 \
	libboost-thread1.74.0 \
	libboost-timer1.74.0 \
	libboost-type-erasure1.74.0 \
	libboost-wave1.74.0 \
	libtcl8.6 \
	liblemon1.3.1 \
	libeigen3-dev \
	libspdlog1 \
	libffi7 \
	graphviz \
	xdot \
	libqt5gui5 \
	libpcre3 \
	wget \
	libqt5designer5 \
	libqt5multimedia5 \
	libqt5multimediawidgets5 \
	libqt5opengl5 \
	libqt5printsupport5 \
	libqt5sql5 \
	libqt5svg5 \
	libqt5widgets5 \
	libqt5xml5 \
	libqt5xmlpatterns5 \
	libruby2.7 \
	ca-certificates \
        python3 \
	libpython3.9 \
	make
RUN wget https://www.klayout.org/downloads/Ubuntu-20/klayout_0.26.9-1_amd64.deb
RUN dpkg --ignore-depends=libpython3.8 -i klayout_0.26.9-1_amd64.deb && \
	rm ./klayout_0.26.9-1_amd64.deb
RUN apt -y clean

FROM base as install
RUN mkdir -p /OpenROAD-flow/tools/build
WORKDIR /OpenROAD-flow
COPY --from=openroad/debian-openroad /OpenROAD /OpenROAD-flow/tools/build/OpenROAD
COPY --from=openroad/debian-yosys /yosys ./tools/build/yosys
COPY --from=openroad/debian-lsoracle /LSOracle ./tools/build/LSOracle
COPY --from=openroad/debian-lsoracle-plugin /LSOracle-plugin/oracle.so ./tools/build/yosys/plugins/oracle.so
COPY --from=openroad/debian-lsoracle /LSOracle/build/lib/kahypar/lib/libkahypar.so /usr/lib/x86_64-linux-gnu/
COPY ./setup_env.sh .
COPY ./flow ./flow
RUN chmod o+rw -R /OpenROAD-flow/flow
ENV OPENROAD=/OpenROAD-flow/tools/OpenROAD
ENV PATH="/OpenROAD-flow/tools/build/OpenROAD/build/src:/OpenROAD-flow/tools/build/TritonRoute:/OpenROAD-flow/tools/build/LSOracle/build/core:/OpenROAD-flow/tools/build/yosys:${PATH}"
RUN mkdir /core && ln -s /OpenROAD-flow/tools/build/LSOracle/core/test.ini /core/test.ini

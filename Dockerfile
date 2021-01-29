FROM openroad/ubuntu-openroad
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y --no-install-recommends time libreadline8 libboost-all-dev wget
RUN wget https://www.klayout.org/downloads/Ubuntu-20/klayout_0.26.9-1_amd64.deb && apt install -y ./klayout_0.26.9-1_amd64.deb
WORKDIR /OpenROAD-flow
RUN mkdir -p /OpenROAD-flow
RUN mkdir -p /OpenROAD-flow/tools/build
RUN mv /OpenROAD /OpenROAD-flow/tools/build/OpenROAD
COPY --from=openroad/ubuntu-yosys /yosys ./tools/build/yosys
COPY --from=openroad/ubuntu-lsoracle /LSOracle ./tools/build/LSOracle
COPY --from=openroad/ubuntu-lsoracle-plugin /LSOracle-plugin/oracle.so ./tools/build/yosys/plugins/oracle.so
COPY ./setup_env.sh .
COPY ./flow ./flow
RUN chmod o+rw -R /OpenROAD-flow/flow
ENV OPENROAD=/OpenROAD-flow/tools/OpenROAD
ENV PATH="/OpenROAD-flow/tools/build/OpenROAD/build/src:/OpenROAD-flow/tools/build/TritonRoute:/OpenROAD-flow/tools/build/LSOracle/build/core:/OpenROAD-flow/tools/build/yosys:${PATH}"
RUN cp /OpenROAD-flow/tools/build/LSOracle/build/lib/kahypar/lib/libkahypar.so /usr/lib/x86_64-linux-gnu/
RUN mkdir /core && ln -s /OpenROAD-flow/tools/build/LSOracle/core/test.ini /core/test.ini

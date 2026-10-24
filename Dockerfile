# ErrBits SystemC image — used by Codespaces (learner) and the grader.
# ghcr.io/errbits/systemc:2.3.3
FROM ubuntu:24.04 AS build

ARG SYSTEMC_VERSION=2.3.3
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential cmake ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://github.com/accellera-official/systemc/archive/refs/tags/${SYSTEMC_VERSION}.tar.gz \
      | tar -xz -C /tmp \
 && cmake -S /tmp/systemc-${SYSTEMC_VERSION} -B /tmp/build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_CXX_STANDARD=17 \
      -DCMAKE_INSTALL_PREFIX=/opt/systemc \
      -DBUILD_SOURCE_DOCUMENTATION=OFF \
 && cmake --build /tmp/build -j"$(nproc)" \
 && cmake --install /tmp/build \
 && rm -rf /opt/systemc/share/doc

FROM ubuntu:24.04

LABEL org.opencontainers.image.source="https://github.com/errbits/systemc-image" \
      org.opencontainers.image.description="SystemC 2.3.3 (C++17) toolchain for ErrBits labs" \
      org.opencontainers.image.licenses="Apache-2.0"

RUN apt-get update && apt-get install -y --no-install-recommends \
      g++ make gdb git ca-certificates less nano \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/systemc /opt/systemc

ENV SYSTEMC_HOME=/opt/systemc \
    LD_LIBRARY_PATH=/opt/systemc/lib \
    SC_COPYRIGHT_MESSAGE=DISABLE

# Smoke test: compile, link and run a zero-time simulation
RUN printf '#include <systemc>\nint sc_main(int, char*[]) { sc_core::sc_start(sc_core::SC_ZERO_TIME); std::cout << sc_core::sc_version() << std::endl; return 0; }\n' > /tmp/t.cpp \
 && g++ -std=c++17 -I/opt/systemc/include /tmp/t.cpp -L/opt/systemc/lib -lsystemc -o /tmp/t \
 && /tmp/t | grep -q 2.3.3 \
 && rm -f /tmp/t /tmp/t.cpp

WORKDIR /workspace

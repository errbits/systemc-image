# ErrBits SystemC image

SystemC **2.3.3** (C++17) toolchain used by ErrBits labs — the same image runs in your
Codespace and in the grader, so code that builds for you builds for us.

```
docker pull ghcr.io/errbits/systemc:2.3.3
```

| Path | |
|---|---|
| `/opt/systemc/include` | headers |
| `/opt/systemc/lib` | `libsystemc.so` |
| `SYSTEMC_HOME` | `/opt/systemc` |

Platforms: `linux/amd64`, `linux/arm64`. Built with `-DCMAKE_CXX_STANDARD=17` —
compile your code with `-std=c++17` too.

SystemC is © Accellera Systems Initiative, Apache-2.0.

# sysnet

## Build

### Native build
```bash
cmake -B build
cmake --build build
```
### Cross-compile

```bash
rm -rf build
cmake -B build -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/example-toolchain.cmake
cmake --build build
```
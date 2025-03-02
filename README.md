# PhantomJS docker builder

A Dockerfile to build PhantomJS 2.1.1 binaries on Debian Stretch for both amd64 and arm64.

The resulting binaries use the following shared libraries (all present by default on most distros except for libfontconfig)
```
$ ldd /usr/local/bin/phantomjs
	linux-vdso.so.1 (0x0000ffff9b15f000)
	libz.so.1 => /lib/aarch64-linux-gnu/libz.so.1 (0x0000ffff96b14000)
	libfontconfig.so.1 => /usr/lib/aarch64-linux-gnu/libfontconfig.so.1 (0x0000ffff96acd000)
	libfreetype.so.6 => /usr/lib/aarch64-linux-gnu/libfreetype.so.6 (0x0000ffff96a2c000)
	libdl.so.2 => /lib/aarch64-linux-gnu/libdl.so.2 (0x0000ffff96a19000)
	librt.so.1 => /lib/aarch64-linux-gnu/librt.so.1 (0x0000ffff96a02000)
	libpthread.so.0 => /lib/aarch64-linux-gnu/libpthread.so.0 (0x0000ffff969d6000)
	libstdc++.so.6 => /usr/lib/aarch64-linux-gnu/libstdc++.so.6 (0x0000ffff96845000)
	libm.so.6 => /lib/aarch64-linux-gnu/libm.so.6 (0x0000ffff9679a000)
	libgcc_s.so.1 => /lib/aarch64-linux-gnu/libgcc_s.so.1 (0x0000ffff96778000)
	libc.so.6 => /lib/aarch64-linux-gnu/libc.so.6 (0x0000ffff9662e000)
	/lib/ld-linux-aarch64.so.1 (0x0000ffff9b135000)
	libexpat.so.1 => /lib/aarch64-linux-gnu/libexpat.so.1 (0x0000ffff965f9000)
	libpng16.so.16 => /usr/lib/aarch64-linux-gnu/libpng16.so.16 (0x0000ffff965bd000)
```

### Using

To use the binary in another Dockerfile:
```Dockerfile
FROM debian
RUN apt-get update && apt-get install -y libfontconfig
COPY --from=ghcr.io/curefit/phantomjs-docker:latest /usr/bin/phantomjs /usr/bin/phantomjs
```

### Building

For a multi-arch build
```
docker buildx build --tag ghcr.io/curefit/phantomjs-docker:latest --platform linux/amd64,linux/arm64 --push .
```

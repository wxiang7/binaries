#!/bin/sh

# NB: The custom bison we set up here works around OSX Yosemite having
# bison 2.3 which is too old for the thrift 0.9.2 configure script.
curl -O http://ftp.gnu.org/gnu/bison/bison-2.5.1.tar.gz && \
rm -rf bison-2.5.1 && \
tar -xzf bison-2.5.1.tar.gz && (
  cd bison-2.5.1 && \
  sh ./configure --prefix=$(pwd -P)/install && \
  make install
)

# NB: We need flex for the static link
curl -O http://iweb.dl.sourceforge.net/project/flex/flex-2.5.39.tar.gz && \
rm -rf flex-2.5.39 && \
tar -xzf flex-2.5.39.tar.gz && (
  cd flex-2.5.39 && \
  sh ./configure --prefix=$(pwd -P)/install && \
  make install
)

# NB: The configure --wthout-* flags just disable building any runtime libs
# for the generated code.  We only want the codegen side of things.
curl -O http://archive.apache.org/dist/thrift/0.9.2/thrift-0.9.2.tar.gz && \
rm -rf thrift-0.9.2 && \
tar -xzf thrift-0.9.2.tar.gz && \ 
export PATH=$(pwd -P)/bison-2.5.1/install/bin:$(pwd -P)/flex-2.5.39/install/bin:$PATH && \
LDFLAGS="-all-static -L$(pwd -P)/flex-2.5.39/install/lib" && \
cd thrift-0.9.2 && \
sh ./configure \
  --disable-shared \
  --without-cpp \
  --without-c_glib \
  --without-csharp \
  --without-erlang \
  --without-java \
  --without-lua \
  --without-python \
  --without-perl \
  --without-php \
  --without-php_extension \
  --without-ruby \
  --without-haskell \
  --without-go && \
  make clean && \
  make LDFLAGS="$LDFLAGS"

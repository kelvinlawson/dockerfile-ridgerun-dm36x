FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y git build-essential curl lib32z1 libelf-dev vim python libncurses5-dev texinfo minicom quilt dc subversion git-core autoconf libcrypt-ssleay-perl ccache quilt libusb-dev libexpect-perl mono-devel libncurses5-dev texinfo minicom quilt dc subversion git-core autoconf libcrypt-ssleay-perl ccache quilt libusb-dev libexpect-perl mono-devel libdbus-glib-1-dev libgtk2.0-dev bison flex

# Install Codesourcery ARM compiler and set path
RUN mkdir /opt/codesourcery
RUN curl -s -L "https://sourcery.mentor.com/public/gnu_toolchain/arm-none-linux-gnueabi/arm-2009q1-203-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2" | bunzip2 -d --stdout | sudo tar -C /opt/codesourcery -xf -
ENV PATH $PATH:/opt/codesourcery/arm-2009q1/bin

# Install DVSDK
ADD responses.txt /tmp/
RUN curl -s -L "http://software-dl.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/dvsdk/DVSDK_4_00/4_02_00_06/exports/dvsdk_dm368-evm_4_02_00_06_setuplinux" > /tmp/dvsdk
RUN chmod a+wrx /tmp/dvsdk
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
# Non-interactive doesn't allow us to pass the real location of g++
RUN mkdir -p /root/CodeSourcery/Sourcery_G++_Lite
RUN ln -s /opt/codesourcery/arm-2009q1/bin /root/CodeSourcery/Sourcery_G++_Lite/bin
RUN /tmp/dvsdk --forcehost --response-file /tmp/responses.txt --mode console
RUN rm /tmp/dvsdk

# Set USER env var, required for SDK build
ENV USER root

# Clean up
RUN apt-get -y clean

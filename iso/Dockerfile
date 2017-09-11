# Copyright (C) 2016 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# TODO: Move this to somewhere on GCR and manage tags explicitly instead of
# relying on latest.
FROM boot2docker/boot2docker:1.12.6

# Set the version of Docker and the expected sha.
RUN echo "1.12.6" > $ROOTFS/etc/version
ENV DOCKER_SHA 53e47bc1c888279753c474c7c75c4e6756422165

# Removing the code that creates the /etc/os-release file.
# Refer: https://github.com/boot2docker/boot2docker/blob/master/rootfs/make_iso.sh#L20-L34
RUN sed -i '/^b2dVersion/,/^EOOS/d' /tmp/make_iso.sh

# Add the /etc/os-release file
ADD os-release $ROOTFS/etc

# Add other dependencies here to $ROOTFS/
ADD nsenter $ROOTFS/usr/bin/
ADD socat $ROOTFS/usr/bin
ADD ethtool $ROOTFS/usr/bin
ADD conntrack $ROOTFS/usr/bin

# Add cifs-utils and sshfs-fuse to mount fileshares
ENV HOST_FOLDER_DEPS cifs-utils \
              samba-libs \
              sshfs-fuse \
              nfs-utils

RUN for dep in $HOST_FOLDER_DEPS; do \
        curl -fSL -o "/tmp/$dep.tcz" "$TCL_REPO_BASE/tcz/$dep.tcz"; \
        unsquashfs -f -d "$ROOTFS" "/tmp/$dep.tcz"; \
        rm -f "/tmp/$dep.tcz"; \
    done

# Override current mount script
ADD scripts/automount $ROOTFS/etc/rc.d/automount

# Get a specific version of Docker. This will overwrite the binary installed
# in the base image.
# The --strip-components=3 flag will have to change as we switch docker versions
# past 1.10.x. They changed the packaging format slightly.
RUN rm -f /$ROOTFS/usr/local/bin/docker*
RUN curl -fSL -o /tmp/dockerbin.tgz https://get.docker.com/builds/Linux/x86_64/docker-$(cat $ROOTFS/etc/version).tgz && \
    # Check the sha1 matches.
    if [ $DOCKER_SHA != $(sha1sum /tmp/dockerbin.tgz | cut -f1 -d ' ') ]; then echo "SHA mismatch!"; exit 1; fi && \
    tar -zxvf /tmp/dockerbin.tgz -C "$ROOTFS/usr/local/bin" --strip-components=1 && \
    rm /tmp/dockerbin.tgz

RUN $ROOTFS/usr/local/bin/docker -v

# Build the actual iso image
RUN /tmp/make_iso.sh

# Output it to transfer back to the host
CMD ["cat", "boot2docker.iso"]

#!/bin/sh

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

set -e

ISO=minishift-b2d.iso
curdir=$(pwd)
tmpdir=$(mktemp -d)
[ "${REMOVE_CONTAINER_IMAGES+1}" ] && DOCKER_RUN_OPTIONS="--rm"

echo "Building in $tmpdir."
cp -r . $tmpdir/

cd $tmpdir

# Get nsenter.
docker run --rm jpetazzo/nsenter cat /nsenter > $tmpdir/nsenter && chmod +x $tmpdir/nsenter

# Get socat
docker build -t socat -f Dockerfile.socat .
docker run $DOCKER_RUN_OPTIONS socat cat socat > $tmpdir/socat
chmod +x $tmpdir/socat
[ "${REMOVE_CONTAINER_IMAGES+1}" ] && docker rmi socat

# Get ethtool
docker build -t ethtool -f Dockerfile.ethtool .
docker run $DOCKER_RUN_OPTIONS ethtool cat ethtool > $tmpdir/ethtool
chmod +x $tmpdir/ethtool
[ "${REMOVE_CONTAINER_IMAGES+1}" ] && docker rmi ethtool

# Get conntrack
docker build -t conntrack -f Dockerfile.conntrack .
docker run $DOCKER_RUN_OPTIONS conntrack cat conntrack > $tmpdir/conntrack
chmod +x $tmpdir/conntrack
[ "${REMOVE_CONTAINER_IMAGES+1}" ] && docker rmi conntrack

# Do the build.
docker build -t b2diso .

# Output the iso.
docker run $DOCKER_RUN_OPTIONS b2diso > $ISO

[ "${REMOVE_CONTAINER_IMAGES+1}" ] && docker rmi b2diso

cd $curdir
mv $tmpdir/$ISO ../build

# Clean up.
rm -rf $tmpdir

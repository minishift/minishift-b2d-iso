build/bin/minishift start --memory 4GB --iso-url file:///root/payload/build/minishift-b2d.iso
echo "=============================================="
build/bin/minishift status
echo "=============================================="
build/bin/minishift ssh exit
echo $?
echo "=============================================="
build/bin/minishift ip
echo "=============================================="
build/bin/minishift docker-env
echo "=============================================="
build/bin/minishift ssh 'sudo /sbin/mount.cifs -V'
echo "=============================================="
build/bin/minishift ssh 'sudo sshfs -V'
echo "=============================================="
build/bin/minishift ssh 'sudo /sbin/mount.nfs -V /needed/to/get/version'
echo "=============================================="
build/bin/minishift stop
echo "=============================================="
build/bin/minishift status
echo "=============================================="
build/bin/minishift start --memory 4GB --iso-url file:///root/payload/build/minishift-b2d.iso
echo "=============================================="
build/bin/minishift status
echo "=============================================="
build/bin/minishift delete

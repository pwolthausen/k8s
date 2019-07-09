# Debugger image

The debugger image and StatefulSet can be deployed to your cluster to help troubleshoot networking and cluster issues.
The image is based off the light weight Alpine image and includes an assortment of packages to help troubleshooting cluster issues.

The YAML will create a single pod as part of a statefulset which ensures the pod name is predicatable and easily connected to.
To connect, run 'kubectl exec -it debugger-0 -- /bin/bash'

## Included Packages

bash
namp
apache2-utils
bind-tools
tcpdump
mtr
busybox-extras (telnet)
iperf3
strace
arp-scan
netcat-openbsd (netcat)
tree

New packages can be installed using apk
For available packages, see https://pkgs.alpinelinux.org/packages

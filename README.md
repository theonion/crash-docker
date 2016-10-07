# This repository will consistently crash docker for mac

```
git clone https://github.com/theonion/crash-docker.git
cd crash-docker
docker-compose up
```

Open your web browser and visit http://localhost:9090/

Docker should crash.

# Why does it crash?

I believe it has to do with requesting many large files and breaking some of the
socket code here: https://github.com/docker/hyperkit/blob/master/src/pci_virtio_sock.c#L873

Here is the output from `syslog -w -k Sender Docker` during a crash.

```
 Assertion failed: (s->local_shutdown != VIRTIO_VSOCK_FLAG_SHUTDOWN_ALL), function shutdown_local_sock, file src/pci_virtio_sock.c, line 869.
 virtio-net-vpnkit: initialising, opts="uuid=ec0385d7-02e3-4c82-a1dd-6b984d74feed,path=/Users/collinmiller/Library/Containers/com.docker.docker/Data/s50,macfile=/Users/collinmiller/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/mac.0"
 Interface will have uuid ec0385d7-02e3-4c82-a1dd-6b984d74feed
 Connection established with MAC=c0:ff:ee:c0:ff:ee and MTU 1500
 virtio-9p: initialising path=/Users/collinmiller/Library/Containers/com.docker.docker/Data/s40,tag=db
 virtio-9p: initialising path=/Users/collinmiller/Library/Containers/com.docker.docker/Data/s51,tag=port
 linkname /Users/collinmiller/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
 COM1 connected to /dev/ttys009
 COM1 linked to /Users/collinmiller/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
 Socket.Stream: caught Uwt.Uwt_error(Uwt.ENOTCONN, "shutdown", "")
--- last message repeated 3 times ---
 Fatal unexpected exception: Socket.Closed
 PPP.listen: closing connection
 Socket.Stream: caught Uwt.Uwt_error(Uwt.ECONNREFUSED, "pipe_connect", "")
--- last message repeated 1 time ---
 Socket.Stream: caught Uwt.Uwt_error(Uwt.ENOTCONN, "shutdown", "")
 Reap com.docker.osxfs (pid 13579): exit status 1
 VM shutdown at 2016-10-07 10:26:10 -0500 CDT
 Reap com.docker.driver.amd64-linux (pid 13581): exit status 0
 Socket.Stream: caught Uwt.Uwt_error(Uwt.ECONNREFUSED, "pipe_connect", "")
--- last message repeated 7 times ---
 Stop 1 children with order 1: com.docker.driver.amd64-linux (pid 13581)
 Stop 2 children with order 2: com.docker.osxfs (pid 13579), com.docker.slirp (pid 13580)
 Signal terminated to com.docker.slirp (pid 13580)
 Reap com.docker.slirp (pid 13580): signal: terminated
 Starting com.docker.osxfs, com.docker.slirp, com.docker.driver.amd64-linux
 Start com.docker.osxfs (pid 13765)
 Start com.docker.slirp (pid 13766)
 Start com.docker.driver.amd64-linux (pid 13767)
 Logging to Apple System Log
 Logging to Apple System Log
 Setting handler to ignore all SIGPIPE signals
 vpnkit version 9cb6374ebfd0656961901478e9fc8cf65d000678 with hostnet version local  uwt version 0.0.3 hvsock version 0.10.0
 starting port_forwarding port_control_url:fd:4 vsock_path:/Users/collinmiller/Library/Containers/com.docker.docker/Data/@connect
 hosts file has bindings for localhost broadcasthost localhost
 Acquired hypervisor lock
 Docker is not responding: Get http://./info: dial unix /Users/collinmiller/Library/Containers/com.docker.docker/Data/*00000003.00000948: connect: connection refused: waiting 0.5s


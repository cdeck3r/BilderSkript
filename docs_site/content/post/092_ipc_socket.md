+++
title = "APPENDIX: IPC via Shared UNIX Sockets"
description = "Technical description on the usage of shared UNIX socket for docker container IPC"
date = "2019-12-31"
author = "Christian Decker"
sec = 92
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>

This is a technical design description on the usage of shared UNIX socket for docker container IPC. Both containers connect to a socket stored on a shared volume, e.g. under the mount point `ipc`. They exchange simple control messages to run scripts and read and write data from the shared volume.

<img src="uml/ipc_socket_docker.png" alt="ipc socket between docker containers" />
 
The approach utilizes 

* [`socat`](https://linux.die.net/man/1/socat) for creating sockets and socket communication 
* [`ss`](https://linux.die.net/man/8/ss) to check for the presence of the listening socket.

It follows a classical client / server approach where the server initializes the socket and waits for the client to start the communication. The following sequence diagrams depicts the interaction over the socket.

<img src="uml/ipc_socket.png" alt="ipc socket sequence diagram" />

Here are the script calls for the server and client.

**[Server](https://github.com/cdeck3r/BilderSkript/blob/master/scripts/ipc_socket_server.sh):**

```bash
./ipc_socket_server.sh <socket name> <path/to/server_app.sh>
```

**[Client](https://github.com/cdeck3r/BilderSkript/blob/master/scripts/ipc_socket_client.sh):**

```bash
./ipc_socket_client.sh <socket name> <path/to/client_app.sh>
```


### Cross Container IPC Example

We illustrate the container IPC between the `builder` container and the `hugin` container. The `hugin` container processes all images taken with the 360 camera and converts the fisheye lens images in regular ones using a equirectangular projection. The server script runs on the `hugin` container while the client script runs on the `builder` container. The socket between both resides on a shared volume.
It starts by the snakemake file on the `builder` calling the `hugin.sh` script.

<img src="uml/ipc_socket_hugin.png" alt="ipc socket communication between builder and hugin" />

**Ressources:**

A brief tutorial on `socat` is the [Socat Cheatsheet](https://blog.travismclarke.com/post/socat-tutorial/) from Travis Clarke.



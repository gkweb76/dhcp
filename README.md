# Supported tags
-   [`4.3.5`, `4.3.5-r0`, `latest` (*[4.3.5-r0/Dockerfile](https://github.com/gkweb76/dhcp/blob/master/4.3.5-r0/Dockerfile)*)]



# What is DHCP
DHCP is a well know service allowing you to serve IP addresses and network information (DNS, gateway, etc.) to your LAN.  



# Why using this image ?
This image is a vanilla DHCP software without any additional packages installed. 

This image is based on [Alpine Linux](https://alpinelinux.org/). Alpine Linux is generally immune to vulnerabilities targetting components not installed in this Operating System, such as: bash (e.g. Shellshock vulnerability), OpenSSL (e.g. Heartbleed vulnerability), glibc (e.g Ghost vulnerability). Also, Alpine Linux has a much smaller image size compared to other OS thanks to less packages installed by default and not relying on glibc, providing faster image download, and reduced attack surface, hence better security.

![](https://wiki.alpinelinux.org/w/resources/assets/alogo.png)



# Maintained by
Guillaume Kaddouch  
Blog: [https://networkfilter.blogspot.com/](https://networkfilter.blogspot.com/)  
Twitter: [@gkweb76](https://twitter.com/gkweb76)  
Github: [gkweb76](https://github.com/gkweb76/)  



# How to use this image from command line
First create your volumes:  
`docker volume create dhcp`  
`docker volume create dhcp_leases`  
`docker volume inspect dhcp | grep Mount`  
Grab the host real path, for instance /var/lib/docker/volumes/dhcp/_data (referred as '$DHCP_VOLUME_PATH' below)

Then copy your `dhcpd.conf` there, using the correct path:  
`cp ./dhcpd.conf $DHCP_VOLUME_PATH`  

Apply a strict chmod so that only root can modify these files:  
`chmod 644 $DHCP_VOLUME_PATH/dhcpd.conf`  

Finally start your container:  
-> modify the `eth0` interface at the end to match your interface name  
`docker container run --rm -v dhcp:/etc/dhcp -v dhcp_leases:/var/lib/dhcp --net=host \`  
`--read-only=true --tmpfs /run/dhcp -p 67:67/udp --name dhcp gkweb76/dhcp \`  
`/usr/sbin/dhcpd -4 -d -cf /etc/dhcp/dhcpd.conf eth0`  



# Docker compose example  
`version: "3.5"`  
  
`services:`  
&nbsp;&nbsp;  `dhcp:`  
&nbsp;&nbsp;  `image: gkweb76/dhcp:latest`  
&nbsp;&nbsp;  `container_name: dhcp`  
&nbsp;&nbsp;  `read_only: yes`  
&nbsp;&nbsp;  `network_mode: "host"`  
&nbsp;&nbsp;    `volumes:`  
&nbsp;&nbsp;&nbsp;&nbsp;      `- dhcp:/etc/dhcp # put your conf files here`  
&nbsp;&nbsp;&nbsp;&nbsp;      `- dhcp_leases:/var/lib/dhcp`  
&nbsp;&nbsp;&nbsp;&nbsp;      `- /etc/localtime:/etc/localtime:ro # keep container clock in sync with host`  
&nbsp;&nbsp;    `tmpfs:`  
&nbsp;&nbsp;&nbsp;&nbsp;      `- /run/dhcp`  
&nbsp;&nbsp;  `command: ["/usr/sbin/dhcpd", "-4", "-d", "-cf", "/etc/dhcp/dhcpd.conf", "eth0"]` # specify your host LAN interface  
&nbsp;&nbsp;    `restart: "unless-stopped"`  
   
`# Volumes declaration`  
`volumes:`  
&nbsp;&nbsp;  `dhcp:`  
&nbsp;&nbsp;  `dhcp_leases:`  

    
If you need help with your compose file, check the official [documentation](https://docs.docker.com/compose/compose-file/).  

# Tested on

[Ubuntu](https://www.ubuntu.com/) 18.04 LTS and Docker 18.04.0 CE (Community Edition).

# License

MIT License

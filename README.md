NS2
===


- [duplex link](./basics/duplexLink.tcl)
- [ftp over tcp](./basics/ftpOverTCP.tcl)

[__Ring Topology__](./basics/ringTopology.tcl)
---
![](./basics/ringTopology.jpg)


https://user-images.githubusercontent.com/56071758/117620858-892f8f80-b18e-11eb-8cc7-c1fd5a52b222.mp4

__[cbr over UDP](./basics/cbrOverUDP.tcl)__
---

![](./basics/cbrOverUDP.jpg)

# [Q1](./experiments/q1.tcl)

Consider a small network with five nodes n0, n1, n2, n3, n4, forming a star topology.   
The node n4 is at the center.  
- Node **n0 is a TCP source**, which transmits packets to **node n3 (a TCP sink)** *through the node n4*.  
- Node **n1 is another traffic source**, and *sends UDP packets* **to node n2** *through n4*.  
- The duration of the ***simulation time is 10 seconds***.

![](./experiments/q1.jpg)
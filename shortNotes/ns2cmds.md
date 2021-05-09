CONTENTS
===

- [#AWK-file](#AWK-file)
- [#XGRAPH](#XGRAPH)


❌  : indicates the segementaion fault 


Basics
---
```tcl
# comment
```

❌
```tcl
some code  # comment
```
✔️
```tcl
some code  
# comment 
```

> always give comments in separate line  

***fwd slash favoured i guess***


> variables in Tcl, need not necessarily be  predeclared.


Procedure
---
`proc finish{}`  ❌  
`proc finish {}` ✔️


```tcl
proc finish {} {
    # keyword ~~global~~ used to tell what variables are being used outside the procedure.
    global ns tf nf
    $ns flush-trace


    # close trace files
    close $tf
    close $nf


    # execute the nam file
    exec nam out.nam
    # closes the application and returns zero as default for clean exit
    exit 0
}
```


__SET__
===
```tcl
set <handle> [  <newObject> ]

# e.g.
set nf [open out.nam w]
```
```tcl
# create simulator object
set ns [new Simulator]

# class
$ns color 1 Blue
$ns color 2 Red

# darkmagenta, blue, yellow, green

set nf [open out.nam w]
$ns namtrace-all $nf


# ~~~~~~~ tracing whole ns object ~~~
set tf [open out.tr w]
$ns trace-all $tf


# ~~~~~~~~ tracing queue ~~~~~~~~~~~~
set tf23 [open out_tf23.tr w]
$ns trace-queue $n(2) $n(3) $tf23



# 'rtProtoDV' packets used to exchange routing information between the nodes
$ns rtproto DV
```


Create Node
===
```tcl
# create nodes 
set n0 [$ns node]
set n1 [$ns node]

# using for loop
for {set i 0} { $i < 7 } { incr i } {
    set n($i) [$ns node]
}
```
additional configuration
---
```tcl
$n1 color red
# darkmagenta, blue, yellow, green

$n1 shape box
```

Linking nodes 
===
```tcl
$ns simplex-link $n0 $n1 0.3Mb 100ms DropTail


# $ns duplex-link $n0 $n1 <capacity/linkBandwidth> <propagation delay> <node-QueueType>
$ns duplex-link $n0 $n1 1Mb 0.01ms DropTail    
# ✓ T capital in `DropTail`    


# node $n4 w.r.t. node $n3
$ns duplex-link-op $n3 $n4 orient right-down
$ns duplex-link-op $n3 $n4 orient down-right
$ns duplex-link-op $n3 $n4 orient up-left
$ns duplex-link-op $n3 $n4 orient up


# $ns queue-limit $n0 $n2 <bufferCapacity>
$ns queue-limit $n0 $n2 20
```



__AGENTS__
===

_TCP, transmission control protocol_  (n0 🠆 n1)
===
used to provide reliable **transport of packets from one host to another
host** by *sending acknowledgements on proper transfer* or loss of packets.  

Thus  **TCP requires bi-directional links** *in order for acknowledgements to return to the source.*
```tcl
# setting up TCP agent
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

# additional configuration
$tcp0 set fid_  34
$tcp0 set packetSize_ 1500

# to set packet size for all TCP's in the simulation
Agent/TCP set packetSize_ 1460
```

___FTP over TCP___
---
standard mechanism provided by the Internet for transferring files from one host to another.  

FTP differs from other client server applications in that   
it **establishes two connections between the client and the server**.  

- 1st connection is used for **data transfer**
- 2nd connection is used for **providing control information**

> FTP uses the services of the TCP. 

- The well Known port 21 is used for control connections and the other port 20 is used for data transfer.

https://www.isi.edu/nsnam/ns/doc/node516.html

```tcl
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0 ✔️
$ftp0 attach-agent $n0   ❌ 

# additional configurations
$ftp0 set packetSize_ 1000  💀   
$ftp0 set packet_size_ 1000  💀💀  
$ftp0 set intervalSize_ 0.1
$ftp0 set type_ FTP

# important when sending file of fixed size
$ftp0 set rate_ 1     💀
```

_Agent/TCPSink_
---
```tcl
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
```


_Connect agents_
---
```tcl
$ns connect $tcp0 $sink1
```

_Animation_
---
```tcl
# ftp schedule

$ns at 2.0 "$ftp0 start"  ✔️
$ns at 2.0 "$ftp0 starts" ❌

$ns at 5.0 "$ftp0 stop"   ✔️
$ns at 5.0 "$ftp0 stops"  ❌



# to send a fixed size file(4Mb)
set fileSize [expr 4*1024*1024]
$ns at 0.0 "$ftp0 send $fileSize"   ✔️
$ns at 0.0 "$ftp0 sends $fileSize"  ❌



# call finish procedure
$ns at 50.0 "finish"

$ns run
```

_UDP, user datagram protocol_  (n0 🠆 n1)       🔖
===
UDP helps the host to send messages in the form of datagrams to
another host
```tcl
# create UDP agent
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

# additional configuration
# When we have several flows (such as TCP, UDP) in a network, to identify these flows we set their flow ID
$udp0 set fid_ 2
# for marking flows
$udp0 set class_ 1


$udp0 set packetSize_ 1500

# to set packet size for all UDP's in the simulation
Agent/UDP set packetSize_   1000
# The default maximum segment size (MSS) for UDP agents is 1000 byte
```

_CBR over UDP_
---
***cbr generate packets at constant bit rate***
https://www.isi.edu/nsnam/ns/doc/node516.html
```tcl
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 1000 
# 210 is the dfault packetSize_ value 
$cbr0 set type_ CBR

# confusion
$cbr0 set intervalSize_ 0.1    ❌
$cbr0 set interval_ 0.1        
$cbr0 set interval 0.1         💀


# important cmd when sending file of fixed size
$cbr0 set rate_ 1      /// confusion here whether unit should come or not
$cbr0 set rate_ 100Kb  // shold come fate says
```

_Agent/Null_
---
```tcl
# create null agent(which acts as traffic sink)
set null1 [new Agent/Null]
$ns attach-agent $n1 $null1 
```

_Connect agents_
---
```tcl
$ns connect $udp0 $null1
```

_Animation_
---
```tcl
# cbr schedule
$ns at 2.0 "$cbr0 start"
$ns at 5.0 "$cbr0 stop"

# cbr schedule, link down at some instants, use $ns rtproto DV
$ns at 0.1 "$cbr0 start"
$ns rtmodel-at 0.2 down $n(0) $n(6)
$ns rtmodel-at 0.4   up $n(0) $n(6)
$ns at 0.6 "$cbr0 stop"

# to send a fixed size file(4MB)
set fileSize [expr 4*1024*1024]
$ns at 0.0 "$cbr0 send $fileSize"   ✔️
$ns at 0.0 "$cbr0 sends $fileSize"  ❌

# call finish procedure
$ns at 50.0 "finish"

$ns run
```




__Scheduling events__
---
```tcl
# Syntax
ns at <time> <event>    
```

```tcl
# perform "some cmd" at 2.0 sumulation second
$ns at 2.0 "some cmd"

# e.g.
$ns at 0.2 "$cbr0 start"
$ns at 2.0 "finish"
```

__CMDS__
---

    $handle <cmd>


To run simulator
```tcl
$ns run

exec nam out.nam
```



Structure of Trace file   🔖
===

Each line of the trace file corresponds to one event of packet activity

```tcl
<event> <timeInSecond> <inputNode> <outputNode> <packetType> <packetSize>   ----- <flowId> <srcAddr> <destAddr> <networkLayerProtocolPacketSequenceNumber>  <uniqueIdOfPacket>
```


`<packetType>`: cbr/tcp

`<packetSize>`: no of bytes in packet


> ``<srcAddr> <destAddr>`` :  address in `node.port` form

```
e.g. x.y  here x is node, y is transport agent no
```

`<sequenceNumber>`  
- can repeat `due to retransmission`
- useful to determine *if packet was new or a retransmission*

`<uniqueIdOfPacket>`  
- is always unique
- used to determine no. of packets lossed



Event
---
```tr
+ : enqueued, may or it may be dropped
- : dequeued, packet leaves a queue ~~of src~~
r : received, packet is received into a queue ~~of dest~~
d : dropped,  packet is dropped from queue ~~of src~~
```

packetType
---
+ cbr


Setup a LAN  🔖
===
```tcl
set lan [$ns newLan "$n0 $n1 $n2" 1Mb 20ms LL Queue/Droptail MAC/Csma/Cd Channel]
set lan [$ns newLan "$n0 $n1 $n2" 1Mb 20ms LL Queue/Droptail Mac/Csma/Cd Channel]
set lan [$ns newLan "$n0 $n1 $n2" 1Mb 20ms LL Queue/Droptail  Mac/802_3 Channel]

set lan [$ns newLan "$n0 $n1 $n2" <bandwidth> <delay> <linkLayerType> <interfacingQueue> <MAClayerType> <channeType>]
```

# Simulating link errors
```tcl
# ~~~~~~~~~~~ error model
set errModel [new ErrorModel]
$errModel set rate_ 0.2
$errModel ranvar [new RandomVariable/Uniform]
$errModel drop-target [new Agent/Null]
$ns lossmodel $errModel $n(2) $n(3)
```



AWK file  🔖
===
awk, a program that you can use to **select particular records in a file and perform operations upon them**.

```bash
# to execute awk pgm ``someAwkFile.awk``
awk     -f someAwkFile.awk someTracefile.tr
awk --file someAwkFile.awk someTracefile.tr
```
```awk
BEGIN   ❌
{
    // Begin part comprises of initialization of variable.
}

BEGIN {   ✔️ 
    // some code
}
```

```awk
BEGIN {
    // Begin part comprises of initialization of variable.
}


{
    # Commands in the **content part** scan every row of trace file only once.
    # Ex:
    # if (pattern) {
    #      action;
    # }
}

END {
    # In the END part final calculation is performed on the data obtained from the **content part**.
}
```

Alternative way 
---
define awkFile in the finish procedure itself   
& then execute directly from there 

```tcl
proc finish {} {

    global ns tf nf

    $ns flush-trace

    close $tf
    close $nf



    set awkFile {

        BEGIN { 
            # Begin part comprises of initialization of variable.
        }

        {
            # Commands in the content part scan every row of trace file only once.
            # Ex:
            # if (pattern) {
            #      action;
            # }
        }

        END {
            # In the END part final calculation is performed on the data obtained from the content part.
        }

    }
 
    exec nam out.nam &
    exec awk $awkFile traceFileName.tr &    ✔️
    exec awk -f $awkFile traceFileName.tr & ❌
    exit 0
}
```

Printing 
---
```awk
print item1, item2, …    
```

output will be          
```awk
item1 item2 item3 … itemn
# all items will be printed separated by space , & terminated by newline charachter(
# i.e. cursor goes to next line after printing all items 
```




NETWORK PERFORMANCE     🔖
===

__Throughput__ : The amount of traffic a network can carry is measured as throughput, usually in terms such as *kilobits per second*.

- **Look for receive (r) events** in the trace file.
- Look for the **correct source and destination pair**
- **Add up all the packet sizes** in the receive events




XGRAPH             🔖
=== 

```bash
xgraph file.dat
xgraph file.xg

# to plot two curves in same xgraph
xgraph 6.2.node5.dat 6.2.node4.dat 
```

- XGRAPH expects data in an `x y` format. 
    - Typically, this is one x-y data-point pair per line. Data
- To place **multiple plots in a given file**, place the keyword, `NEXT`, between the distinct curves,lines, or plots in your data listing.  
e.g.
```dat
1 8
2 9
3 10
4 89

NEXT
1 67
2 43 
3 2
4 3
```

```
color = <colorName>
```
color name can be
- 0 = black, 
- 1 = white, (caution on white paper printout) 
- 2 = red, 
- 3 = blue, 
- 4 = green, 
- 5 = violet
- 6 = orange
- 7 = yellow
- 8 = pink
- 9 = cyan
- 10 = light-gray
- 11 = dark-gray
- 12 = fuchsia, (default plotting color) 
- 13 = aqua, (border color) 
- 14 = navy, (grid color) 
- 15 = gold. (text color)

```awk
setenv XGRAPH_BACKGROUND ff
```

```
shape <value>
```
0 triangles   
1 circles   
2 squares   
3 diamonds   
4 inverted triangles   
5 stars  
6 horizontal hour-glass   
7 vertical hour-glass

  

COMMENTS       
```awk
! one line comment
/*
    multi line 
    comment
*/
```
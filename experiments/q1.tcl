set ns [new Simulator]

set tf [open out.tr w]
$ns trace-all $tf

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns tf nf
    $ns flush-trace


    close $tf
    close $nf


    exec nam out.nam
    exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]


$ns duplex-link $n4 $n0 1Mb 10ms DropTail
$ns duplex-link $n4 $n1 1Mb 10ms DropTail
$ns duplex-link $n4 $n2 1Mb 10ms DropTail
$ns duplex-link $n4 $n3 1Mb 10ms DropTail


# orienting the connection according to specific user-preference 
$ns duplex-link-op $n4 $n0 orient up
$ns duplex-link-op $n4 $n1 orient left
$ns duplex-link-op $n4 $n2 orient right
$ns duplex-link-op $n4 $n3 orient right-down





# SETTING UP connection from $n0(source) to $n3(destination) 

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set packetSize_ 500
$ftp0 set intervalSize_ 0.1

set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3

# making tcp connection b/w $n1 & $n2 
$ns connect $tcp0 $sink3



# SETTING UP connection from $n1 to $n2 

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packetSize_ 500
$cbr1 set intervalSize_ 0.1



set null2 [new Agent/Null]
$ns attach-agent $n2 $null2

# making udp connection b/w $n1 & $n2 
$ns connect $udp1 $null2




# to start nam animation
$ns at 0 "$ftp0 start"
$ns at 0.5 "$cbr1 start"

# to STOP nam animation
$ns at 5.0 "$ftp0 stop"
$ns at 10.0 "$cbr1 stop"


# to finish simulation at 10.0 second 
$ns at 10.0 "finish"

$ns run
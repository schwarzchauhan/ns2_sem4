set ns [new Simulator]

set tf [open out.tr w]
$ns trace-all $tf

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns tf nf

    $ns flush-trace 

    close $nf 
    close $tf 

    exec nam out.nam
    exit 0
}


# ---------------------------------------------------------------------------------------


set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link     $n0 $n1 1Mb 40ms DropTail
$ns duplex-link-op  $n0 $n1 orient right-down

# ---------------------------------------------------------------------------------------

# ~~~~~~~~~~~~~~~~~~~~~~~~~
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

$udp0 set fid_ 49


set cbr0 [new Application/Traffic/CBR]
$cbr0 set interval_ 0.01
$cbr0 set packetSize_ 200
$cbr0 attach-agent $udp0

# ~~~~~~~~~~~~~~~~~~~~~~~~~
set null1 [new Agent/Null]
$ns attach-agent $n1 $null1


# ~~~~~~~~~~~~~~~~~~~~~~~~~
$ns connect $udp0 $null1


# ---------------------------------------------------------------------------------------
$ns at 0.1 "$cbr0 start"
$ns at 0.5 "$cbr0 stop"


# ---------------------------------------------------------------------------------------
$ns at 2.0 "finish"

$ns run
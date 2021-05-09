# ---------------------------------------------------------------------------------------
set ns [new Simulator]


set nf [open out.nam w]
$ns namtrace-all $nf


set tf [open out.tr w]
$ns trace-all $nf


proc finish {} {
    global ns nf tf 

    $ns flush-trace 

    close $nf 
    close $tf 

    exec nam out.nam &
    exit 0
}


# ---------------------------------------------------------------------------------------


set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link $n0 $n1 1Mb 0.01ms DropTail
# $ns duplex-link-op  $n0 $n1 orient right-down
# $ns duplex-link-op  $n0 $n1 orient right-up
# $ns duplex-link-op  $n0 $n1 orient left-down
# $ns duplex-link-op  $n0 $n1 orient left-up


# ---------------------------------------------------------------------------------------
$ns at 5.0 "finish"

$ns run
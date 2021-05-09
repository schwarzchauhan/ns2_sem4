# -----------------------------------------------------------------------------------------------------
set ns [new Simulator]


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set tf [open out.tr w]
$ns trace-all $tf

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set nf [open out.nam w]
$ns namtrace-all $nf


# -----------------------------------------------------------------------------------------------------
proc finish {} {
    global ns tf nf

    $ns flush-trace

    close $tf
    close $nf

    exec nam out.nam &
    exit 0
}


# -----------------------------------------------------------------------------------------------------
set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link    $n0 $n1 1Mb 20ms DropTail
$ns duplex-link-op $n0 $n1 orient left-down


# -----------------------------------------------------------------------------------------------------

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

$tcp0 set fid_ 34

# ~~~~~~
set ftp0 [new Application/FTP]
$ftp0 set packetSize_ 200
$ftp0 set interval_ 0.1
$ftp0 attach-agent $tcp0


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ns connect $tcp0 $sink1



# -----------------------------------------------------------------------------------------------------
$ns at 0.1 "$ftp0 start"
$ns at 0.3 "$ftp0 stop"


# -----------------------------------------------------------------------------------------------------
$ns at 50.0 "finish"

$ns run
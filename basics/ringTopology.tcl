# -----------------------------------------------------------------------------------------------------
set ns [new Simulator]
$ns color 39 Blue 
$ns color 426 Red 

# &&&&&&&&&&&&&&&&&&&&&&&&&&
$ns rtproto DV

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

for {set i 0} { $i < 7 } { incr i } {
    set n($i) [$ns node]
}

for {set i 0} { $i < 7 } { incr i } {
    $ns duplex-link $n($i) $n([expr ($i+1)%7]) 1Mb 10ms DropTail
}

# -----------------------------------------------------------------------------------------------------


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0
$udp0 set fid_ 39

# ~~~~~~~~
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 200
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

# ~~~~~~~~~~~~~~~~~~~~~~~~~~
set null6 [new Agent/Null]
$ns attach-agent $n(6) $null6

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ns connect $udp0 $null6

# -----------------------------------------------------------------------------------------------------


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ns at 0.1 "$cbr0 start"

# &&&&&&&&&&&&&&&&&&&&&&&&&&
$ns rtmodel-at 0.2 down $n(0) $n(6)
$ns rtmodel-at 0.4   up $n(0) $n(6)

$ns at 0.6 "$cbr0 stop"





# -----------------------------------------------------------------------------------------------------
$ns at 1.0 "finish"

$ns run
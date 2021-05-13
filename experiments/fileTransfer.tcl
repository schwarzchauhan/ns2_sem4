# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set ns [new Simulator]
$ns color 57 darkmagenta

set tf [open out.tr w]
$ns trace-all $tf


set nf [open out.nam w]
$ns namtrace-all $nf


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
proc finish {} {
    global ns tf nf 

    $ns flush-trace

    close $tf
    close $nf

    exec nam out.nam & 
    exit 0
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set n0 [$ns node]
set n1 [$ns node]




$ns duplex-link $n0 $n1 10Mb 0.01ms DropTail




# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
$tcp0 set packetSize_ 1500
$tcp0 set fid_ 57


# ~~~~~~~~~~~~~~~~~~~
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1


# ~~~~~~~~~~~~~~~~~~~
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP
$ftp0 set rate_ 1


$ns connect $tcp0 $sink1


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set fileSize [expr 10*1024*1024]
$ns at 0.0 "$ftp0 send $fileSize"


# ~~~~~~~~~~~~~~~~~~~
$ns at 100.0 "finish"

$ns run 



# 8.613048 seconds utilized to send the 10MB file when link-bandwidth = 10Mb , delay = 0.01ms
# 86.13012 seconds utilized to send the 10MB file when link-bandwidth is 1Mb , delay = 0.01ms



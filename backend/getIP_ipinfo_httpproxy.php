<?php
$IPINFO_PROXYADDRESS="42.113.52.190"; // leave proxy address blank for direct
$IPINFO_PROXYPORT="80";

$streamContext = array(
    "ssl"=>array(
        "verify_peer"=>false,
        "verify_peer_name"=>false,
    ),
    'http' => array(
        'proxy'           => 'tcp://'.$IPINFO_PROXYADDRESS.':'.$IPINFO_PROXYPORT,
        'request_fulluri' => true,
    ),
);
$IPINFO_HTTPPROXY= stream_context_create($streamContext);
?>

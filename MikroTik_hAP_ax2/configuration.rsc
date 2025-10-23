# 2025-10-21 17:45:30 by RouterOS 7.15.3
# software id = R4UN-CVLI
#
# model = C52iG-5HaxD2HaxD
# serial number = HE408MF4JY0
/interface bridge
add name=bridge_guests port-cost-mode=short protocol-mode=none
add admin-mac=48:A9:8A:5C:E9:B5 auto-mac=no name=bridge_home port-cost-mode=\
    short protocol-mode=none
/interface ethernet
set [ find default-name=ether1 ] name=ether1-wan
set [ find default-name=ether2 ] name=ether2-srv01
set [ find default-name=ether3 ] name=ether3-cam
set [ find default-name=ether4 ] disabled=yes name=ether4-sypialnia
set [ find default-name=ether5 ] name=ether5-tv
/interface wifi
set [ find default-name=wifi1 ] channel.band=5ghz-ax .frequency=5220 \
    .skip-dfs-channels=all .width=20/40/80mhz configuration.country=Poland \
    .mode=ap .ssid=Maku-5GHz disabled=no name=wifi1-5g-home \
    security.authentication-types=wpa2-psk,wpa3-psk .connect-priority=0 \
    .disable-pmkid=yes
set [ find default-name=wifi2 ] channel.band=2ghz-ax .frequency=2412 \
    .skip-dfs-channels=all .width=20/40mhz-Ce configuration.country=Poland \
    .mode=ap .ssid=Maku-2GHz disabled=no name=wifi2-2g-home \
    security.authentication-types=wpa2-psk,wpa3-psk .connect-priority=0 \
    .disable-pmkid=yes
add channel.band=5ghz-ax .frequency=5220 .skip-dfs-channels=all .width=\
    20/40/80mhz configuration.mode=ap .ssid=MakuGuests-5GHz disabled=no \
    mac-address=4A:A9:8A:5C:E9:B9 master-interface=wifi1-5g-home name=\
    wifi3-5g-guests security.authentication-types=wpa2-psk,wpa3-psk \
    .connect-priority=0 .disable-pmkid=yes
/interface pppoe-client
add add-default-route=yes disabled=no interface=ether1-wan name=netfala \
    service-name=netfala user=<HIDDEN_DATA>
/interface wireguard
add listen-port=55666 mtu=1420 name=wireguard
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/ip dhcp-server
add interface=bridge_home lease-time=10m name=home
/ip pool
add name=dhcp-home ranges=172.25.100.50-172.25.100.99
add name=dhcp-guests ranges=172.25.200.10-172.25.200.49
/ip dhcp-server
add address-pool=dhcp-guests interface=bridge_guests lease-time=10m name=\
    wifi-guests
/ip smb users
set [ find default=yes ] disabled=yes
/interface bridge port
add bridge=bridge_home comment=defconf interface=ether2-srv01 \
    internal-path-cost=10 path-cost=10
add bridge=bridge_home comment=defconf interface=ether3-cam \
    internal-path-cost=10 path-cost=10
add bridge=bridge_home comment=defconf interface=ether4-sypialnia \
    internal-path-cost=10 path-cost=10
add bridge=bridge_home comment=defconf interface=ether5-tv \
    internal-path-cost=10 path-cost=10
add bridge=bridge_home comment=defconf interface=wifi1-5g-home \
    internal-path-cost=10 path-cost=10
add bridge=bridge_home comment=defconf interface=wifi2-2g-home \
    internal-path-cost=10 path-cost=10
add bridge=bridge_guests comment=defconf interface=wifi3-5g-guests \
    internal-path-cost=10 path-cost=10
/ip firewall connection tracking
set udp-timeout=10s
/ip neighbor discovery-settings
set lldp-med-net-policy-vlan=1
/ipv6 settings
set disable-ipv6=yes
/interface wireguard peers
add allowed-address=<HIDDEN_DATA>/32 comment="<HIDDEN_DATA>" interface=\
    wireguard name=peer1 public-key=\
    "<HIDDEN_DATA>"
add allowed-address=<HIDDEN_DATA>/32 comment="<HIDDEN_DATA>" interface=\
    wireguard name=peer2 public-key=\
    "<HIDDEN_DATA>"
add allowed-address=<HIDDEN_DATA>/32 comment="<HIDDEN_DATA>" interface=\
    wireguard name=peer3 public-key=\
    "<HIDDEN_DATA>"
add allowed-address=<HIDDEN_DATA>/32 comment="<HIDDEN_DATA>" interface=\
    wireguard name=peer10 public-key=\
    "<HIDDEN_DATA>"
/ip address
add address=172.25.100.1/24 comment="LAN Home" interface=bridge_home network=\
    172.25.100.0
add address=172.25.150.1/24 comment=WireGuard interface=wireguard network=\
    172.25.150.0
add address=172.25.200.1/24 comment="WiFi Guests" interface=bridge_guests \
    network=172.25.200.0
/ip cloud
set ddns-update-interval=5m
/ip dhcp-server lease
add address=172.25.100.27 comment=Piekarnik mac-address=BC:10:2F:49:50:97 \
    server=home
add address=172.25.100.26 comment="Plyta indukcyjna" mac-address=\
    BC:10:2F:4F:8B:1A server=home
add address=172.25.100.31 comment="Phone Home Mateusz" mac-address=\
    02:E4:CD:2C:4B:95 server=home
add address=172.25.100.41 comment="Phone Home Justyna" mac-address=\
    D6:0F:F2:B6:68:41 server=home
add address=172.25.100.30 comment="PC Home Mateusz" mac-address=\
    3C:A0:67:EF:C3:8B server=home
add address=172.25.100.28 comment=Pralka mac-address=A8:42:E3:9A:62:BC \
    server=home
add address=172.25.100.40 comment="PC Home Justyna" mac-address=\
    98:59:7A:E1:CD:5F server=home
add address=172.25.100.32 comment="PC Work Mateusz" mac-address=\
    F4:6D:3F:3F:BD:C6 server=home
/ip dhcp-server network
add address=172.25.100.0/24 comment=defconf dns-server=172.25.100.10 gateway=\
    172.25.100.1 netmask=24
add address=172.25.200.0/24 comment=defconf dns-server=172.25.100.10 gateway=\
    172.25.200.1 netmask=24
/ip dns
set allow-remote-requests=yes servers=172.25.100.10
/ip dns static
add address=192.168.2.1 comment=defconf name=router.lan
/ip firewall filter
add action=accept chain=forward comment=\
    "Allow established, related, untracked" connection-state=\
    established,related,untracked
add action=accept chain=input comment="Allow established, related, untracked" \
    connection-state=established,related,untracked
add action=drop chain=forward comment="Drop trafic from camera" src-address=\
    172.25.100.20
add action=accept chain=forward comment="Allow traffic to Internet" \
    in-interface=!netfala out-interface=netfala
add action=accept chain=forward comment="Allow DNS traffic to the DNS server" \
    dst-address=172.25.100.10 dst-port=53 in-interface=!netfala protocol=udp
add action=accept chain=input comment="Allow NTP traffic to Router" dst-port=\
    123 in-interface=!netfala protocol=udp
add action=accept chain=forward comment="Allow traffic from the home network" \
    in-interface=bridge_home
add action=accept chain=input comment="Allow traffic from the home network" \
    in-interface=bridge_home
add action=accept chain=input comment="Allow traffic for WireGuard" dst-port=\
    55666 protocol=udp
add action=accept chain=forward comment=\
    "Allow traffic from the Wireguard network" in-interface=wireguard
add action=accept chain=input comment=\
    "Allow traffic from the Wireguard network" in-interface=wireguard
add action=drop chain=input comment="Drop all other traffic"
add action=drop chain=forward comment="Drop all other traffic"
/ip firewall nat
add action=masquerade chain=srcnat out-interface=netfala src-address=\
    172.25.100.0/24
add action=masquerade chain=srcnat out-interface=netfala src-address=\
    172.25.150.0/24
add action=masquerade chain=srcnat comment=\
    "Allow guests to access the internet" out-interface=netfala src-address=\
    172.25.200.0/24
/ip service
set telnet disabled=yes
set ftp disabled=yes
set ssh address=172.25.100.0/24
set api address=172.25.100.0/24
set winbox disabled=yes
set api-ssl disabled=yes
/ip smb shares
set [ find default=yes ] directory=/pub
/ipv6 firewall address-list
add address=::/128 comment="defconf: unspecified address" list=bad_ipv6
add address=::1/128 comment="defconf: lo" list=bad_ipv6
add address=fec0::/10 comment="defconf: site-local" list=bad_ipv6
add address=::ffff:0.0.0.0/96 comment="defconf: ipv4-mapped" list=bad_ipv6
add address=::/96 comment="defconf: ipv4 compat" list=bad_ipv6
add address=100::/64 comment="defconf: discard only " list=bad_ipv6
add address=2001:db8::/32 comment="defconf: documentation" list=bad_ipv6
add address=2001:10::/28 comment="defconf: ORCHID" list=bad_ipv6
add address=3ffe::/16 comment="defconf: 6bone" list=bad_ipv6
/ipv6 firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMPv6" protocol=\
    icmpv6
add action=accept chain=input comment="defconf: accept UDP traceroute" port=\
    33434-33534 protocol=udp
add action=accept chain=input comment=\
    "defconf: accept DHCPv6-Client prefix delegation." dst-port=546 protocol=\
    udp src-address=fe80::/10
add action=accept chain=input comment="defconf: accept IKE" dst-port=500,4500 \
    protocol=udp
add action=accept chain=input comment="defconf: accept ipsec AH" protocol=\
    ipsec-ah
add action=accept chain=input comment="defconf: accept ipsec ESP" protocol=\
    ipsec-esp
add action=accept chain=input comment=\
    "defconf: accept all that matches ipsec policy" ipsec-policy=in,ipsec
add action=drop chain=input comment=\
    "defconf: drop everything else not coming from LAN" in-interface-list=\
    !LAN
add action=accept chain=forward comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf: drop packets with bad src ipv6" src-address-list=bad_ipv6
add action=drop chain=forward comment=\
    "defconf: drop packets with bad dst ipv6" dst-address-list=bad_ipv6
add action=drop chain=forward comment="defconf: rfc4890 drop hop-limit=1" \
    hop-limit=equal:1 protocol=icmpv6
add action=accept chain=forward comment="defconf: accept ICMPv6" protocol=\
    icmpv6
add action=accept chain=forward comment="defconf: accept HIP" protocol=139
add action=accept chain=forward comment="defconf: accept IKE" dst-port=\
    500,4500 protocol=udp
add action=accept chain=forward comment="defconf: accept ipsec AH" protocol=\
    ipsec-ah
add action=accept chain=forward comment="defconf: accept ipsec ESP" protocol=\
    ipsec-esp
add action=accept chain=forward comment=\
    "defconf: accept all that matches ipsec policy" ipsec-policy=in,ipsec
add action=drop chain=forward comment=\
    "defconf: drop everything else not coming from LAN" in-interface-list=\
    !LAN
/snmp
set enabled=yes trap-interfaces=ether2-srv01 trap-version=3
/system clock
set time-zone-name=Europe/Warsaw
/system identity
set name=R1-Maku
/system leds
add leds=user-led type=off
/system note
set show-at-login=no
/system ntp client
set enabled=yes
/system ntp server
set broadcast=yes enabled=yes multicast=yes
/system ntp client servers
add address=0.pl.pool.ntp.org
add address=1.pl.pool.ntp.org
add address=2.pl.pool.ntp.org
add address=3.pl.pool.ntp.org
/system scheduler
add interval=1m name=check_temp_schedule on-event=check_temp policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2024-07-12 start-time=20:36:12
/system script
add dont-require-permissions=yes name=check_temp owner=maku policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local temp [/system/health get [find where name=cpu-temperature] value]\
    \n:if (\$temp > 70) do={\
    \n    /system leds set 1 type=on\
    \n} else={\
    \n    /system leds set 1 type=off\
    \n}"
/tool sniffer
set file-limit=10000KiB file-name=monitor.pcap filter-interface=all \
    filter-mac-address=\
    C6:55:FF:FF:FF:FF/FF:FF:FF:FF:FF:FF,C0:C4:F9:48:C6:55/FF:FF:FF:FF:FF:FF \
    memory-limit=10000KiB

; TO-DO: verify alignment and insert padding if necessary

MAX_ADAPTER_ADDRESS_LENGTH EQU 8        ; Default value
MAX_DHCPV6_DUID_LENGTH EQU 130          ; Default value

SOCKET_ADDRESS STRUCT
    lpSockaddr              QWORD ?     ; LPSOCKADDR
    iSockaddrLength         DWORD ?     ; INT
    Padding                 DWORD ?     ; 4 bytes for alignment
SOCKET_ADDRESS ENDS

IP_ADAPTER_ADDRESSES_LH STRUCT
    UNION
        Alignment           QWORD ?     ; ULONGLONG
        STRUCT
            Length          DWORD ?     ; ULONG
            IfIndex         DWORD ?     ; IF_INDEX
        ENDS
    ENDS

    Next                    QWORD ?     ; Next pointer to struct 
    AdapterName             QWORD ?     ; PCHAR

    FirstUnicastAddress     QWORD ?     ; PIP_ADAPTER_UNICAST_ADDRESS_LH
    FirstAnycastAddress     QWORD ?     ; PIP_ADAPTER_ANYCAST_ADDRESS_XP 
    FirstMulticastAddress   QWORD ?     ; PIP_ADAPTER_MULTICAST_ADDRESS_XP
    FirstDnsServerAddress   QWORD ?     ; PIP_ADAPTER_DNS_SERVER_ADDRESS_XP

    DnsSuffix               QWORD ?     ; PWCHAR
    Description             QWORD ?     ; PWCHAR
    FriendlyName            QWORD ?     ; PWCHAR

    PhysicalAddress         BYTE  MAX_ADAPTER_ADDRESS_LENGTH DUP (?) ; BYTE
    PhysicalAddressLength   DWORD ?     ; ULONG

    Flags                   DWORD ?     ; ULONG
        ; bit 0  = DdnsEnabled
        ; bit 1  = RegisterAdapterSuffix
        ; bit 2  = Dhcpv4Enabled
        ; bit 3  = ReceiveOnly
        ; bit 4  = NoMulticast
        ; bit 5  = Ipv6OtherStatefulConfig
        ; bit 6  = NetbiosOverTcpipEnabled
        ; bit 7  = Ipv4Enabled
        ; bit 8  = Ipv6Enabled
        ; bit 9  = Ipv6ManagedAddressConfigurationSupported

    Mtu                     DWORD ?     ; ULONG
    IfType                  DWORD ?     ; IFTYPE
    OperStatus              DWORD ?     ; IF_OPER_STATUS
    Ipv6IfIndex             DWORD ?     ; IF_INDEX
    ZoneIndices             DWORD 16 DUP (?) ; ULONG
    FirstPrefix             QWORD ?     ; PIP_ADAPTER_PREFIX_XP
    TransmitLinkSpeed       QWORD ?     ; ULONG64
    ReceiveLinkSpeed        QWORD ?     ; ULONG64
    FirstWinsServerAddress  QWORD ?     ; PIP_ADAPTER_WINS_SERVER_ADDRESS_LH
    FirstGatewayAddress     QWORD ?     ; PIP_ADAPTER_GATEWAY_ADDRESS_LH
    Ipv4Metric              DWORD ?     ; ULONG
    Ipv6Metric              DWORD ?     ; ULONG
    Luid                    QWORD ?     ; IF_LUID
    Dhcpv4Server            SOCKET_ADDRESS <> ; SOCKET_ADDRESS
    CompartmentId           DWORD ?     ; NET_IF_COMPARTMENT_ID
    NetworkGuid             BYTE  16 DUP (?) ; NET_IF_NETWORK_GUID
    ConnectionType          DWORD ?     ; NET_IF_CONNECTION_TYPE
    TunnelType              DWORD ?     ; TUNNEL_TYPE
    Dhcpv6Server            SOCKET_ADDRESS <> ; SOCKET_ADDRESS
    Dhcpv6ClientDuid        BYTE  MAX_DHCPV6_DUID_LENGTH DUP (?) ; BYTE
    Dhcpv6ClientDuidLength  DWORD ?     ; ULONG
    Dhcpv6Iaid              DWORD ?     ; ULONG
    FirstDnsSuffix          QWORD ?     ; PIP_ADAPTER_DNS_SUFFIX

IP_ADAPTER_ADDRESSES_LH ENDS

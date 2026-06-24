; Simplified for my personal use (adapter name and IP addresses only)
; Two versions

SOCKET_ADDRESS STRUCT
    lpSockaddr              QWORD ?     ; LPSOCKADDR
    iSockaddrLength         DWORD ?     ; INT
    Padding                 DWORD ?     ; 4 bytes for alignment
SOCKET_ADDRESS ENDS

; Version 1
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
IP_ADAPTER_ADDRESSES_LH ENDS

; Version 2 - most likely to assemble
IP_ADAPTER_ADDRESSES_LH STRUCT
    Alignment               QWORD ?     ; ULONGLONG

    Next                    QWORD ?     ; Next pointer to struct 
    AdapterName             QWORD ?     ; PCHAR

    FirstUnicastAddress     QWORD ?     ; PIP_ADAPTER_UNICAST_ADDRESS_LH
    FirstAnycastAddress     QWORD ?     ; PIP_ADAPTER_ANYCAST_ADDRESS_XP 
    FirstMulticastAddress   QWORD ?     ; PIP_ADAPTER_MULTICAST_ADDRESS_XP
    FirstDnsServerAddress   QWORD ?     ; PIP_ADAPTER_DNS_SERVER_ADDRESS_XP

    DnsSuffix               QWORD ?     ; PWCHAR
    Description             QWORD ?     ; PWCHAR
    FriendlyName            QWORD ?     ; PWCHAR
IP_ADAPTER_ADDRESSES_LH ENDS

; Data segment
adapter IP_ADAPTER_ADDRESSES_LH <>

MAX_ADAPTER_NAME_LENGTH EQU 256
MAX_ADAPTER_DESCRIPTION_LENGTH EQU 128
MAX_ADAPTER_ADDRESS_LENGTH EQU 8

PIP_ADDR_STRING TYPEDEF PTR IP_ADDR_STRING

IP_ADDR_STRING STRUCT
    Next        PIP_ADDR_STRING ?
    IpAddress   BYTE 16 DUP (?)
    IpMask      BYTE 16 DUP (?)
    Context     DWORD ?
IP_ADDR_STRING ENDS

PIP_ADAPTER_INFO TYPEDEF PTR IP_ADAPTER_INFO

IP_ADAPTER_INFO STRUCT
    Next                PIP_ADAPTER_INFO ?
    ComboIndex          DWORD ?
    AdapterName         BYTE  MAX_ADAPTER_NAME_LENGTH + 4 DUP (?)
    Description         BYTE  MAX_ADAPTER_DESCRIPTION_LENGTH + 4 DUP (?)
    AddressLength       DWORD ?
    Address             BYTE  MAX_ADAPTER_ADDRESS_LENGTH DUP (?)
    Index               DWORD ?
    Type                DWORD ?
    DhcpEnabled         DWORD ?
    CurrentIpAddress    PIP_ADDR_STRING ?
    IpAddressList       IP_ADDR_STRING <>
    GatewayList         IP_ADDR_STRING <>
    DhcpServer          IP_ADDR_STRING <>
    HaveWins            DWORD ?
    PrimaryWinsServer   IP_ADDR_STRING <>
    SecondaryWinServer  IP_ADDR_STRING <>
    LeaseObtained       QWORD ?
    LeaseExpires        QWORD ?
IP_ADAPTER_INFO ENDS

; Allocate a buffer
pAdapterInfo PIP_ADAPTER_INFO ?

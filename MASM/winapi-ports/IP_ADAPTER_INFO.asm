; Values as defined by iptypes.h
MAX_ADAPTER_ADDRESS_LENGTH EQU 8
MAX_ADAPTER_DESCRIPTION_LENGTH EQU 128
MAX_ADAPTER_NAME_LENGTH EQU 256

; PIP_ADDR_STRING: Pointer to an IP_ADDR_STRING structure
PIP_ADDR_STRING TYPEDEF PTR IP_ADDR_STRING

IP_ADDR_STRING STRUCT
    Next        PIP_ADDR_STRING ?   ; Pointer to next IP_ADDR_STRING struct
    IpAddress   BYTE 16 DUP (?)     ; char array
    IpMask      BYTE 16 DUP (?)     ; char array
    Context     DWORD ?             ; DWORD
IP_ADDR_STRING ENDS

; PIP_ADAPTER_INFO: Pointer to an IP_ADAPTER_INFO structure
PIP_ADAPTER_INFO TYPEDEF PTR IP_ADAPTER_INFO

IP_ADAPTER_INFO STRUCT
    Next                PIP_ADAPTER_INFO ?  ; Pointer to next IP_ADAPTER_INFO structure
    ComboIndex          DWORD ?             ; DWORD
    AdapterName         BYTE  MAX_ADAPTER_NAME_LENGTH + 4 DUP (?) ; char array
    Description         BYTE  MAX_ADAPTER_DESCRIPTION_LENGTH + 4 DUP (?) ; char array
    AddressLength       DWORD ?             ; UINT
    Address             BYTE  MAX_ADAPTER_ADDRESS_LENGTH DUP (?) ; BYTE
    Index               DWORD ?             ; DWORD
    Type                DWORD ?             ; UINT
    DhcpEnabled         DWORD ?             ; UINT
    CurrentIpAddress    PIP_ADDR_STRING ?   ; PIP_ADDR_STRING
    IpAddressList       IP_ADDR_STRING <>   ; Linked list of IP_ADDR_STRING structures
    GatewayList         IP_ADDR_STRING <>   ; Linked list of IP_ADDR_STRING structures
    DhcpServer          IP_ADDR_STRING <>   ; Linked list of IP_ADDR_STRING structures
    HaveWins            DWORD ?             ; BOOL
    PrimaryWinsServer   IP_ADDR_STRING <>   ; Linked list of IP_ADDR_STRING structures
    SecondaryWinsServer IP_ADDR_STRING <>   ; Linked list of IP_ADDR_STRING structures
    LeaseObtained       QWORD ?             ; time_t (64-bit)
    LeaseExpires        QWORD ?             ; time_t (64-bit)
IP_ADAPTER_INFO ENDS

; Allocate a buffer
pAdapterInfo PIP_ADAPTER_INFO ?

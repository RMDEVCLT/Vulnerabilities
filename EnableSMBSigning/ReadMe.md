
# Caution

SMB is signed when:

- Both the SMB client and server have `RequireSecuritySignature` set to `1`.
- The SMB client has `RequireSecuritySignature` set to `1` and the server has `RequireSecuritySignature` set to `0`.
- The SMB server has `RequireSecuritySignature` set to `1` and the client has `RequireSecuritySignature` set to `0`.

Be careful when enabling this feature:
- This could impact performance in your voice servers, file servers, Exchange servers, and databases if you start requiring SMB signing.
- It is unclear by Microsoft if the requirement of signing is equivalent to requiring encryption or vice versa.

[Microsoft warns about performance issues](https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/reduced-performance-after-smb-encryption-signing)

In short, just disable SMBv1 and make sure everyone else on the network is using SMB dialect 3.x to minimize the impact of not requiring SMB signing.

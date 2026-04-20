# ⚠️ Troubleshooting & Lessons Learned

During the integration of CentOS 10 Stream with Windows Server 2025 Active Directory, several network, routing, and DNS challenges were encountered. This document outlines those problems, their root causes, and the exact steps taken to resolve them.

---

## Issue 1: DNS Resolution Timeout & Package Download Failures
**Symptoms:** When running `yum install` or `realm join`, the CentOS machine could not reach the internet or download packages, even though it could ping the internal Windows Server.

**Root Cause:** The CentOS machine's DNS was pointed strictly to the Windows Domain Controller (`172.22.218.10`). However, the Windows DNS Server did not know how to resolve external internet queries (like `google.com` or CentOS mirror sites) because it lacked a forwarder.

**Resolution:**
1. Logged into Windows Server 2025.
2. Opened **DNS Manager** -> Right-clicked the server name -> **Properties** -> **Forwarders** tab.
3. Added Google's Public DNS (`8.8.8.8` and `8.8.4.4`).
4. Result: Windows Server began routing unknown external DNS queries to the internet, granting CentOS full package download capabilities.

---

## Issue 2: "Destination Host Unreachable" on External Ping
**Symptoms:** Running `ping 8.8.8.8` from either Windows or CentOS returned a `Destination host unreachable` error.

**Root Cause:** We assigned a manual static IP block (`172.22.218.x`) to our virtual machines. However, VMware Workstation's internal NAT engine (VMnet8) was operating on a completely different, randomly assigned subnet (e.g., `192.168.x.x`). The hypervisor's virtual router did not recognize our custom IP traffic and dropped the packets.

**Resolution:**
1. Opened VMware **Virtual Network Editor** (as Administrator) on the host machine.
2. Selected **VMnet8 (NAT)**.
3. Modified the **Subnet IP** field to strictly match our static network: `172.22.218.0` (with Subnet mask `255.255.255.0`).
4. Clicked **Apply**.
5. Result: The hypervisor aligned with our static IP range, allowing traffic to pass through the NAT gateway to the outside world.

---

## Issue 3: Internet Loss Due to Incorrect Gateway Configuration
**Symptoms:** CentOS machines could not ping the NAT gateway or the internet.

**Root Cause:** Initially, the CentOS network interface's Default Gateway was mistakenly set to its own IP address (`172.22.218.51`), essentially creating a routing loop where traffic never left the machine.

**Resolution:**
1. Reconfigured the network adapter using `nmcli`.
2. Set the Gateway to exactly match the VMware NAT Virtual Router IP, which is always the `.2` address in a VMware NAT setup.
   ```bash
   sudo nmcli device modify ens33 ipv4.gateway 172.22.218.2
   sudo nmcli device up ens33
   ```
## ## Issue 4: Active Directory Connection Refused
**Symptoms:** `realm discover Rdadash.local` command failed or timed out, despite both machines successfully pinging each other.

**Root Cause:** Windows Server 2025 comes with Windows Defender Firewall enabled by default, which aggressively blocks inbound LDAP (389), Kerberos (88), and DNS (53) queries from non-Windows devices.

**Resolution:**

1. Opened Windows Defender Firewall with Advanced Security on the DC.

2. Temporarily disabled the Domain Profile and Private Profile to allow initial handshake and integration testing. 

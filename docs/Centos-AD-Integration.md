# 🚀 Enterprise Integration: CentOS 10 Stream & Windows Server 2025 Active Directory

This documentation outlines the technical process and troubleshooting steps taken to integrate **CentOS 10 Stream** workstations into a **Windows Server 2025** Active Directory (AD) environment (`Rdadash.local`).

## 🏗️ Architecture & Network Topology

To establish a stable connection between Linux and Windows, the following network parameters were used:

* **Domain Controller (DC):** Windows Server 2025
    * **IP Address:** `172.22.218.10`
    * **Role:** DNS, AD DS, Kerberos KDC
* **Linux Clients:**
    * `centos-node1`: `172.22.218.51`
    * `centos-node2`: `172.22.218.52`
* **Virtualization:** VMware Workstation (NAT Mode)
* **Gateway:** `172.22.218.2` (VMware Virtual NAT Interface)

---

## 🛠️ Implementation Workflow

### Step 1: Network & DNS Configuration
The Linux nodes must point to the Windows Domain Controller for all DNS queries to resolve the internal SRV records of Active Directory.

```bash
# Applying static IP and DNS configuration
sudo nmcli device modify ens33 ipv4.addresses 172.22.218.51/24
sudo nmcli device modify ens33 ipv4.gateway 172.22.218.2
sudo nmcli device modify ens33 ipv4.dns 172.22.218.10
sudo nmcli device modify ens33 ipv4.method manual
sudo nmcli device up ens33

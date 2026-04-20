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
```

### Step 2: Install Required Middleware
Install the necessary packages to handle Kerberos authentication and LDAP integration.
```bash
sudo dnf install -y realmd sssd adcli samba-common-tools oddjob oddjob-mkhomedir
```

### Step 3: Discover and Join the Domain
Verify that the domain is reachable, then join the system using a Domain Administrator account.

```bash
# Verify domain visibility
realm discover Rdadash.local

# Join the domain (Prompts for Administrator password)
sudo realm join -U Administrator Rdadash.local
```

### Step 4: Automate User Session Provisioning
Configure the system to automatically create a local home directory (/home/username@domain) the first time an Active Directory user logs in.

```bash
sudo authselect select sssd with-mkhomedir --force
sudo systemctl enable --now sssd
```

## 🧪 Verification
To confirm a successful integration, run the following commands:
### Check Domain Status:

```bash
realm list
# Expected output should include: "configured: kerberos-member"
```

### Test Identity Synchronization:
```bash
id username@rdadash.local
# Expected output should return the user's UID and AD groups.
```


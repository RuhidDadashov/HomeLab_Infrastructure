# Corporate Infrastructure Simulation: "Dadashov-Corp"

## 🚀 Overview
This repository documents the step-by-step implementation of a professional, hybrid IT infrastructure. The goal is to simulate a real-world production environment, demonstrating the integration of **Windows Server (Active Directory)** with **Linux systems**, focused on automation, security, and scalability.

## 🏗️ Architecture Design
The infrastructure is built within an isolated virtual network (VMware), consisting of:

| Role | OS | IP Address | Purpose |
| :--- | :--- | :--- | :--- |
| **Domain Controller** | Windows Server 2025 | `172.22.218.10` | AD, DNS, DHCP, Identity Management |
| **Automation Server** | Ubuntu Server 24.04 | `172.22.218.250` | Ansible, CI/CD, Management |
| **Web/Docker Host** | Ubuntu Server 24.04 | `172.22.218.251` | Hosting Internal Services (Wiki, HR Portal) |
| **Workstation 01** | CentOS (GUI) | `172.22.218.51` | Employee Desktop (Domain Joined) |
| **Workstation 02** | CentOS (GUI) | `172.22.218.52` | Employee Desktop (Domain Joined) |

## 🛠️ Tech Stack
* **Virtualization:** VMware Workstation
* **OS:** Windows Server 2025, Ubuntu, CentOS
* **Networking:** Static IP, DNS, Subnetting
* **Identity:** Active Directory (AD DS)
* **Automation:** Ansible (Planned)

## 🎯 Current Status: Phase 1 (Core Networking & Identity)
- [x] Infrastructure Design & Documentation
- [x] Static IP Configuration (Ubuntu Servers)
- [ ] Windows Server IP Realignment & AD Sync
- [ ] CentOS Workstation Deployment
- [ ] Linux-Windows Domain Integration

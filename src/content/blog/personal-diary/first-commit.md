---
author: Jeromino
pubDatetime: 2024-10-04T18:46:00Z
title: First Commit
slug: first-commit
featured: true
draft: false
tags:
  - docs
  - ssh
  - terminal
  - bash
description:
  SSH--Access denied, please try again later. A reminder for me, and anyone facing the same issue
---


While setting up a good Content Managment System for **Artorias Devlog**, I ran into an issue that left me scratching my head for hours. I needed to log in as root through SSH to proceed with the installation. SSH (Secure Shell) is a protocol used to securely connect to remote servers over a network. It allows you to execute commands, transfer files, and manage servers as if you were directly accessing them.

Logging in as root with SSH gives you full administrative access to the server, allowing you to perform system-level tasks like installing software, configuring services, or managing files that require elevated permissions. However, when I tried logging in with:
```bash
ssh root@127.0.0.1
```
and entered my password, I was greeted with the message '**Permission denied, try again later**'


## Table of contents


# Steps I Tried
Naturally, I began troubleshooting and took the following steps:

Checked SSH service status:
```bash
$ systemctl status ssh
```
The output showed that the SSH server was active and running.

Searching through [StackOverflow](https://stackoverflow.com/) found that the `PermitRootLogin` option has to be enabled in the `/etc/ssh/sshd_config` file, so i changed it aaaaaand, no luck.

Reinstalled SSH: I thought maybe the SSH installation was broken, so I removed and reinstalled it:

```bash
$ sudo apt remove openssh-server openssh-client
$ sudo apt install openssh-client
```

During the installation, I encountered a message that caught my attention:

```bash
A new version (/tmp/tmp.kPqB9MD77t) of configuration file /etc/ssh/sshd_config is available, but the version installed currently has been locally modified.
What do you want to do about modified configuration file sshd_config?
- Install the package maintainer's version
- Keep the local version currently installed
- Show the differences between the versions
- Show a side-by-side difference between the versions
- Show a 3-way difference between available versions
- Do a 3-way merge between available versions
- Start a new shell to examine the situation
```
I figured this could be part of the issue, since i made changes in the `/sshd_config` file. I chose "Install the package maintainer's version".

Still no luck.

Generated and added SSH keys: I tried creating a new SSH key and adding it to the authorized keys for root.
The ssh-keygen command generates a public and private key pair. The private key is kept on the local computer, and the public key is uploaded to the remote server.

```bash
$ ssh-keygen
$ Generating public/private rsa key pair.
Enter file in which to save the key (/your_home/.ssh/id_rsa):
```
Pressed enter to save the key pair into the .ssh/ subdirectory in my home directory.

Added the user's public SSH key to the root user's list of authorized keys. By doing this, you allow the user (or anyone with the corresponding private key) to log in as the root user via SSH without needing to enter a password:

```bash
$ cat /home/user/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
```

But even after this, I was still getting the same permission denied message when trying to log in.

# The fix

After scouring Google, Stack Overflow, ServerFault, and AskUbuntu, I finally stumbled across a solution in the [Red Hat documentation](https://www.redhat.com/es/solutions/linux-standardization?sc_cid=7015Y0000045AZGQA2&gad_source=1&gclid=Cj0KCQjwpP63BhDYARIsAOQkATYH4rHZqT64_YI17dn5LR5-xABe4BWLOHUawVNhi_9bTJGZwIyKwfsaAuT8EALw_wcB). It turns out that after making changes to the sshd_config file, you need to restart the SSH service.

I used:

```bash
$ sudo systemctl restart sshd
```

And boom! I was able to log in as root without any issues. Rookie mistake—but one I won't forget anytime soon.

Hopefully, this post serves as a reminder for me (and anyone else) to restart SSH after modifying its configuration. It’s a small step but one that can save hours of frustration!

<Hr />

# TL;DR

While setting up a CMS for **Artorias Devlog**, I couldn't log in as root via SSH despite the service running and trying various fixes (reinstalling SSH, checking `sshd_config`, generating SSH keys). The issue persisted with a "Permission denied" error.

After much troubleshooting, I found that the solution was simple: **restart the SSH service** after making changes to `sshd_config` with:

```bash
$ sudo systemctl restart sshd





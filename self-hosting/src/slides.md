---
theme: seriph
class: text-center
background: none
highlighter: shikiji
lineNumbers: false
favicon: /quackers.png
info: |
  Hacker Toolbox: Self Hosting
drawings:
  persist: false
download: true
transition: fade
title: "Hacker Toolbox: Self Hosting"
mdc: true
fonts:
  sans: "Inter Tight"
  serif: "Inter Tight"
  mono: "Jetbrains Mono"
layout: center
---

# Hackers' Toolbox: **Self Hosting**
Three Easy Pieces


---
layout: center
---

# Slides
Thanks to zhongfu for the initial iteration!

Slides and materials are in the wiki!

[https://hckr.cc/wiki](https://hckr.cc/wiki)

<img src="/slides_link.png" class="m-11 h-60" />

---
layout: center
---

Hi I'm **Chun Yu**! My GitHub is: https://github.com/gunbux/

* I'm a Y4 CS undergraduate that enjoys hacking and building systems

---
layout: center
---

# Prerequisites

* **Some** basic knowledge of the command line
* A remote environment we can play with (we have one set up already!)

---
layout: center
---

## What we **will** cover

1. What is Self-Hosting?
2. Setting up your own server
3. Running services on your server
4. Monitoring your server

---
layout: two-cols
class: self-center px-10
---

## What is Self Hosting?

The act of **providing or serving digital content or an online service**, typically delivered by a business.

The service or content is generally served locally from your own hardware. Often "self-hosters" use older Enterprise-grade hardware from their home internet connections however they also use other hosting providers hardware. This is still considered self-hosting.

::right::

![self-hosting](/self-hosting.png)

---
layout: center
---

# Why do we ever want to **self host**? Why not just pay for someone to do it for me?

- It’s great for learning!
- Self-custody of your own data (this is limited with VPS)
- Run servers/services that aren’t available as a SaaS
- Get fine-grained control over your service (great for debugging personal projects)

---
layout: cover
background: none
---

# Step 1: Setting up a server

---
layout: two-cols
class: px-5 py-20
---

## No-cost options

For small projects, or for people who just want to get started, this is a great way to learn without breaking the wallet!

[https://github.com/cloudcommunity/Cloud-Free-Tier-Comparison](https://github.com/cloudcommunity/Cloud-Free-Tier-Comparison)

::right::

![no-cost](/no-cost.png)

---
layout: center
---

## Cheap Virtual Private Servers (VPS)

A **virtual private server**, also known as a VPS, acts as an isolated, virtual environment on a physical server, which is owned and operated by a cloud or web hosting provider.

You can use your student email to get free credits for popular VPS providers, or if you want to go cheap, lesser known VPS, there’s always [lowendbox.com](lowendbox.com)

---
layout: center
---

## Procuring your own hardware!

- You can use anything as your server!
    - Old Laptops
    - Cheap NAS
    - Single Board Computers (Raspberry Pi)
    - Second-hand mini-pcs

---
layout: cover
background: none
---

# Setting up our servers for the workshop

---
layout: center
---

## Setting up your own server

For the ease of teaching this workshop, we’ll be using a **VPS**. While this strays away from a lot of the “self-custody of your data” side of self-hosting, it’s the easiest way for us to teach overarching concepts of self-hosting, and you can apply this to your own hardware.

---
layout: two-cols
class: px-5 self-center
---

## Servers for the workshop

The Cubiclerebels is a collective of multi-disciplinary senior software engineers who love to build and host applications and platforms.

We also run The Little Host, a fully independent hosting provider with our own Autonomous System (ASN 151361)

They've kindly provided the VPS for purposes of this workshop, do check them out!

::right::

<img src="/cubiclerebels.png" class="m-10 h-60" />

---
layout: center
---

Let's start by ssh-ing into our server:

```
ssh <username>:<ip-address>
```

You should have an IP address provided, and your username should be `nus`. You should also be prompted to enter a password.

What is **SSH**? SSH is a secure shell that allows you to connect and run commands on a remote server securely.

---
layout: center
---

## Creating you own user and disabling root login

This is important if you are logged into your server as **root.** As root is a common username, there will be people enumerating through common usernames on every possible IP address just to try their luck and compromise servers.

```bash
sudo passwd # Change your password
```

With that said, we also want to disable root login for the same reason

- Creating a new user with `useradd` and `passwd`

```bash
useradd -m -d /home/<username> <username> # Add user
usermod -a -G sudo,adm <username> # Give permissions
sudo passwd <username> # To create a password for the user
```

---
layout: center
---

## Setting up SSH Keys

Keys are a secure way to log into remote computers without using passwords. Here's a simple explanation:
* SSH keys come in pairs: a public key and a private key
* The public key is like a padlock that you put on the remote server
* The private key is like the key to that padlock, which you keep on your local computer
* When you try to log in, your computer uses the private key to prove it can "unlock" the padlock
* **If successful, the server lets you in without asking for a password**

---
layout: center
---

## Adding your SSH keys

On your **host** machine (your laptop, not your ssh server):

```bash
ssh-keygen -t ed25519
```

On your **remote** machine:

```bash
su <username>
mkdir .ssh
nano .ssh/authorized_keys
## Paste in your public key
chmod -R go-rwx .ssh
```

---
layout: center
---

## SSH Hardening

- `sudo nano /etc/ssh/sshd_config`
- Make sure that `PermitRootLogin` is set to something like `prohibit-password`
- (Optional) Disable password logins, if you're very sure you can take care of your keypair:
`PasswordAuthentication no`. Otherwise,
maybe just leave them on for now especially if you have no way of recovering
- Then, `systemctl restart ssh`

---
layout: cover
background: none
---

# Break Time!


---
layout: cover
background: none
---

# Step 2: Running some services

---
layout: center
---

## Keeping your system up to date

To ensure your system is always up to date with the latest packages, do:

```bash
sudo apt-get update && sudo apt-get upgrade
```
You should do this if you are about to install a package as well, otherwise the package manager will complain.

---
layout: center
---

## Activities: Hosting a web page

- `nginx` is a great web server for these things, but you can pick whatever you want, or are
more familiar with
- On Ubuntu, this is pretty simple: apt install nginx
- Enable it and start it: `sudo systemctl enable nginx`, `sudo systemctl start nginx`
- Open up your browser and head to http://host/ — you should see a page there
- edit files in /var/www/html/..., etc: try replacing index.html? with "hello world"
- check http://host/ again

---
layout: center
---

## Cronjobs

One of the best things about a server is that it's meant to run 24/7, something that our laptops or desktops aren't great at doing. This means it's really good at running things constantly at a scheduled interval. To do such a thing, we'll use something known as cron jobs.

- Cron is a scheduling daemon that executes tasks at specified intervals.
- These tasks are called cron jobs and are mostly used to automate system maintenance or administration.

---
layout: center
---

## Cron jobs
The crontab command allows you to install, view , or open a crontab file for editing:

- `crontab -e` - Edit crontab file, or create one if it doesn’t already exist.
- `crontab -l` - Display crontab file contents.
- `crontab -r` - Remove your current crontab file.
- `crontab -i` - Remove your current crontab file with a prompt before removal.
- `crontab -u <username>` - Edit other user crontab file. This option requires system administrator privileges.

---
layout: center
---

## Cron Syntax

- [https://crontab.guru/](https://crontab.guru/)

```
Syntax:
* * * * * command(s)
- - - - -
| | | | |
| | | | ----- Day of week (0 - 7) (Sun=0 or 7)
| | | ------- Month (1 - 12)
| | --------- Day of month (1 - 31)
| ----------- Hour (0 - 23)
------------- Minute (0 - 59)

Example:
*/5 * * * * /path/to/script.sh # Run every 5 minutes
```

---
layout: center
---

## Activities

- We have an API that gives us the 24 hour weather forecast in Singapore. We want to:
  - Check this forecast every morning.
  - If it's about to rain, send us an alert. For simplicity, lets send a telegram message!

```bash
## To quickly get the script:
wget https://raw.githubusercontent.com/nushackers/hackertools_materials/refs/heads/main/self-hosting/src/scripts/cron.sh
```

- To get a telegram bot id, just go to @BotFather, and create a new bot, enter the token we receive inside
- To get your chat id, just go to @getmyid_bot and copy your chat id there
- You'll need to start a chat with your bot first, go to your bot and do '/start' before you try running the script

---
layout: center
---

Let's make it run every morning at 9am!
```bash
0 9 * * * /path/to/cron.sh
```

---
layout: center
---

## Activities

- Try modifying the cron job to run every minute.
- Let's extend that further: Can we make it run every day, every hour, on the hour,
from 8 AM through 4 PM?

---
layout: center
---

## Activities

- Try creating a cron job that runs every minute and prints out the current time.
- **Solution: `0 * * * * /path/to/cron.sh`**
- Let's extend that further: Can we make it run every day, every hour, on the hour,
from 8 AM through 4 PM?
- **Solution: `00 08-16 * * * /path/to/cron.sh`**
- Try doing this with a bunch of APIs! Here's a few:
https://github.com/jackveiga/singapore-apis

---
layout: center
---

## Other things you should try:

* File syncing with Syncthing
* Hosting your own VPN
* Hosting your own LLM using Ollama
* Hosting your own game servers

---
layout: cover
background: none
---

# Step 3: Monitoring

---
layout: center
---

## `systemd`

So now we want to be able to navigate, operate and monitor our system. To do this, most servers have a relatively homogenous system: `systemd`!

`systemd` is a software suite that provides an array of system components for Linux operating systems. The main aim is to unify service configuration and behavior across Linux distributions.

---
layout: center
---

## `systemctl`

- Many modern Linux distros go with systemd — it can handle services for you in a convenient manner
- It comes with systemctl, along with a lot of other things but we'll want to focus on systemctl
- Start services: `systemctl start unit.service`
- Stop services: `systemctl stop unit.service`
- Check service status: `systemctl status unit.service`

---
layout: center
---

## `journalctl`

`journalctl` is a utility for querying and displaying logs from journald, systemd’s logging service.

To see live logs:

```bash
journalctl -f
```

To see the first 20 lines

```bash
journalctl -n 20
```

---
layout: center
---

## `journalctl`

To check a specific service:

```bash
journalctl -u sshd
```

To get all logs from last boot

```bash
journalctl -b
```

To filter by time (last 15 minutes for example)

```bash
journalctl --since "15 minutes ago"
```

---
layout: center
---

## Monitoring
- `top`, `htop` and how to use them
- Searching and killing resources

---
layout: center
---

## What is top?
- top command is used to show the Linux processes. It provides a dynamic real-time view of the running system.
- Think of it as a super powerful task manager for Linux.

> `htop` is a much nicer and user-friendly alternative to `top`. To try it out, do `sudo apt-get install htop`

---
layout: center
---

## Basic Usage

- Just type `top` to start the program.
- Pressing q will simply exit the command mode.
- Pressing h will show you the help menu.

---
layout: two-cols
class: px-5 self-center
---

## What does everything mean?

* PID: Shows task’s unique process id.
* PR: The process’s priority. The lower the number, the higher the priority.
* VIRT: Total virtual memory used by the task.
* USER: User name of owner of task.
* %CPU: Represents the CPU usage.

::right::

* TIME+: CPU Time, the same as ‘TIME’, but reflecting more granularity through hundredths of a second.
* SHR: Represents the Shared Memory size (kb) used by a task.
* NI: Represents a Nice Value of task. A Negative nice value implies higher priority, and positive Nice value means lower priority.
* %MEM: Shows the Memory usage of task.
* RES: How much physical RAM the process is using, measured in kilobytes.
* COMMAND: The name of the command that started the process.

---
layout: center
---

## Activities
- [Cheatsheet](https://gist.github.com/ericandrewlewis/4983670c508b2f6b181703df43438c37)

(**Warning**: Kill processes on your machine at your own risk! Make
sure you know what you're killing)

- Try running `top` and see what you can find out about your system!
- What are the top 5 processes using the most CPU?
- What would I press if I want to kill the processes using the most memory?
- I want to see what processes start running when I start my computer.
How would I do that?

---
layout: center
---

## Solution

- What are the top 5 processes using the most CPU?
    - `top` -> `Shift + P`
- What would I press if I want to kill the processes using the most memory?
    - `top -> Shift + M` -> `k`
- I want to see what processes start running when I start my computer.
    - `top` -> `f` -> `PID` -> `s` -> `q` -> `Shift + R`

---
layout: center
---

# And that's it!

---
layout: center
---

## Feedback Form

Let us know your thoughts on this workshop!

<img src="/feedback.png" class="m-10 h-60" />

---
layout: cover
background: none
---

# What's next?


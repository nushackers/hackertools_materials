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


---
layout: center
---

# Slides
Thanks to zhongfu for the initial iteration!

[https://nushackers.github.io/hackertools_materials/self-hosting](https://nushackers.github.io/hackertools_materials/self-hosting)

<img src="/slides_link.png" class="m-10 h-60" />

---
layout: center
---

Hi I'm **Chun Yu**! My GitHub is: https://github.com/gunbux/

* I'm a Y3 CS undergraduate that enjoys hacking and building systems
* I play the violin (sometimes)

---
layout: center
---

# Prerequisites

* **Some** basic knowledge of the command line
* A remote environment we can play with (we'll set one up together later)

---
layout: center
---

## What we **will** cover

* Motivations of Self-Hosting
* How to set up your own server
* Hardening your server
* Basic server administrations
* Setting up your own services

---
layout: two-cols
class: self-center px-10
---

## What is Self Hosting?

**Self Hosting** is essentially is the practice of locally hosting (on premises & private web servers) and managing software applications by a person or organization.

**Homelabbing** is probably a lesser-known term, but it's basically just setting up a "lab" at
home to experiment with "enterprise-y" things

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

# Step 1: Procuring a server

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

# Step 2: Setting up your own server

---
layout: two-cols
class: px-5 self-center
---

## Setting up your own server

For the ease of teaching this workshop, we’ll be using a **VPS**. While this strays away from a lot of the “self-custody of your data” side of self-hosting, it’s the easiest way for us to teach overarching concepts of self-hosting, and you can apply this to your own hardware.

In this workshop, I’ll use **Google Cloud Platform** as our platform of choice.

https://console.cloud.google.com

::right::

![console](/console.png)

---
layout: center
---

## Steps

- You’ll need to add billing information in order to get started. Don’t worry though, you’ll only get a test charge, it’s only for verification purposes
- Click on “Create a VM”
- Select Billing Account
- Allow Compute Engine. This will take awhile
- Create a new e2-micro instance. Don’t worry about the giant bill on the right side, Google should waive all costs for it unless you have multiple e2-micro instances running.
- When selecting a boot disk, make sure to select Ubuntu
> Note: For GCP Always Free, make sure your region is `us-west1`, `us-central1`, or `us-east1`


You should now have your own “server”!

---
layout: center
---

## IP Addresses and Networking

Once you have a server set up, we want to go to https://console.cloud.google.com/networking/addresses/list, and promote our IP addresses to be static.

An **IP Address** is essentially a “Unique ID” assigned to your server and *how you locate different servers across the internet*. Generally, you want to have a static IP address, that is, you IP address doesn’t change over time (some ISPs and Cloud Providers return the IP Addresses to a pool of reserved IP Addresses to be reused)

---
layout: center
---

Now you can ping your own server! Try opening up a command line and doing:

```bash
ping <ip-address>
```

---
layout: center
---

## Domain Names
So, now we’ve got a server up and a way to access it. But you notice an IP address is kind of ugly and hard to remember… that’s where **domain names** come into play! If you’ve ever typed a website URL, you’ve effectively typed a domain name.

Well, how do IP Addresses turn into domain names? All you need to know is there are a lot of servers out there maintaining a large table of IP addresses to domain name mappings. These are known as **DNS servers**.

---
layout: center
---

## Getting your own domains

For purposes of this workshop, if you have the Github Student Developer Pack, you should be able to get a domain name from .tech for free for a year.

https://get.tech/github-student-developer-pack

If you want to get a cool domain name, you can use this to compare prices from different registrars:

https://tld-list.com

---
layout: two-cols
class: px-5 self-center
---

Every domain will have the following structure

```
<domain name>:<tld>
nushackers.org
```

::right::

For every domain, you can also have a bunch of records for **subdomains**

```
www.nushackers.org (www subdomain)
school.nushackers.org (school subdomain)
```

---
layout: center
---

## Configuring your own DNS Records

We’ll start by creating a bunch of A records:

- Leaving the hostname blank will just lead to the main domain
- Add * as the hostname will route all empty subdomains to a single address
- Time to Live (TTL) is a field on DNS records that controls how long each record is valid and — as a result — how long it takes for record updates to reach your end users.

> The industry standard is to use Cloudflare DNS, they have some great features such as Proxying.

Now, you have a cool domain for your server!

---
layout: cover
background: none
---

## Step 3: Hardening your server
Now we’ve got the high-level stuff out of the way, it’s time to actually work on our server!

---
layout: center
---

## Creating you own user and disabling root login

This is important if you are logged into your server as **root.** As root is a common username, there will be people enumerating through common usernames on every possible IP address just to try their luck and compromise servers. In GCP, they'll probably give you a non-root account to start with.

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

## SSH Hardening

- `sudo nano /etc/ssh/sshd_config`
- Make sure that `PermitRootLogin` is set to something like `prohibit-password`
- (Optional) Disable password logins, if you're very sure you can take care of your keypair:
`PasswordAuthentication no`. Otherwise,
maybe just leave them on for now especially if you have no way of recovering
- Then, `systemctl restart ssh`

---
layout: center
---

## Keygen

Without going into details into public/private key, it basically gives you a way to
identify yourself to server without a password

- `ssh-keygen -t rsa -b 4096`
- `ssh-keygen -t dsa`
- `ssh-keygen -t ecdsa -b 521`
- `ssh-keygen -t ed25519`

---
layout: center
---

## Keygen

You can then give your public keys to trusted servers to allow you to connect to them
without password auth.

```bash
ssh-copy-id -i ~/.ssh/tatu-key-ecdsa user@host
```

---
layout: center
---

## Using `scp`

The `scp` command is a special command that uses `ssh` to securely copy files between
local and host machines.

```bash
# Copy from remote location to local directory
scp [options] username@source_host:directory/filename1 <local directory>

# Copy from local directory to remote location
scp [options] <local directory> username@source_host:directory/filename1
```

---
layout: center
---

## Activities

Before we move on, let's quickly get some recap and practice:

- If you haven't already, set up your ssh keys on your remote
- Let's try copying a file from our local machine over to our server using `scp`

---
layout: center
---

## Setting up SSH keys for SSH access (Summary)
While some service providers have a webshell, it’s much nicer to be able to work in your own terminal (and significantly less laggy).

- `ssh-keygen -t ed25519`
- After that, take the pubkey string, then:
- `mkdir .ssh`
- `nano .ssh/authorized_keys`
- paste in pubkey string or use ssh-copy-id
- `chmod -R go-rwx .ssh`

> Note: This is a manual way of adding keys, some cloud providers have automatic ways that screw with this. (ahem ahem GCP)

---
layout: center
---

## Firewalls

Some service providers have built-in firewalls on their dashboard. Otherwise you would need a command-line equivalent like `firewalld` or `ufw` for this.

- Important Ports to open
    - SSH
    - HTTP/HTTPS
    - 8443, 8081 for telegram bots

For GCP, we can configure our firewall here:
https://console.cloud.google.com/net-security/firewall-manager

---
layout: cover
background: none
---

# Break Time!

---
layout: cover
background: none
---

# Step 4: Basic System Administration

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
layout: cover
background: none
---

# Running some services

---
layout: center
---

## Cronjobs

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

> `htop` is a much nicer and user-friendly alternative to `top`. To try it out, do `sudo apt-get install htop`

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
layout: two-cols
class: self-center px-10
---

## Activities

- Here's a script that gets the current traffic incidents live.
- You'll need to request for access and get a key here: https://datamall.lta.gov.sg
- Try creating a cron job that runs every hour and gets the traffic incidents
- Let's extend that further: Can we make it run every day, every hour, on the hour,
from 8 AM through 4 PM?

::right::

```bash
#!/bin/bash

# The URL to fetch data from
URL="http://datamall2.mytransport.sg/ltaodataservice/TrafficIncidents"
ACCOUNT_KEY="Enter your key"

# The location to save the fetched data
OUTPUT_FILE="/path/to/traffic_incidents_$(date +'%Y-%m-%d_%H%M%S').json"

# Use curl to fetch data, including the AccountKey in the header for authorization
curl -X GET "$URL" -H "accept: application/json" -H "AccountKey: ${ACCOUNT_KEY}" -o "$OUTPUT_FILE"

```

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

## Activities: Try running a telegram bot!

Here's a cool bot: https://github.com/Devanshshah1309/nusmods-bot.git
Let's run it!

* Find the ports required to run the telegram bot and open it in our firewall (443, 80, 8443, 8001)
* Install some dependencies
```bash
sudo apt-get install git python3 python3-pip
pip3 install python-telegram-bot requests
```
* Clone the repository
```bash
git clone https://github.com/Devanshshah1309/nusmods-bot.git
```
* Get a bot token from @BotFather
* Edit the script and run and detach it.
```bash
python officialNUSmodsBot.py & # The & tells the shell to run in background
```

---
layout: center
---

## Other things you should try:

* Hosting your own LLM using Ollama
* Hosting your own game servers

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


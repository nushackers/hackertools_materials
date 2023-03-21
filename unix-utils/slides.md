% Unix Utilities
% [![](../nushackers_svg.svg){.logo-img style="height: 5ex;"}](https://nushackers.org){target="_blank"}
% 21st March, 2023

---

## Slides

https://hckr.cc/ht-unix-slides

---

## Overview

* SSH, Keygen, scp, tmux/screen, cronjobs, top
* Today's focus is on the tools and what you can do with them.

---

## SSH

---

## What is SSH

SSH stands for Secure SHell.
It is intended as a secure replacement for telnet, rsh, rlogin, as well as ftp.
SSH also can serve as a secure conduit through which other services can be encrypted.

---

## Why does it matter to ME?

It has become more and more common for programmers to use remote servers in their everyday work.
If you need to use remote servers in order to deploy backend software or you need a server with higher computational capabilities,
you will end up using SSH.

---

## How does it work?

To `SSH` into a server you execute a command as follows

    ssh foo@stu.comp.nus.edu

we are trying to login to our *host* with *hostname*: `stu.comp.nus.edu` *user* `foo`

---

## Using SSH

+---------+-------------------------+
| Flags   | Details                 |
+=========+=========================+
| -4      | Forces IPv4             |
+---------+-------------------------+
| -6      | Forces IPv6             |
+---------+-------------------------+
| -i      | Specify identity file   |
+---------+-------------------------+
| -p      | Specify port            |
+---------+-------------------------+

---

## Zhng your SSH

You can very easily configure your ssh details in a `~/.ssh/config`

    mkdir -p ~/.ssh && chmod 700 ~/.ssh
    touch ~/.ssh/config && chmod 600 ~/.ssh/config

---

## Zhng your SSH

The config file follows this format:

    Host hostname1
      SSH_OPTION value
      SSH_OPTION value

    Host hostname2
        SSH_OPTION value

    Host *
        SSH_OPTION value

---

## Things you can add

| Keyword | Meaning |
| --- | ----- |
| Host | Host name you want to use |
| HostName | Real host name to connect to |
| User | User name |
| Port | Port number |
| ProxyCommand | Command used to connect to server |
| ProxyJump | *Covered later* |

## Special Characters

| Character | Meaning | Examples |
| -: | ----- | -------- |
| * | Matches 0 or more characters | Host * matches all hosts, 192.168.0.* matches from 0-255 |
| ? | Matches *exactly* one char | Host 10.10.0.? matches 10.10.0.[0-9] ONLY. |
| ! | Negates the match | !10.10.0.5 matches anything not 10.10.0.5 |

---

## Special Characters

| Char | Meaning |
| -: | -----|
| %h | Hostname |
| %p | Port |
| %r | Username |

---

## Neat examples

Suppose you are part of a university/entreprise and need to connect to a school server. However, you are required to login via a login node or VPN. Let's set this up in our config.

    Host stu
      HostName %h.comp.nus.edu.sg
      User <enter user>

    Host pe11? pe120
      HostName %h.comp.nus.edu.sg
      ProxyJump stu
      User <enter user>

Since %h is the `Host`, we can quickly append it to our HostName so that we have a shorter alias!

---

## Let's try it out!

- If you have access to a remote server, try configuring your ssh config to that server!

---

## Keygen

Without going into details into public/private key, it basically gives you a way to
identify yourself to server without a password

    - ssh-keygen -t rsa -b 4096 // default
    - ssh-keygen -t dsa
    - ssh-keygen -t ecdsa -b 521
    - ssh-keygen -t ed25519

---

## Keygen

You can then give your public keys to trusted servers to allow you to connect to them
without password auth.

    ssh-copy-id -i ~/.ssh/tatu-key-ecdsa user@host

---

## Using `scp`

The `scp` command is a special command that uses `ssh` to securely copy files between
local and host machines.

    // Copy from remote location to local directory
    scp [options] username@source_host:directory/filename1 <local directory>

    // Copy from local directory to remote location
    scp [options] <local directory> username@source_host:directory/filename1

---

## Activities

Before we move on, let's quickly get some practice:

- If you haven't already, set up your ssh keys on your remote
(try using `scp` instead of ssh-copy-id!)
- If you don't have a remote, but have a GitHub account, try using ssh-keygen to generate a key for GitHub! More details [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

---

## Working dev environment wherever you go!

Congrats! Now that you have a remote to ssh to, you now have a working environment
wherever you go!

- **Termius/Blink** - if you want to try ssh-ing using an iPad and get a dev environment on the go
- **Termux** - if you want even more portability and want to use ssh on your Android device.
- Online ssh clients - be careful with this, you don't want your data to be stolen.

---

## Motivation

Great! We have a nice environment we can work with! How do take this further?

---

## Tmux/Screen

are open-source terminal multiplexers.

It allows multiple terminal sessions to be accessed simultaneously in a single window.

It is useful for running more than one command-line program at the same time.

---

## What are they?

Tmux/screen are programs that allow you to:

- Reattach to your last disconnected session
- Open multiple terminals and send commands to them simultaneously

---

## How to install?

To install either `tmux` or `screen`, just install them from your package manager!

For the purposes of this demonstration, we'll be using tmux,
but they are both interchangeable.

---

## How to use?

- To create and attach to a new instace of tmux, do `tmux`
- To list all instances of tmux, do `tmux ls`
- To attach to the most recent session, do `tmux a`
- To kill a previous session, do `tmux kill-ses`

---

## Great I've attached to a session, what next?

- **Cheatsheet** - [https://tmuxcheatsheet.com](https://tmuxcheatsheet.com)
- Most of the hotkeys start with a **prefix**, by default this is `Ctrl+b`.
- Some people really dislike this, you could change it to something like `Ctrl+a`
in the config.
- To use a certain hotkey, you first enter your prefix, release it, then press the key afterwards.

---

## Basics of Tmux

There are two main concepts in tmux, *windows* and *panes*. For this workshop,
we'll focus on panes (because they are much cooler).

- `Ctrl+b %` - Open a new vertical pane
- `Ctrl+b "` - Open a new horizontal pane
- `Ctrl+b x` - Kill pane
- `Ctrl+b <arrow key>` - Navigate to pane
- `Ctrl+b+<arrow key>` - Resize pane

---

## Cool stuff you can do

- Monitoring your computer while running programs
- Monitoring a log file
- Running a script overnight
- Logging tmux to a file
- Run multiple commands at the same time!

---

## Activities

- By default, you should have some log files at /var/log. Try tailing one of the logs
with `tail -F` and disconnect from tmux and run some things to update the log.
- Extension: Try outputting the result into a file
- Run test script while monitoring your CPU and see what happens!
(**WARNING**: If you have a slow CPU don't run this)

---

## Extension - Plugins and configs

- You can configure tmux to use your mouse
- You can add plugins to your tmux as well
  - Tmux resurrect is a plugin that allows you to restore your tmux sessions
even *after a reboot*

---

## Files and how they work

- Files and how they work
- Linux file structure
- Some *special* files
- Symlinks

---

## How do we read `ls` output?

    total 5416
    drwxr-xr-x  2 chun chun    4096 Mar 17 11:19 .
    drwxr-xr-x 12 chun chun    4096 Mar  3 02:38 ..
    -rw-r--r--  1 chun chun 5472298 Mar 17 11:19 f2c69c43-8b85-4ae0-8575-3f34a1e36587.pdf
    -rw-r--r--  1 chun chun   19217 Mar 16 02:44 fs-layout.png
    -rw-r--r--  1 chun chun   21615 Mar 21 08:58 index.html
    -rw-r--r--  1 chun chun     351 Mar  3 02:44 Makefile
    -rw-r--r--  1 chun chun    8895 Mar 21 08:58 slides.md

---

## How files work

- The `d` initially indicates that it is a directory/folder.
- The next 9 characters are called **permission bits** and indicate the permissions of
the file.
- The next 2 characters are the number of hard links to the file.
- The next 2 characters are owner and group to whom the file belongs to.

---

## Permission bits

- Permission bits follow this format:
```
    Format:   rwxrwxrwx
    Example:  rwxr-xr-x
    Category: UUUGGGOOO
```
- rwx - read, write, execute
- First three bits are for user, then group, then owner
- You can change the permissions of a file using `chmod`
```
    chmod u=rw,og=r new_file.txt
    chmod a+x new_script.sh
```

---

## A much faster way to `chmod`

- You can think of the permission bits as 1 and 0s.
```
    Example
    Perms:  rwx r-x r-x
    Binary: 111 101 101
    Decimal:  7   5   5
```
- Let's say I want the file to give rwx access to all users.
```
    rwx rwx rwx
    111 111 111
      7   7   7
```
- We can just do `chmod 777 <filename>` to change the permissions as such.

---

## The Linux filesystem

![](fs-layout.png){style="height: 20ex;"}

---

## Special files to play with in Linux/Unix systems

- We can play with the sysfs file system mounted under `/sys`.
sysfs exposes a number of kernel parameters as files, so that you can easily reconfigure the kernel on the fly without specialized tools.
- The `/proc` file system is another psuedo-filesystem which provides an interface to
kernel data structures

---

## Activities

If you have a laptop running Unix system locally, you probably have a /sys/class system file!

Play with it, see if you can:

- Get battery information
- Change your screen's backlight

Using only files from /sys/class!

---

## Symlinks

- Symlinks are a way to create a shortcut to a file or directory.
- You can create a symlink using `ln -s <target> <link>`
- This will create what is known as a **soft link**

---

## Soft links vs Hard links

- A symbolic or soft link is an actual link to the original file, whereas a hard link is a mirror copy of the original file.
- If you delete the original file, the soft link has no value, because it points to a non-existent file.
- But in the case of hard link, it is entirely opposite. Even if you delete the original file, the hard link will still has the data of the original file.

---

## Activities
- Symlinks are really useful if you want to create a "duplicate" of a file in a
different location
- This is usefule for something like tracking your config files in a git repo!
- Try creating a symlink to your .bashrc/.zshrc file and see what happens!

---

## Scheduling jobs with `cron`
- Cron is a scheduling daemon that executes tasks at specified intervals.
- These tasks are called cron jobs and are mostly used to automate system maintenance or administration.

---

## Cron jobs
The crontab command allows you to install, view , or open a crontab file for editing:

- `crontab -e` - Edit crontab file, or create one if it doesn’t already exist.
- `crontab -l` - Display crontab file contents.
- `crontab -r` - Remove your current crontab file.
- `crontab -i` - Remove your current crontab file with a prompt before removal.
- `crontab -u` <username> - Edit other user crontab file. This option requires system administrator privileges.

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

## Activities
- Try creating a cron job that runs every minute and prints out the current time.
- Let's extend that further: Can we make it run every day, every hour, on the hour,
from 8 AM through 4 PM?

---

## Activities
- Try creating a cron job that runs every minute and prints out the current time.
- **Solution: `* * * * * date`**
- Let's extend that further: Can we make it run every day, every hour, on the hour,
from 8 AM through 4 PM?
- **Solution: `00 08-16 * * * date`**

---

## Monitoring
- top, htop and how to use them
- searching and killing resources

---

## What is top?
- top command is used to show the Linux processes. It provides a dynamic real-time view of the running system.
- Think of it as a super powerful task manager for Linux.

---

## Basic Usage

- Just type `top` to start the program.
- Pressing q will simply exit the command mode.
- Pressing h will show you the help menu.

---

## What does everything mean?
    PID: Shows task’s unique process id.
    PR: The process’s priority. The lower the number, the higher the priority.
    VIRT: Total virtual memory used by the task.
    USER: User name of owner of task.
    %CPU: Represents the CPU usage.
    TIME+: CPU Time, the same as ‘TIME’, but reflecting more granularity through hundredths of a second.
    SHR: Represents the Shared Memory size (kb) used by a task.
    NI: Represents a Nice Value of task. A Negative nice value implies higher priority, and positive Nice value means lower priority.
    %MEM: Shows the Memory usage of task.
    RES: How much physical RAM the process is using, measured in kilobytes.
    COMMAND: The name of the command that started the process.

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

## Solution

- What are the top 5 processes using the most CPU?
    - `top` -> `Shift + P`
- What would I press if I want to kill the processes using the most memory?
    - `top -> Shift + M` -> `k`
- I want to see what processes start running when I start my computer.
    - `top` -> `f` -> `PID` -> `s` -> `q` -> `Shift + R`

---

## Where to go from here?

-   Good practice to familiarize yourself with commands:
    -   Play around with your shell!
    -   Try installing Arch using the command line only!
    -   Go crazy with shell scripting!
-   Nice place to practice in a unix environment/general sysadmin:
[https://sadservers.com](https://sadservers.com)

---

## Upcoming events

-   Hacker Tools: Self Hosting
-   [Hackerschool: Cosplay for Starters: Design, Model, 3D Print!](https://hckr.cc/hs2023-cosplay)

https://hckr.cc/hs2023-cosplay

-   Friday Hackers #239

https://hckr.cc/links

---

## End



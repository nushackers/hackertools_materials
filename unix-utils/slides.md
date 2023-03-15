% Unix Utilities
% [![](../nushackers_svg.svg){.logo-img style="height: 5ex;"}](https://nushackers.org){target="_blank"}
% 21st March, 2023

---

## Slides

https://hckr.cc/ht-unix-slides

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

Suppose you are part of a *world-class* university and need to connect to a school server. However, you are required to login via a login node or VPN. Let's set this up in our config.

    Host stu
      HostName %h.comp.nus.edu.sg
      User <enter user>

    Host pe11? pe120
      HostName %h.comp.nus.edu.sg
      ProxyJump stu
      User <enter user>

Since %h is the `Host`, we can quickly appead it to our HostName so that we have a shorter alias!

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

- If you have access to a remote server, try configuring your ssh config to that server!
- If you haven't already, set up your ssh keys on your remote
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
(**WARNING:** If you have a slow CPU don't run this)

---

## Extension - Plugins and configs

- You can configure tmux to use your mouse
- You can add plugins to your tmux as well
  - Tmux resurrect is a plugin that allows you to restore your tmux sessions
even *after a reboot*

---

## Files and how they work

- Linux file structure
- Some *special* files
- Symlinks

---

## The Linux filesystem

![](fs-layout.png){style="height: 20ex;"}

---

## Special files to play with in Linux/Unix systems



---

## Activities

If you have a laptop running Unix system locally, you probably have a /sys/class system file!

Play with it, see if you can:

- Get battery information
- Change your screen's backlight

Using only files from /sys/class!

---

## Processes and jobs

- Scheduling jobs with `cron` and `anacron`
- fg, bg, &
- Sending signals to your processes

---

## Activities

---

## Monitoring
- top, htop, bashtop and how to use them
- ps and how to use it
- searching and killing resources

---

## Activities

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
-   Hackerschool:
-   Friday Hacks:

---

## End



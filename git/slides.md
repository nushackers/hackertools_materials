---
marp: true
theme: uncover
class:
  - modern
style: |
  .left-heavy-two-column {
    display: grid;
    grid-template-columns: 1fr 3fr;
    gap: 1rem;
  }

  .even-two-column {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.3rem;
  }
lang: en-US
---

<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
  mermaid.initialize({
    startOnLoad: true,
    theme: 'dark'
  });
</script>

[![](../nushackers_svg.svg)](https://nushackers.org)

PRESENTS

Introduction to Git (and GitHub)
17 May 2025
<!-- Jeya -->

---

## References

These slides are complemented by the wiki so please refer to it for more details/information

[Wiki](https://wiki.nushackers.org/orbital/git)
[Slides](https://hckr.cc/orbital24-git-slides)

---

## Things you need

[![](git-logo.svg)](https://git-scm.com)

[![](github-logo.svg)](https://github.com)

---

## Setup Issues

Quick check: Did anyone face any problems setting up Git on your machine or creating an account on
GitHub?

If you have any issues, refer to the [setup guide provided in the wiki.](https://wiki.nushackers.org/orbital/git/setup)

---

## Config

---

## Accessing GitHub

Using your GitHub password is no longer allowed after **August 13, 2021**. If you use HTTPS, you'll need to create a Personal Access Token (PAT).

In your GitHub account, go to

`Settings > Developer Settings > Personal Access Token`

to generate one.

---

# Fundamental Concepts
<!-- Leslie -->

---

## What is Git?

- Distributed version control system (DVCS)
- Created by Linus Torvalds in 2005 as a replacement for existing VCS for the Linux kernel

<!-- ![](snapshots.svg){.white-bg} -->

---

## What is **version control**?

- A **version control system (VCS)** helps to record changes to a file or a set of files over time
- It allows you to revert a project to a previous state, or to compare changes over time
- Acts as an "undo" button for your code and lets your collaborate with your team

---

## Local vs remote repositories

- **Repository:** parent folder that Git monitors for changes
- **Local:** exists on local machine
- **Remote:** exists on external server such as Github

---

## Thinking in commits

- Snapshot of the instance of the codebase at a given point in time
- Incrementally added over past snapshots as a set of changes
- Visualized as a Directed Acyclic Graph (DAG)

![alt text](dag.png)

---

## Branching away

- Independent line of work that stems/branches off from a point in development
- Useful for isolating bug fixes/features
- Default branch: `main`

---

## Adding files to a snapshot

- Working directory: where you actually work
- Index/\"staging\" area: where you construct a commit
- Repository/commit: the repository itself

<div>
<img src="areas.png" width="600">
</div>

---

# Getting Started
<!-- Jeya -->

---

## Creating a local repository

```sh
mkdir new-folder/
cd new-folder/
git init
```

---

## Adding a file

```sh
echo 'Hello world' >> hello.txt
```

---

## Adding `hello.txt` to your snapshot

```sh
git add hello.txt
```

---

## Check status

```sh
git status
```

---

## Taking the snapshot

```sh
git commit -m "First commit"
```

---

## Check status

```sh
git status
git log
```

---

# Integrating Remote Repositories
<!-- Leslie -->

---

## Creating a new GitHub repository

Go to <https://github.com/new>

<!-- <div>
<img src="github-new.png" width=1200>
<img src="github-new-2.png" width=400>
</div> -->

---

<!-- ## Creating a new GitHub repository -->

<div>
<img src="github-new-3.png" width=750>
</div>

---

<!-- ## Creating a new GitHub repository -->

<div>
<img src="github-new-4.png" width=750>
</div>

---

## Connecting local repository to remote repository

`origin` is used as the name for the remote (it's just convention).

```sh
git remote add origin git@github.com:<github username>/<repository name>.git
git branch -M main
```

---

## Uploading local repository snapshots

```sh
git push -u orign main
```

---

## Receiving remote repository snapshots

```sh
git pull origin main
```

---

## Cloning remote repositories

Downloading a local copy of the repository

```
cd ../
git clone git@github.com:<github username>/<repository name>.git another-folder/
```

---

# Branching
<!-- Jeya -->

---

## What is a branch?

A branch is an independent line of development, often used for features or bug fixes

<div>
<img src="branch.svg" width=650>
</div>

---

## HEAD

`HEAD` is a special name given to the current commit of your current branch for ease of reference

<div>
<img src="head-to-master.png" width=650>
</div>

---

## Creating a branch

```sh
git checkout -b new-feature
```

Alternatively:

```sh
git branch new-feature
git checkout new-feature
```

---

## Changing branches

```sh
git checkout main
```

---

## Viewing all branches

```sh
git branch -v
```

---

## Deleting a branch

```sh
git branch -d <branch name>
```

---

## Renaming a branch

```sh
git branch -m <new branch name>
```

---

## Combining changes of branches

`main` is the target branch, `feature-A` is the source branch

```sh
git checkout main
git merge feature-A
```

---

# Merge Conflicts
<!-- Leslie -->

---

## Merge conflicts

Occur when two (or more) modifications are made to the same line of a file; creating a state of confusion for Git

<div>
<img src="merge-conflict.png" width=700>
</div>

---

## Simulating merge conflicts

In your repository, create branch `conflict-1` from `main` and edit the first line of `hello.txt`

```sh
git checkout -b conflict-1
```

Return to `main` and create another branch `conflict-2` from `main` and edit the first line of `hello.txt` again

```sh
git checkout main
git checkout -b conflict-2
```

---

## Merge conflicts

Now, try to merge `conflict-1` and `conflict-2` into `main`.

```sh
git merge conflict-1
```

```text
Updating b53e9cf..87a92c3
Fast-forward
    hello.txt | 2 +-
    1 file changed, 1 insertion(+), 1 deletion(-)
```

---

## Merge conflicts

```sh
git merge conflict-2
```

```text
Auto-merging hello.txt
CONFLICT (content): Merge conflict in hello.txt
Automatic merge failed; fix conflicts and then commit the result.
```

---

## Handling merge conflicts

```
On branch master
Your branch is ahead of 'origin/master' by 1 commit.
(use "git push" to publish your local commits)

You have unmerged paths.
(fix conflicts and run "git commit")
(use "git merge --abort" to abort the merge)

Unmerged paths:
(use "git add <file>..." to mark resolution)

both modified:   hello.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

---

## Handling merge conflicts

```
$ cat hello.txt
<<<<<<< HEAD
Goodbye!
=======
Farewell!
>>>>>>> conflict-2
```

Top half: current content in branch

Bottom half: content that is about to be merged

---

## Handling merge conflicts

<!-- TODO: MUST DEMO TO EXPLAIN -->
Edit `hello.txt` as such...

---

## Completing the process

Commit the conflicting file

```sh
git commit
```

---

# Intermission

5 minutes...

In the meantime, try out the commands that you have learnt!

Add new files, edit them, commit them, and stage them!

---

# Collaborative Workflows
<!-- Jeya -->

---

## Common Workflows

1. Fork & PR
2. Branch & PR

This workshop focuses on the former - "Fork & PR"

The wiki contains more information about [Branch & PR](https://wiki.nushackers.org/orbital/git/collaborative-workflows/branch-and-pr-workflow)

---

## What is a PR?

Pull requests are like a Request for Comments for a set of changes made on a separate branch

Allows developers and contributors to share their comments on the changes

---

## Creating a PR

Push a local branch to a remote repository

```sh
git checkout -b sample-pr
vim hello.txt
git add hello.txt
git commit -m "new changes"
git push origin sample-pr
```

Visit GitHub to create the PR ([screenshots on the wiki](https://wiki.nushackers.org/orbital/git/collaborative-workflows))

---

## Fork & PR workflow

**Forking:** creating an at-the-time copy of a remote repository (only needs to be done once per remote repository)

**Upstream:** common name for the original repository

---

## Branch & PR Workflow

Each member owns their copy of the repository locally (through cloning)

When working on a new feature or bug fix, each member will

---

## Branch & PR Workflow

1. Pull the latest changes from the remote repository
2. Create a branch per feature/bug fix on their local copy
3. Edit the files in their respective branch
4. Push their local branch to the repository
5. Make a pull request of their feature/bug fix branch to the `main` branch (remote copy)

---

## Hands-on time!

1. Create a fork of the demo repository
2. Clone the fork to local machine
3. Make changes to the repository
4. Commit changes
5. Push changes to forked repository
6. Create PR through Github

---

# Intermission!

5 minute break and Q&A!

---

## Additional concepts
<!-- Leslie -->

---

## Commit manipulation

---

## Revert

Undo accidental changes made

```sh
$ git log --graph --oneline
* d1f4fcc (HEAD -> master, origin/master, origin/HEAD) Add file3
* 643aec6 Update file to c
* 4ec21c7 Update file to b
* 055cab4 Initial commit
```

Suppose we want to revert to commit `643aec6`.

---

## Revert

```sh
$ git revert 643aec6
[master 7b73baf] Revert "Update file to c"
    1 file changed, 1 insertion(+), 1 deletion(-)
```

---

## Revert

```sh
$ git show
commit 7b73baf229e2b8db19bc594c450743b50adf649d (HEAD -> master)
Author: Your Name <your@email.com>
Date:   Tue May 11 01:21:31 2021 +0800

    Revert "Update file to c"

    This reverts commit 643aec6d2a1b4cd485d678886fc1cef25b15bee0.

diff --git a/file b/file
index f2ad6c7..6178079 100644
--- a/file
+++ b/file
@@ -1 +1 @@
-c
+b
```

---

## Diff

View difference betwen commits/branches

```sh
$ git diff
diff --git a/file b/file
index 7898192..6178079 100644
--- a/file
+++ b/file
@@ -1 +1 @@
-a
+b
```

---

## Reset

Undo `git add`

```
$ git status
On branch master
Changes to be committed:
    (use "git restore --staged <file>..." to unstage)
    modified:   file
$ git reset file
Unstaged changes after reset:
M   file
$ git status
On branch master
Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git restore <file>..." to discard changes in working directory)
    modified:   file
no changes added to commit (use "git add" and/or "git commit -a")
```

---

## Restore

Undo changes to a file in the working tree

```
$ echo e > file
$ git status
On branch master
Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git restore <file>..." to discard changes in working directory)
    modified:   file

no changes added to commit (use "git add" and/or "git commit -a")
$ git restore file
$ git status
On branch master
nothing to commit, working tree clean
```

---

## Ignoring files

Sometimes we don\'t want Git to track a certain file

~~~ {.bash-strong}
$ touch ignore-me
$ git status
~~~
    On branch master
    Untracked files:
      (use "git add <file>..." to include in what will be committed)

        ignore-me

    nothing added to commit but untracked files present (use "git add" to track)
---

## Ignoring files

We can add it to `.gitignore`

~~~ {.bash-strong}
$ echo "/ignore-me" >> .gitignore
$ git status
~~~
    On branch master
    Untracked files:
      (use "git add <file>..." to include in what will be committed)

        .gitignore

    nothing added to commit but untracked files present (use "git add" to track)

`.gitignore` should be committed.

---

## Viewing ignored files

~~~ {.bash-strong}
$ git status --ignored
~~~
    On branch master
    Ignored files:
      (use "git add -f <file>..." to include in what will be committed)

        ignore-me

    nothing to commit, working tree clean

---

## What to ignore?

Typically, we ignore files like build artifacts and generated files that
are usually derived from the human-authored code in the repository. E.g.

-   dependency caches like `/node_modules`
-   compiled code like `.o`, `.pyc` files
-   build output directories like `/bin`, `/out`
-   runtime-generated files like log files
-   personal configuration files e.g. of your IDE

---

## `.gitignore` format

    /logs/*/*.log
    /logs/**/*.log
    **/logs
    **/logs/debug.log
    *.log
    /debug.log
    debug.log

[See the full pattern format.](https://git-scm.com/docs/gitignore#_pattern_format)

---

## Commit message discipline

First line: 80-character title, phrased imperatively

Then if your change is complex, elaborate on the change in prose.

``` font45
Change greeting from "Hi" to "Hello"

"Hi" is a bit too informal for a greeting. We should change it to "Hello" instead,
so that our users don't feel like we are being too informal. Blah blah blah blah.
Blah blah.
```

---

## Where to go from here?

Additional readings:
- [Git manual](https://git-scm.com/docs)
- [Pro Git](https://git-scm.com/book/en/v2)
- [NUS Hackers Git Cheatsheet](https://hckr.cc/ht-git-cs)
- [NUS Hackers Git Wiki](https://wiki.nushackers.org/orbital/git)
- Look into [Gitworkflows](https://git-scm.com/book/en/v2/Distributed-Git-Distributed-Workflows#ch05-distributed-git)
- [Atlassian\'s collaboration guide](https://www.atlassian.com/git/tutorials/syncing)


---

## Where to go from here?

- If you're interested in how version control works with lots of technical details, look into [Customizing Git](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration) and [Git Internals](https://git-scm.com/book/en/v2/Git-Internals-Plumbing-and-Porcelain)
- GitHub isn't the only way you can share you repositories online! You could even self host your own Git servers.
- Why stop at learning? [Build your own Git!](https://github.com/codecrafters-io/build-your-own-x#build-your-own-git)

---

## Where to go from here?

Check out Hackerschool: Advanced Git\
(last run on 7 Nov 2020)

Recording: <https://www.youtube.com/watch?v=pGAorBdZ6Y8>

Slides: <https://hs2010-git.github.io/adv>

---

## Where to go from here?

Check out Hackerschool: CI/CD with Github Actions\
(last run on 1 Apr 2025)

Recording: Coming Soon!

Wiki: <https://wiki.nushackers.org/hackerschool/ci-cd-with-github-actions>

---

<!-- ## Feedback

Remember to give us feedback here: [https://bit.ly/orbital24-mc1-feedback](https://bit.ly/orbital24-mc1-feedback)

![feedbackQr](feedbackQr.png)

--- -->

## End

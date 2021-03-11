---
date: 2021-02-07
title: "GitHub Command Line Interface"
linkTitle: "gh CLI"
description: "A brief turorial on the installation and usage of the GitHub CLI"
author: Richard Otten, Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
  params:
    byline: "Photo: Gregor von Laszewski / CC-BY-CA"
---

# Introduction

The new GitHub CLI allows GitHub users to purely work from the terminal of their machine without having to visit the web browser GUI to manage things like issues, PRs, and forking.

# Installing GitHub CLI

Visit the GitHub CLI homepage at https://cli.github.com/ for installation instructions. On mac, you can use the following command with [Brew](https://brew.sh/):

```bash
brew install gh
```

# Logging in with GitHub CLI

It is good practice to be using SSH-keys with GitHub. Create one if you have not already with the following:

```bash
ssh-keygen
```

The default parameters and location are ok.

To authenticate with GitHub CLI, run the following command. We have included the answers to the interactive prompts used for this guide.

```bash
gh auth login

What account do you want to log into? GitHub.com
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations? SSH
? Upload your SSH public key to your GitHub account? ~/.ssh/id_rsa.pub
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: 1234-1A11
- Press Enter to open github.com in your browser...
```

# Forking

We can easily create a fork of a repo with the following:

```bash
gh repo fork
```

This is useful for when you do not have write access to the original repository.

# Pull Requests

We can create a pull request easily as follows from a git repo:

```bash
gh pr create
```

The command above will ask the user where to push the branch (if it does not already exist on the remote). It will also offer the option to fork the initial repository. You will want to do this if you do not have write access to the original repo.

Once created, you may view the status of the PR with the following:

```bash
gh pr status
```

Reviewers can checkout your pull request to verify changes as follows:

```bash
gh pr checkout {PR NUMBER}
```

The reviewer can then approve the PR as follows:

```bash
gh pr review --approve
```

Subsequently, the PR can be merged as follows:

```bash
gh pr merge {PR NUMBER}
```

You may also list all pull requests with the following:

```bash
gh pr list
```

Finally, PRs can be closed with 

```bash
gh pr close {PR NUMBER}
```

# Managing Issues with GitHub CLI

To create an issue, call the following:

```bash
gh issue create --title="Bug 1" --body="description"
```

We can also check the status of issues relevant to use with:

```bash
gh issue status
```

Alternatively, we may list all open issues.

```bash
gh issue list
```

Finally, we may close issues with:

```bash
gh issue close {ISSUE NUMBER}
```

# Conclusion

There are many other commands for the GitHub CLI that can be found in the [gh manual](https://cli.github.com/manual/), however we only include a select number of relevant commands for this guide. The commands mentioned above serve to familiarize the user with the GitHub CLI while also providing practical usage.

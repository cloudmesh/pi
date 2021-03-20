---
date: 2021-03-15
title: "GitHub gh Command Line Interface"
linkTitle: "Command gh"
description: "A brief tutorial on the installation and usage of the GitHub gh CLI"
author: Richard Otten, Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---


{{< imgproc image Fill "600x300" >}}
{{< /imgproc >}}

Figure 1: GitHub Command gh.


{{% pageinfo %}}

GitHub provides an extended gh commandline tool that allow easy interaction of 
forking repositories directly from github. IT also provides additional fimctionality 
to interact with other advanced features that are typically not provided in the git command tool.

**Learning Objectives**

* Learn how to install the gh command
* Learn how to use the gh command
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

## 1. Introduction

The new GitHub `gh` command allows GitHub users to work from the terminal of
their machine without having to visit the web browser GUI to manage things like
issues, PRs, and forking. We will show you what features it provides and how to 
use it. The `gh` command provides useful features that is not provided by the `git
commandline tool.

## 2. Installing GitHub gh command

Visit the GitHub CLI homepage at <https://cli.github.com/> for installation
instructions.  We recommend that you check out the source distribution because
We found that whne we did this tutorial not all features were included in the 
brew instalation. We assume ths will cahnge over time and you may soon be able 
to just use the bre install on LInux and MacOs.

On mac, you can use the following command with
[Brew](https://brew.sh/):

```bash
brew install gh
```
For Windows useser, please follow the install instructions fro Winodws. 

## 3. Logging in with GitHub gh Command

It is best practice to be using SSH-keys with GitHub. Create one if you have
not already with the following command:

```bash
ssh-keygen
```

We recommend t use the the default location.

To authenticate with the GitHub `gh` comamand, run the following command. We have included
the answers to the interactive prompts used for this guide.

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

### 3.1 Adding Additional Keys

IN acse you work with multiple computers it is advisable to add your keys from these 
machines also. We demonstarte the interaction to upload the key from a new machine.

```
newmachine$ gh ssh-key add ~/.ssh/id_rsa.pub 
Error: insufficient OAuth scopes to list SSH keys
Run the following to grant scopes: gh auth refresh -s write:public_key
newmachine$ gh auth refresh -s write:public_key

! First copy your one-time code: 4C2D-E896
- Press Enter to open github.com in your browser... 
✓ Authentication complete. Press Enter to continue...

newmachine$ gh ssh-key add ~/.ssh/id_rsa.pub   
✓ Public key added to your account
```

## 4. Forking

We can easily create a fork of a repo with the following:

```bash
gh repo fork
```

This is useful for when you do not have write access to the original repository.

## 5. Pull Requests

We can create a pull request easily as follows from a git repo:

```bash
gh pr create
```

The command above will ask the user where to push the branch (if it does not
already exist on the remote). It will also offer the option to fork the initial
repository. You will want to do this if you do not have write access to the
original repo.

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

## 6. Managing Issues with GitHub gh Command

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

## 7. Manual Pages

### 7.1 gh

```
gh(1)                                                                    gh(1)

NAME
       gh - GitHub CLI

SYNOPSIS
       gh   [flags]

DESCRIPTION
       Work seamlessly with GitHub from the command line.

OPTIONS
       --help[=false]      Show help for command

       --version[=false]      Show gh version

EXAMPLE
              $ gh issue create
              $ gh repo clone cli/cli
              $ gh pr checkout 321

SEE ALSO
       gh-alias(1),  gh-api(1),  gh-auth(1),  gh-completion(1),  gh-config(1),
       gh-gist(1),   gh-issue(1),   gh-pr(1),    gh-release(1),    gh-repo(1),
       gh-secret(1), gh-ssh-key(1)
```

### 7.2 List of Man Pages

Tha manual pages are published at the [gh manual](https://cli.github.com/manual/).
For mor information you can also use the man command. A full list of manual pages includes:

* gh
* gh-alias-delete
* gh-alias-list
* gh-alias-set
* gh-alias
* gh-api
* gh-auth-login
* gh-auth-logout
* gh-auth-refresh
* gh-auth-status
* gh-auth
* gh-completion
* gh-config-get
* gh-config-set
* gh-config
* gh-gist-clone
* gh-gist-create
* gh-gist-delete
* gh-gist-edit
* gh-gist-list
* gh-gist-view
* gh-gist
* gh-issue-close
* gh-issue-comment
* gh-issue-create
* gh-issue-delete
* gh-issue-edit
* gh-issue-list
* gh-issue-reopen
* gh-issue-status
* gh-issue-view
* gh-issue
* gh-pr-checkout
* gh-pr-checks
* gh-pr-close
* gh-pr-comment
* gh-pr-create
* gh-pr-diff
* gh-pr-edit
* gh-pr-list
* gh-pr-merge
* gh-pr-ready
* gh-pr-reopen
* gh-pr-review
* gh-pr-status
* gh-pr-view
* gh-pr
* gh-release-create
* gh-release-delete
* gh-release-download
* gh-release-list
* gh-release-upload
* gh-release-view
* gh-release
* gh-repo-clone
* gh-repo-create
* gh-repo-fork
* gh-repo-view
* gh-repo
* gh-secret-list
* gh-secret-remove
* gh-secret-set
* gh-secret
* gh-ssh-key-add
* gh-ssh-key-list
* gh-ssh-key

## 7. Conclusion

There are many other commands for the GitHub CLI that can be found in the 
[gh manual](https://cli.github.com/manual/), however we only include a select
number of relevant commands for this guide. The commands mentioned above serve
to familiarize the user with the GitHub CLI while also providing practical
usage.


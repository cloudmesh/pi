---
date: 2021-02-07
title: "Github Fork"
linkTitle: "Github Fork"
description: "This post is an example so you can easily add new content."
author: Richard Otten, Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: True
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
  params:
    byline: "Photo: Gregor von Laszewski / CC-BY-CA"
---

{{< imgproc webpage Fill "600x300" >}}
The Web Page.
{{< /imgproc >}}


{{% pageinfo %}}

Abstract

**Learning Objectives**

* Learn how to ...
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## Introduction

When contributing to open source code, it is often wise to create your own
fork. Since you may not have write-access to the repository in question, you
would want to create a fork to perform your own changes in. Then once you are
satisfied with such changes, you may commit and submit a pull request to merge
the changes from your fork into the original repository.

In this guide, we will describe how to manage branches and make code
contributions to the cloudmesh project.

We will first clone a repository using HTTPS, then we will add our SSH remote.
Finally, we will fork the repository and add the corresponding SSH remote.
Additionally, we will walk through committing and creating a pull request.

Here is a nice git alias you may find useful when tracking your branches via commandline:

```bash
$ git config --global alias.graph "log --graph --decorate --color --oneline --all --cherry-mark"
$ git graph
```

## Adding an SSH key to your GitHub

Ensure you have an ssh-key on your machine. If you do not, you may do the
following in linux-like consoles:

```bash
$ ssh-keygen
```

This will generate a key-pair (public and private).

```bash
$ cat ~/.ssh/id_rsa.pub
```

Record the output of the above. That is your public key. Then navigate to your
Github settings page, go to **SSH and GPG keys**, and add the output of the
above command as a new SSH key entry.

## Configureing GitHub


First we must configure git with our email and  ame. Note these values are very
significant as otherwise your pull requests may be declined by the repository
maintainer as you have not completed your GitHub setup.

```bash
$ git config --global user.email "you@example.com"
$ git config --global user.name "Your Name"
```

## Cloning a Repository

TODO: setup seperate toy education repo to avoit pull requests into our real stuff.

For the purposes of this tutorial, we will clone the repository
[cloudmesh-pi-cluster](https://github.com/cloudmesh/cloudmesh-pi-cluster).

We can do this as follows in a directory of our choosing.

```bash
$ git clone https://github.com/cloudmesh/cloudmesh-pi-burn.git
$ cd cloudmesh-pi-burn/
```

We can list the remotes we are tracking as well as the urls as follows

```bash
/cloudmesh-pi-burn $ git remote -v
$ git remote -v
origin	https://github.com/cloudmesh/cloudmesh-pi-burn.git (fetch)
origin	https://github.com/cloudmesh/cloudmesh-pi-burn.git (push)
```

We can see the remote urls that remote `origin` uses for fetching and pushing.

## Adding an SSH Remote

We can also add our SSH link of the repository. This is useful if our account is
listed as an authorized contributor. In this manner, we do not need to type our
password whenever we push, as we do with the HTTPS remote. Note this is required
if you have 2FA enabled on your GitHub account.

We can add our SSH remote for cloudmesh-pi-burn as follows:

```bash
$ git remote add ssh-origin git@github.com:cloudmesh/cloudmesh-pi-burn.git
```

> Note that the name of the remote `ssh-origin` is of no importance when adding a new remote.

We can again run `git remote -v`

```bash
$ git remote -v
origin	https://github.com/cloudmesh/cloudmesh-pi-burn.git (fetch)
origin	https://github.com/cloudmesh/cloudmesh-pi-burn.git (push)
ssh-origin	git@github.com:cloudmesh/cloudmesh-pi-burn.git (fetch)
ssh-origin	git@github.com:cloudmesh/cloudmesh-pi-burn.git (push)
```

We should now fetch our `ssh-origin` remote.

```bash
$ git fetch ssh-origin
```

Since we are using an SSH remote, then it is of no use to keep our HTTPS
remote. Let us remove it, and rename our SSH remote to `origin`. We will also
configure our local `main` branch to track the SSH remote branch `origin/main`.

```bash
$ git remote remove origin
$ git remote rename ssh-origin origin
$ git branch --set-upstream-to=origin/main
```

## Forking

Often, we want to work on changes to a code base, but without access to the
original repo, we have nowhere to store our work. This is where forking comes
into play.

To create a fork of a repository, navigate to the repository of interest on the
GitHub website. In this case, we will navigate to the repository of
[cloudmesh-pi-burn](https://github.com/cloudmesh/cloudmesh-pi-burn).

At the top right of the screen, you will notice a **Fork** button. Click this
button to fork the `cloudmesh-pi-burn`. This will take you to a new repository.
Notice how the name of the repisitory is now
`{your_username}/cloudmesh-pi-burn`. This is your fork.

We can add the remote of our fork to our existing local clone of
`cloudmesh-pi-burn` in the same way we did above. We will again use the SSH
remote link that can be found under the green **Code** button used for cloning.

```bash
$ git remote add origin-fork git@github.com:{your_username}/cloudmesh-pi-burn.git
```

> Again, `origin-fork` is purely a choice of name.

## Feature Branches and Committing to Your Fork

From here, we can start working on different bugs/features. In general, it is
good practice to keep your `main` branch clean from features in development.
That is, it is always good to keep a working version to revert to. This
motivates the use of branches. You can have local branches and remote branches,
but we will start with local branches.

We can create a new branch as follows. We will call our branch `feature`:

```bash
$ git checkout -b feature
```

From here, we can start making code changes. Once we are satisfied, we may
commit. 

Now we may commit.

```bash
$ git commit -am 'commit message'
```

Finally, we may push our changes up to our remote. From here, we have a few
options for pushing to our remote.

1. **Option 1** Creating a new remote branch.

We can push `feature` as a new remote 
branch `origin-fork/feature` in our fork as follows:

```bash
$ git push origin-fork feature:feature
```

2. **Option 2** Merging into `main` and pushing to `origin-fork/main`.

We can merge our changes into main and push them to our fork's main as follows.

```bash
$ git checkout main
$ git merge feature
$ git push origin-fork main:main
```

3. **Option 3** Pushing `feature` directly to `origin-fork/main`.

If we want to avoid a merge commit, we can push our `feature` branch directly
to `origin-fork/main` as follows.

```bash
$ git push origin-fork feature:main
```

There are several other ways of committing/pushing, but we keep the listed options
simple.

## Creating a Pull Request

If you would like to see your changes and commits reflected in the original
repository, you may submit a Pull Request (PR) for authorized contributors to
review and merge into the original repository (if approved).

To create a PR, first ensure your changes are pushed to your remote and all
changes are in order in a single branch (the default for PR's is `main`, so we
recommend you keep your verified changes in that branch of your fork).

Navigate to your fork's repository on the GitHub website. You will notice near
the top that there is a message comparing your fork's commits with the original
repository. Additionally, there is a **Pull Request** button. Click this, and
create the PR for the owners to review.

## Conclusion and Review

Forking and branching is a very powerful tool in the Open Source world. In this
guide, we demonstrated how to add remotes to your local clone, create a fork,
commit changes locally on different branches, and push them to different remote
branches. We also reviewed how to submit Pull Requests for open source
contribution.

Please leave a comment or reach out to us if you have any questions.






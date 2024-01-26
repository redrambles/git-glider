# git-glider 🪂

A collection of shell commands to streamline your Git workflow and maintain a clean, understandable Git history.

## Getting started

Install with curl

```sh
sh -c "$(curl -fsSL "https://raw.githubusercontent.com/krystalcampioni/git-glider/main/install.sh?$(date +%s)")"`
```

or

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/krystalcampioni/git-glider/main/install.sh)
```

run `gitGlider --help` for a full list of commands and aliases

## Functions and Aliases

### Functions

#### gcmsgn

`git commit -m --no-verify`

runs git commit skipping pre-commit checks

  ```bash
  gcmsgn "Your commit message"
  ```
  

#### pushs

Pushes the current branch to the origin with `--force-with-lease`

  ```bash
  pushs
  ```

#### rebaseLast

Starts an interactive rebase of the last `num_commits` commits.

  ```bash
  rebaseLast 4
  ```

#### undoLast

Undoes the last `num_commits` commits and leaves the changes in the staging area.

  ```bash
  undoLast 3
  ```


#### openpr

 Opens the browser to compare the current branch to the main branch on Github

  ```bash
  openpr
  ```

#### squashRange

Squashes a range of commits between `hashA` and `hashB` into a single commit with a new commit message.

  > ⚠️ hashA has to be older than hashB

  ```bash
  squashRange <hashA> <hashB> "optional new commit message"
  ```

#### squashLast

Squashes the last `num_commits` into a single commit with a new commit message.

  ```bash
  squashLast 2 "optional new commit message"
  ```


### Aliases

#### gup

`git pull --rebase`

fetches the updates from the remote repository and applies your local changes on top of those updates.

#### gcmsg

`git commit -m`

allows you to commit changes with a message.

#### ga

`git add`

stages changes for the next commit.

#### gst


`git status`

shows the status of changes as untracked, modified, or staged.

#### gups

`git pull origin main --rebase`

fetches updates from the main branch of the origin remote and applies your local changes on top.

#### logp

`git log -p`

which shows commit logs and diff about what was modified.

#### glog

`git log --oneline --decorate --graph`

shows a decorated, one-line commit history with a graph illustrating branch merges.

#### gclean

`git clean -f -d`

removes untracked files and directories.

#### rewordLast "new message"

`git commit --amend --message`

allows you to change the message of the most recent commit.

##### undo

`git reset HEAD~`

Undoes the last commit and leaves the changes in the working area.

##### addToLast n

Performs a `git add . && git commit --amend --no-edit`

Stages all changes and ads them to the most recent commit without changing the commit message.

##### backUpBranch

Performs the equivalent of `git checkout -b <current-branch-name>_backup && git checkout -`

Creates a backup of your current branch without leaving your current branch


## Contributing

Contributions are welcome!
💪 If you have a command or alias that has improved your Git workflow, please consider sharing it with the community.

## Perfect pairing 🍷

This project loves Oh My Zsh, a delightful community-driven framework for managing your Zsh configuration. Some of the aliases used in this project are defined in Oh My Zsh. If you haven't installed it yet, we highly recommend checking it out to enhance your terminal experience. Visit https://ohmyz.sh to learn more. ❤️

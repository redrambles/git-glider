# git-glider

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

## Commands and Aliases

### Aliases

- `gup`: `git pull --rebase`.
- `gcmsg`: `git commit -m`.
- `ga`: `git add`.
- `gst`: `git status`.
- `gups`: `git pull origin main --rebase`.
- `logp`: `git log -p`
- `glog`: `git log --oneline --decorate --graph`
- `gst`: `git status`
- `gclean`: `git clean -f -d`
- `rewordLast`: `git commit --amend --message`
- `gups`: `git pull origin main --rebase`
- `undo`: Undoes the last commit and leaves the changes in the working area.
- `addToLast n`: `git add . && git commit --amend --no-edit`  Undoes the last N commit and leaves the changes in the working area.

### Functions

- `gcmsgn`: Performs a `git commit -m` with `--no-verify` option.

  ```bash
  gcmsgn "Your commit message"
  ```
  
- pushs: Pushes the current branch to the origin with `--force-with-lease`

  ```bash
  pushs
  ```

- rebaseLast: Starts an interactive rebase of the last `num_commits` commits.

  ```bash
  rebaseLast <num_commits>
  ```

- undoLast: Undoes the last `num_commits`` commits and leaves the changes in the staging area.

  ```bash
  undoLast <num_commits>
  ```

- openpr: Opens the browser to compare the current branch to the main branch

  ```bash
  openpr
  ```

- squashRange: Squashes a range of commits between `hashA` and `hashB` into a single commit with a new commit message. 

  ⚠️ hashA has to be older than hashB

  ```bash
  squashRange <hashA> <hashB> "optional new commit message"
  ```

- squashLast: Squashes the last `num_commits` into a single commit with a new commit message.

  ```bash
  squashLast <num_commits> "optional new commit message"
  ```

## Contributing

Contributions are welcome!
💪 If you have a command or alias that has improved your Git workflow, please consider sharing it with the community.

## Perfect pairing 🍷

This project loves Oh My Zsh, a delightful community-driven framework for managing your Zsh configuration. Some of the aliases used in this project are defined in Oh My Zsh. If you haven't installed it yet, we highly recommend checking it out to enhance your terminal experience. Visit https://ohmyz.sh to learn more. ❤️
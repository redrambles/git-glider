# git-glider

A collection of bash commands to streamline your Git workflow and maintain a clean, understandable Git history.

## Getting started

Install with curl
`bash <(curl -fsSL https://raw.githubusercontent.com/krystalcampioni/git-glider/main/install.sh)`

Or with wget
`bash <(wget -qO - https://raw.githubusercontent.com/krystalcampioni/git-glider/main/install.sh)`

or with fetch
`bash <(fetch -qo - https://raw.githubusercontent.com/krystalcampioni/git-glider/main/install.sh)`

## Commands and Aliases

### Aliases

- `gup`: Performs a `git pull --rebase`.
- `gcmsg`: Performs a `git commit -m`.
- `ga`: Performs a `git add`.
- `gst`: Performs a `git status`.
- `gups`: Performs a `git pull origin main --rebase`.
- `undo`: Undoes the last commit and leaves the changes in the working area.

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

- resetLast: Undoes the last `num_commits`` commits and leaves the changes in the staging area.

  ```bash
  resetLast <num_commits>
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
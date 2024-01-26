#!/bin/sh


# TODO document aliases
alias gup="git pull --rebase"
alias gcmsg="git commit -m"
alias ga="git add"
alias logp="git log -p"
alias logp="git log -p"
alias glog="git log --oneline"
alias lograph="git log --all --decorate --oneline --graph"
alias gst="git status"
alias gups="git pull origin main --rebase"
alias bkup="backupBranch"

alias undo="git reset HEAD~" # leaves changes of last commit in working area
alias addToLast="git add . && git commit --amend --no-edit"
alias gclean="git clean -f -d"
alias rewordLast="git commit --amend --message"

gcmsgn() {
  if [ "$1" = "--help" ]; then
    echo
    colorPrint brightCyan "Usage: " -n
    colorPrint brightWhite "gcmsgn <optional-message>"
    colorPrint cyan "Performs a git commit with the provided message and --no-verify option."
    echo
    return
  fi
  gcmsg "$1" --no-verify
}

pushs() {
  if [ "$1" = "--help" ]; then
    echo
    colorPrint brightCyan "Usage: " -n
    colorPrint brightWhite "pushs"
    colorPrint cyan "Pushes the current branch to the origin with --force-with-lease option."
    echo
    return
  fi
  branch=$(git branch --show-current)
  git push origin $branch --force-with-lease
}

rebaseLast() {
  if [ "$1" = "--help" ]; then
    echo
    colorPrint brightCyan "Usage: " -n
    colorPrint brightWhite "rebaseLast <num_commits>"
    colorPrint cyan "Starts an interactive rebase of the last <num_commits> commits."
    echo
    return
  fi
  git rebase -i HEAD~$1
}

undoLast() {
  if [ "$1" = "--help" ]; then
    echo
    colorPrint brightCyan "Usage: " -n
    colorPrint brightWhite "undoLast <num_commits>"
    colorPrint cyan "Undoes the last <num_commits> commits and leaves the changes in the staging area."
    echo
    return
  fi
  git reset HEAD~$1
}

openpr() {
  # TODO push upstream before opening pr
  if [ "$1" = "--help" ]; then
    colorPrint brightCyan "Usage: openpr"
    colorPrint brightCyan "Opens the browser to compare the current branch to the main branch."
    return
  fi
  repo=$(git config --get remote.origin.url | sed -e 's/^git@.*:\(.*\)\.git$/\1/' -e 's/^https:\/\/github.com\/\(.*\)\.git$/\1/')
  echo $repo
  branch=$(git branch --show-current)
  url="http://github.com/$repo/compare/$branch?expand=1"
  
  # Check the operating system
  if [ "$OSTYPE" = "darwin"* ]; then
    # MacOS
    open "$url"
  elif [ "$OSTYPE" = "linux-gnu"* ]; then
    # Linux
    xdg-open "$url"
  elif [ "$OSTYPE" = "cygwin" ] || [ "$OSTYPE" = "msys" ] || [ "$OSTYPE" = "win32" ]; then
    # Windows
    start "$url"
  else
    colorPrint brightRed "Unsupported operating system. Please open the following URL in your browser:"
    colorPrint brightYellow "$url"
  fi
}

squashRange() {
    if [ "$1" = "--help" ]; then
      echo
      colorPrint brightCyan "Usage: " -n
      colorPrint brightWhite "squashRange <hashA> <hashB> <optional-message>"
      colorPrint yellow "<hashA> has to be older than <hashB>"
      colorPrint cyan "Squashes a range of commits between <hashA> and <hashB> into a single commit with a new commit message."
      echo
      return
    fi
    hashA="$1"
    hashB="$2"
    message="$3"

    # Save the current branch name
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Checkout the commit to squash into
    git checkout "$hashB"

    # Create a new branch at this commit
    git checkout -b mod_history

    # Reset the branch pointer to the commit before the first commit to squash,
    # but leave the index and working tree intact.
    git reset --soft "$(git rev-parse "$hashA~1")"

    # If a message was provided, use it for the new commit.
    # Otherwise, use a combination of all squashed commit messages.
    if [ -n "$message" ]; then
        git commit -am "$message"
    else
        combined_message=$(git log --format=%B "$hashA~1..$hashB")
        git commit -am "$combined_message"
    fi

    # Remember the new commit hash
    new_commit=$(git rev-parse HEAD)

    # Checkout the original branch and replay all commits after hashB onto the new commit
    git checkout "$current_branch"
    git rebase --onto "$new_commit" "$hashB"

    # Remove the temporary branch
    git branch -D mod_history
}

squashLast() {
    if [ "$1" = "--help" ]; then
      colorPrint brightCyan "Usage: " -n
      colorPrint brightWhite "squashLast <num_commits> <optional-message>"
      colorPrint cyan "Squashes the last <num_commits> into a single commit with a new commit message."
      return
    fi
    num_commits="$1"
    message="$2"

    # Get the hash of the commit before the commits to squash
    hash1=$(git rev-parse HEAD~"$((num_commits))")

    # Create a temporary script to use as the sequence editor
    echo '#!/bin/bash' > /tmp/editor.sh
    echo "awk 'NR>1 && /^pick/ {\$1=\"squash\"} {print}' \"\$1\" > tmp && mv tmp \"\$1\"" >> /tmp/editor.sh
    chmod +x /tmp/editor.sh

    # Start an interactive rebase with the commit before the commits to squash
    GIT_SEQUENCE_EDITOR="/tmp/editor.sh" GIT_EDITOR=":" git rebase -i "$hash1"

    # Amend the commit message if one was provided
    if [ -n "$message" ]; then
        git commit --amend -m "$message"
    fi

    # Remove the temporary script
    rm /tmp/editor.sh
}

backupBranch() {
    # Get the current branch name
    local currentBranch=$(git rev-parse --abbrev-ref HEAD)

    # Create a new branch with '_backup' appended to the current branch name
    git checkout -b "${currentBranch}_backup"

    # Switch back to the original branch
    git checkout "$currentBranch"

    colorPrint green  "Created a backup branch: ${currentBranch}_backup ✅"
}


gitGlider() {
  if [ -z "$1" ]; then
    echo
    colorPrint brightCyan "Git-Glider " -n
    colorPrint cyan "is a collection of bash commands to streamline your Git workflow and maintain a clean, understandable Git history"
    colorPrint brightGreen "gitGlider --help " -n
    colorPrint green "for more information"
    echo
  elif [ "$1" = "--help" ]; then
    echo
    colorPrint brightWhite "Aliases:"
    colorPrint brightCyan "gup:"
    colorPrint cyan "Performs a git pull --rebase."
    colorPrint brightCyan "gcmsg:"
    colorPrint cyan "Performs a git commit -m."
    colorPrint brightCyan "ga:"
    colorPrint cyan "Performs a git add."
    colorPrint brightCyan "gst:"
    colorPrint cyan "Performs a git status."
    colorPrint brightCyan "gups:"
    colorPrint cyan "Performs a git pull origin main --rebase."
    colorPrint brightCyan "undo:"
    colorPrint cyan "Undoes the last commit and leaves the changes in the working area."
    colorPrint brightCyan "glog:"
    colorPrint cyan "Shows the commit history is a compact layout, one commit per line"
    colorPrint brightCyan "lograph:"
    colorPrint cyan "shows the commit history with a graph illustrating branch merges across all branches."
    echo
    colorPrint brightWhite "Functions:"
    colorPrint brightCyan "gcmsgn:"
    colorPrint cyan "Performs a git commit -m with --no-verify option."
    colorPrint cyan "Usage: gcmsgn \"Your commit message\""
    echo
    colorPrint brightCyan "pushs:"
    colorPrint cyan "Pushes the current branch to the origin with --force-with-lease."
    colorPrint cyan "Usage: pushs"
    echo
    colorPrint brightCyan "rebaseLast:"
    colorPrint cyan "Starts an interactive rebase of the last num_commits commits."
    colorPrint cyan "Usage: rebaseLast <num_commits>"
    echo
    colorPrint brightCyan "undoLast:"
    colorPrint cyan "Undoes the last num_commits commits and leaves the changes in the staging area."
    colorPrint cyan "Usage: undoLast <num_commits>"
    echo
    colorPrint brightCyan "openpr:"
    colorPrint cyan "Opens the browser to compare the current branch to the main branch."
    colorPrint cyan "Usage: openpr"
    echo
    colorPrint brightCyan "squashRange:"
    colorPrint cyan "Squashes a range of commits between hashA and hashB into a single commit with a new commit message."
    colorPrint cyan  "⚠️   <hashA> has to be older than <hashB>"
    colorPrint cyan "Usage: squashRange <hashA> <hashB> \"optional new commit message\""
    echo
    colorPrint brightCyan "squashLast:"
    colorPrint cyan "Squashes the last num_commits into a single commit with a new commit message."
    colorPrint cyan "Usage: squashLast <num_commits> \"optional new commit message\""
    echo
    colorPrint brightCyan "backupBranch:"
    colorPrint cyan "Duplicates your current branch appenging _backup to its name."
    colorPrint cyan "Usage: backupBranch"
    echo
  else
    echo
    colorPrint brightRed "Invalid argument. Use git-glider or git-glider --help."
    echo
  fi
}
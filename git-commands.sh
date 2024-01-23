#!/bin/bash

alias gup="git pull --rebase"
alias gcmsg="git commit -m"
alias ga="git add"
alias gst="git status"
alias gups="git pull origin main --rebase"

# Tested and works ✅
# undoes last commit
# leaves changes of last commit in working area
alias undo="git reset HEAD~"


gcmsgn() {
  if [ "$1" == "--help" ]; then
    colorPrint brightCyan "Usage: gcmsgn <message>"
    colorPrint brightCyan "Performs a git commit with the provided message and --no-verify option."
    return
  fi
  gcmsg "$1" --no-verify
}

pushs() {
  if [ "$1" == "--help" ]; then
    colorPrint brightCyan "Usage: pushs"
    colorPrint brightCyan "Pushes the current branch to the origin with --force-with-lease option."
    return
  fi
  branch=$(git branch --show-current)
  git push origin $branch --force-with-lease
}

rebaseLast() {
  if [ "$1" == "--help" ]; then
    colorPrint brightCyan "Usage: rebaseLast <num_commits>"
    colorPrint brightCyan "Starts an interactive rebase of the last <num_commits> commits."
    return
  fi
  git rebase -i HEAD~$1
}

resetLast() {
  if [ "$1" == "--help" ]; then
    colorPrint brightCyan "Usage: resetLast <num_commits>"
    colorPrint brightCyan "Undoes the last <num_commits> commits and leaves the changes in the staging area."
    return
  fi
  git reset --soft HEAD~$1
}

openpr() {
  if [ "$1" == "--help" ]; then
    colorPrint brightCyan "Usage: openpr"
    colorPrint brightCyan "Opens the browser to compare the current branch to the main branch."
    return
  fi
  repo=$(git config --get remote.origin.url | sed -e 's/^git@.*:\(.*\)\.git$/\1/' -e 's/^https:\/\/github.com\/\(.*\)\.git$/\1/')
  echo $repo
  branch=$(git branch --show-current)
  url="http://github.com/$repo/compare/$branch?expand=1"
  
  # Check the operating system
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS
    open "$url"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    xdg-open "$url"
  elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows
    start "$url"
  else
    colorPrint brightRed "Unsupported operating system. Please open the following URL in your browser:"
    colorPrint brightYellow "$url"
  fi
}

function squashRange {
    if [ "$1" == "--help" ]; then
      colorPrint brightCyan "Usage: squashRange <hashA> <hashB> <message>"
      colorPrint brightCyan "Squashes a range of commits between <hashA> and <hashB> into a single commit with a new commit message."
      return
    fi
    local hashA="$1"
    local hashB="$2"
    local message="$3"

    # Save the current branch name
    local current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Checkout the commit to squash into
    git checkout "$hashB"

    # Create a new branch at this commit
    git checkout -b mod_history

    # Reset the branch pointer to the commit before the first commit to squash,
    # but leave the index and working tree intact.
    git reset --soft "$(git rev-parse "$hashA~1")"

    # If a message was provided, use it for the new commit.
    # Otherwise, use a combination of all squashed commit messages.
    if [[ -n "$message" ]]; then
        git commit -am "$message"
    else
        local combined_message=$(git log --format=%B "$hashA~1..$hashB")
        git commit -am "$combined_message"
    fi

    # Remember the new commit hash
    local new_commit=$(git rev-parse HEAD)

    # Checkout the original branch and replay all commits after hashB onto the new commit
    git checkout "$current_branch"
    git rebase --onto "$new_commit" "$hashB"

    # Remove the temporary branch
    git branch -D mod_history
}

function squashLast {
    if [ "$1" == "--help" ]; then
      colorPrint brightCyan "Usage: squashLast <num_commits> <message>"
      colorPrint brightCyan "Squashes the last <num_commits> into a single commit with a new commit message."
      return
    fi
    local num_commits="$1"
    local message="$2"

    # Get the hash of the commit before the commits to squash
    local hash1=$(git rev-parse HEAD~"$((num_commits))")

    # Create a temporary script to use as the sequence editor
    echo '#!/bin/bash' > /tmp/editor.sh
    echo "awk 'NR>1 && /^pick/ {\$1=\"squash\"} {print}' \"\$1\" > tmp && mv tmp \"\$1\"" >> /tmp/editor.sh
    chmod +x /tmp/editor.sh

    # Start an interactive rebase with the commit before the commits to squash
    GIT_SEQUENCE_EDITOR="/tmp/editor.sh" GIT_EDITOR=":" git rebase -i "$hash1"

    # Amend the commit message if one was provided
    if [[ -n "$message" ]]; then
        git commit --amend -m "$message"
    fi

    # Remove the temporary script
    rm /tmp/editor.sh
}

git-glider() {
  if [ "$1" == "--help" ]; then
    colorPrint brightCyan "Usage: git-glider <command> [--help]"
    colorPrint brightCyan "Available commands:"
    colorPrint brightCyan "gup, gcmsg, ga, gst, gups, undo, gcmsgn, pushs, rebaseLast, resetLast, openpr, squashRange, squashLast"
    return
  fi
}
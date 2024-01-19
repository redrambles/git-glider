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
  gcmsg "$1" --no-verify
}

# Tested and works ✅
# git push origin <current_branch> --force-with-lease
pushs() {
  branch=$(git branch --show-current)
  git push origin $branch --force-with-lease
}


# Tested and works ✅
# rebaseLast <num_commits>
# starts interactive rebase of last <num_commits> commits
# todo implement --help with instructions
rebaseLast() {
  git rebase -i HEAD~$1
}

# Tested and works ✅
# resetLast <num_commits>
# undoes last <num_commits> commits
# leaves changes of last <num_commits> commits in staging
# todo implement --help with instructions
resetLast() {
  git reset --soft HEAD~$1
}

# Tested and works ✅
# opens browser to compare current branch to main
openpr() {
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

# Tested and works ✅
# squashRange <hashA> <hashB> <message>
# hashA has to be older than hashB
# todo implement --help with instructions

function squashRange {
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



# Tested and works ✅
# squashLast <num_commits> <message>
# todo implement --help with instructions
function squashLast {
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
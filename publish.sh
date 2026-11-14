#!/usr/bin/env bash
# Publish the Responsible AI repository collection to your GitHub profile.
#
# Requirements: git, GitHub CLI (https://cli.github.com) logged in with `gh auth login`.
# Usage:        ./publish.sh <your-github-username>
#
# The script:
#   1. replaces the GITHUB_USERNAME placeholder in every file,
#   2. creates three public repos and pushes them,
#   3. creates/updates your profile README repo (<username>/<username>),
#   4. adds topics so the repos are discoverable.
set -euo pipefail

USER="${1:-}"
if [[ -z "$USER" ]]; then
  echo "Usage: ./publish.sh <your-github-username>"; exit 1
fi
command -v gh >/dev/null || { echo "Install the GitHub CLI first: https://cli.github.com"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Run 'gh auth login' first."; exit 1; }

HERE="$(cd "$(dirname "$0")" && pwd)"

replace_placeholder() {
  # Portable in-place replace (works on macOS and Linux)
  grep -rl "GITHUB_USERNAME" "$1" --exclude-dir=.git 2>/dev/null | while read -r f; do
    perl -pi -e "s/GITHUB_USERNAME/$USER/g" "$f"
  done
}

publish_repo() {
  local name="$1" desc="$2" topics="$3"
  local dir="$HERE/$name"
  echo "==> $name"
  replace_placeholder "$dir"
  cd "$dir"
  [[ -d .git ]] || git init -q -b main
  git add -A
  git commit -q -m "Initial commit: $desc" || true
  if gh repo view "$USER/$name" >/dev/null 2>&1; then
    git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$USER/$name.git"
    git push -u origin main
  else
    gh repo create "$USER/$name" --public --description "$desc" --source . --push
  fi
  gh repo edit "$USER/$name" $(for t in $topics; do printf -- '--add-topic %s ' "$t"; done) >/dev/null
  cd "$HERE"
}

# Core must be pushed first: the other two install it from GitHub.
publish_repo rai-metrics-core \
  "Responsible AI metrics library: fairness, transparency, robustness and privacy for tabular ML" \
  "responsible-ai fairness explainability privacy ai-ethics machine-learning python model-cards"

publish_repo rai-finance-credit-fairness \
  "Responsible AI audit of credit-approval models: disparate impact, proxies, reason codes and profit impact" \
  "responsible-ai fairness credit-scoring fintech ai-ethics machine-learning python"

publish_repo rai-healthcare-clinical-fairness \
  "Responsible AI audit of clinical risk models: under-diagnosis bias, missed patients, care allocation, privacy" \
  "responsible-ai fairness healthcare clinical-ai ai-ethics privacy machine-learning python"

# Profile README lives in a repo named exactly like your username.
echo "==> profile README ($USER/$USER)"
replace_placeholder "$HERE/profile-readme"
if gh repo view "$USER/$USER" >/dev/null 2>&1; then
  echo "   $USER/$USER already exists. Not overwriting it."
  echo "   Copy the 'Responsible AI collection' section from profile-readme/README.md into it by hand."
else
  cd "$HERE/profile-readme"
  git init -q -b main && git add -A && git commit -q -m "Add profile README"
  gh repo create "$USER/$USER" --public --description "My GitHub profile" --source . --push
  cd "$HERE"
fi

echo
echo "Done. Visit https://github.com/$USER"
echo "Tip: pin the three repos on your profile (Customize your pins)."

# Publishing the Responsible AI collection

This bundle contains three repositories plus a profile README:

```
rai-metrics-core/                    metric library (publish first: the other two depend on it)
rai-finance-credit-fairness/         credit-approval case study
rai-healthcare-clinical-fairness/    clinical-risk case study
profile-readme/                      README for your <username>/<username> profile repo
publish.sh                           one-command publisher
```

## Option A: one command (recommended)

1. Install the GitHub CLI: https://cli.github.com and run `gh auth login`.
2. Unzip this bundle, open a terminal in the folder, then run:

```bash
./publish.sh YOUR_GITHUB_USERNAME
```

This replaces the `GITHUB_USERNAME` placeholder everywhere, creates the three public repos with
descriptions and topics, pushes them, and creates your profile README repo if you don't already have one.
CI (GitHub Actions) runs the tests automatically after each push.

**Windows:** run it from Git Bash or WSL.

## Option B: by hand

1. Find-and-replace `GITHUB_USERNAME` with your username in all files.
2. On github.com create empty public repos with the same folder names.
3. In each folder:
   ```bash
   git init -b main && git add -A && git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR_USERNAME/<repo-name>.git
   git push -u origin main
   ```
4. For the profile README, create a repo named exactly your username and push `profile-readme/README.md`.

## After publishing
* Pin the three repos on your profile (Profile → Customize your pins).
* Edit `profile-readme/README.md` to add your own background and contact links.

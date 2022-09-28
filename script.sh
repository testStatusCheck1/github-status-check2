#!/bin/bash
set -o errexit

GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'
SLEEP_TIMEOUT=0.5

# if [[ $1 == '--help' ]]; then
#   echo 'Usage: {RepoPath} {filename}'
# fi

# while getopts r:f: flag
# do
#     case "${flag}" in
#         u) repo=${OPTARG};;
#         f) filename=${OPTARG};;
#     esac
# done

# echo "repo: $repo";
# echo "filename: $filename";

while true
do
	echo "Press ${RED}[CTRL+C]${NC} to stop.."
  randomBranchName=$(openssl rand -hex 5)
  echo "${GREEN}OK${NC} creating new branch name: ${randomBranchName}"
  git checkout -b ${randomBranchName}

  echo "${GREEN}OK${NC} creating file for commit"
  echo "export SLACK_API_TOKEN='xoxp-858723095049-581481478633-908968721956-f16b85d1f73ef37c02323bf3fd537ea5'" > data.txt
  git add data.txt

  echo "${GREEN}OK${NC} commit and push"
  git commit -m "Add stress test file"
  git push origin ${randomBranchName}

  echo "${GREEN}OK${NC} creating a PR for the branch"
  ## brew install gh
  ## gh auth login
  gh pr create --title "pr for ${randomBranchName}" --body "body for ${randomBranchName}"
  
  echo "${GREEN}OK${NC} done branch ${randomBranchName}"
  git checkout main
  echo "${GREEN}Goint to sleep for ${SLEEP_TIMEOUT}${NC}"
	sleep ${SLEEP_TIMEOUT}
done
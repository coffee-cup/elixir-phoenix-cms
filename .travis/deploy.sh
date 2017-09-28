#!/bin/bash
set -e

if [[ $TRAVIS_BRANCH == "master" && $TRAVIS_PULL_REQUEST == "false" ]]; then

  echo "Starting deploying 🚀"

  ls

  eval "$(ssh-agent -s)"
  chmod 600 travis_dokku
  ssh-add travis_dokku
  ssh-keyscan 159.203.47.250 >> ~/.ssh/known_hosts
  git remote add dokku dokku@jakerunzer.space:writing
  git config --global push.default simple
  git push dokku master

  echo "Deployed 🤘"

else
  echo "Skipping deploy because build is not triggered from the master branch."
fi;
#!/bin/bash

version_bump=${1?}

git checkout urbi
if [[ $? != 0 ]]; then exit 1; fi
git pull

source .release_version
MAJOR_VERSION=$major
MINOR_VERSION=$minor
PATCH_VERSION=$patch
CANDIDATE_VERSION=$candidate

case $version_bump in
  'major')
    ((MAJOR_VERSION++))
    CANDIDATE_VERSION=0
    ;;
  'minor')
    ((MINOR_VERSION++))
    CANDIDATE_VERSION=0
    ;;
  'patch')
    ((PATCH_VERSION++))
    CANDIDATE_VERSION=0
    ;;
  'candidate')
    ((CANDIDATE_VERSION++))
    ;;
  *)
    exit 1;
esac

echo "major=${MAJOR_VERSION}" >.release_version
echo "minor=${MINOR_VERSION}" >>.release_version
echo "patch=${PATCH_VERSION}" >>.release_version
echo "candidate=${CANDIDATE_VERSION}" >>.release_version

BRANCH_NAME="urbi-service/release-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-rc${CANDIDATE_VERSION}"

git checkout -b ${BRANCH_NAME}
git add .release_version
git commit -m "chore: version bump"
git push --set-upstream origin ${BRANCH_NAME}



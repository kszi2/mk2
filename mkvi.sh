#!/usr/bin/env sh
# Generates a mk2.vi file, containing the current version information about the
# deployed mk2
# Requires git to allow access to the repository (same user)

# get tag data from git
last_tag_data=$(git tag --sort="-v:refname" --format "%(objectname:short) %(refname:short)" | head -1)
last_tag_sha=$(echo "$last_tag_data" | cut -d ' ' -f 1)
last_tag=$(echo "$last_tag_data" | cut -d ' ' -f 2)

# get commit data from git
last_commit_data=$(git log HEAD ^HEAD~1 --pretty="format:%h on %cI")
last_commit_sha=$(echo "$last_commit_data" | cut -d ' ' -f 1)

# output
rm -f mk2.vi
touch mk2.vi
chmod 644 mk2.vi

if [ "$last_tag_sha" = "$last_commit_sha" ]
then
  echo "release" >> mk2.vi
  echo "$last_tag" >> mk2.vi
else
  echo "rolling patch" >> mk2.vi
  echo "patch of $last_tag" >> mk2.vi
fi
echo "$last_commit_data" >> mk2.vi

chmod 444 mk2.vi

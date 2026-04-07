#!/bin/bash

### -----------------------------
### CONFIGURATION
### -----------------------------
GITHUB_TOKEN="GITHUB_TOKEN"
ORG_NAME="Hanu-Devops-Practice"

REPO_NAME="my-new-repo"
TEAM_NAME="my-new-team"
TEAM_PERMISSION="maintain"   # options: pull / triage / push / maintain / admin

### -----------------------------
### CREATE REPOSITORY
### -----------------------------
echo "Creating repository $REPO_NAME ..."

curl -s -X POST "https://api.github.com/orgs/$ORG_NAME/repos" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d "{
        \"name\": \"$REPO_NAME\",
        \"private\": false,
        \"auto_init\": true
      }"

echo "✅ Repo created"


### -----------------------------
### CREATE TEAM
### -----------------------------
echo "Creating team $TEAM_NAME ..."

TEAM_RESPONSE=$(curl -s -X POST "https://api.github.com/orgs/$ORG_NAME/teams" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d "{
        \"name\": \"$TEAM_NAME\",
        \"privacy\": \"closed\"
      }")

TEAM_SLUG=$(echo "$TEAM_RESPONSE" | jq -r '.slug')

echo "✅ Team created with slug: $TEAM_SLUG"


### -----------------------------
### GRANT TEAM ACCESS TO REPO
### -----------------------------

echo "Granting team '$TEAM_NAME' permission '$TEAM_PERMISSION' to repo '$REPO_NAME'..."

curl -s -X PUT \
  -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/orgs/$ORG_NAME/teams/$TEAM_SLUG/repos/$ORG_NAME/$REPO_NAME?permission=$TEAM_PERMISSION"

echo "✅ Team access assigned successfully"


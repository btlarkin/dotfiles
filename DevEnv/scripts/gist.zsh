#!/usr/bin/env zsh
emulate -LR zsh
setopt errexit nounset pipefail

# ── Config & env ────────────────────────────────────
[[ -n ${GITHUB_TOKEN-} ]] || {
  echo "❌ Please export GITHUB_TOKEN (with gist scope)" >&2; exit 1
}
GIST_ID=$(jq -r '.gistId' config.json)
VAULT=$(jq -r '.vaultPath' config.json)

# ── Build payload ────────────────────────────────────
typeset -A files
for file in $(find $VAULT -maxdepth 1 -name '*.md'); do
  name=$(basename $file)
  content=$(<"$file")
  files[$name]=$(jq -Rs . <<<"$content")
done

body=$(jq -nc --argjson f "$(jq -n --argjson m "$(printf '%s\n' ${(kv)files}|jq -s 'reduce .[] as $i ({}; . + { ($i|keys[0]): { content: $i|.[keys[0]].content } })')" '$m')" \
  '{ description:"Custom Roadmaps", public:false, files:$f }')

# ── Send to GitHub ───────────────────────────────────
if [[ $GIST_ID == null ]]; then
  url="https://api.github.com/gists"; method=POST
else
  url="https://api.github.com/gists/$GIST_ID"; method=PATCH
fi

resp=$(curl -s -X $method \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d "$body" "$url")

echo $resp | jq '{id, html_url}'


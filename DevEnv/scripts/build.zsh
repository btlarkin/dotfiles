#!/usr/bin/env zsh

emulate -LR zsh
setopt errexit nounset pipefail

# ─── 1) Check Dependencies ──────────────────────────
local missing=()
for dep in git jq sed xargs; do
  command -v $dep >/dev/null 2>&1 || missing+=$dep
done
if (( ${#missing[@]} )); then
  echo "❌ Install missing tools: ${missing[*]}" >&2
  echo "   e.g. brew install git jq; sudo apt-get install git jq" >&2
  exit 1
fi

# ─── 2) Load config ─────────────────────────────────
local cfg vault maps
cfg=$(jq -c . config.json)
vault=$(jq -r .vaultPath <<<"$cfg")
maps=("${(@f)$(jq -r '.roadmaps[]' <<<"$cfg")}")

# ─── 3) Sparse-clone only content/roadmaps ────────
tmp=$(mktemp -d)
cd $tmp

git init -q
git remote add origin https://github.com/kamranahmedse/developer-roadmap.git
git config core.sparseCheckout true

# specify exactly what to pull
cat <<EOF > .git/info/sparse-checkout
content/roadmaps/
EOF

git pull -q --depth=1 origin master

root="$tmp/content/roadmaps"

# ─── 4) Build selected roadmaps ────────────────────
mkdir -p "$vault"
for id in $maps; do
  src="$root/$id/content-paths.json"
  out="$vault/${id}.md"

  jq -r 'to_entries|.[] .value' "$src" \
    | xargs cat \
    | sed \
      -e "s/\"/'/g" \
      -e "s/' >/'>/g" \
      -e "s/# #/#/g" \
      -e "s/^### /\n\n#### /g" \
      -e "s/^## /\n\n### /g" \
      -e "s/^# /\n\n## /g" \
      -e "s/<ResourceGroupTitle>\(.*\)<\/ResourceGroupTitle>/### \1/g" \
      -e "s/### Free Content//g" \
      -e "s/<BadgeLink[^>]*href='\([^']*\)'.*>\(.*\)<\/BadgeLink>/ - [ ] [\2](\1)/g" \
    > "$out"

  echo "✅ Built $out"
done

# ─── 5) Refresh web-ui list ─────────────────────────
mkdir -p ../web-ui
ls "$root" \
  | jq -R . \
  | jq -s . \
  > ../web-ui/roadmaps.json
echo "✅ Updated web-ui/roadmaps.json"

# ─── 6) Cleanup ────────────────────────────────────
cd - &>/dev/null
rm -rf $tmp
echo "🎉 All done. Your MD files are in: $vault"


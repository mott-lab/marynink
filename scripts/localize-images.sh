#!/usr/bin/env bash
# Copies the photos, video thumbnails and résumé PDF that the pages currently
# load from Wix into this repo, then rewrites the pages to use the local copies.
# Run once from the repo root, before the Wix site is taken down:
#
#     bash scripts/localize-images.sh
#
# Afterwards, review the diff, commit, and push.

set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p assets/img

WIX="https://static.wixstatic.com/media"

declare -A FILES=(
  # local path                      remote URL (full-size original)
  ["assets/img/headshot.jpg"]="$WIX/5681b1_0198e34753824c97a51f817c208abb28~mv2.jpg"
  ["assets/img/portrait.jpg"]="$WIX/5681b1_aa1f52a4cecd41df82ac7505c5632395~mv2.jpeg"
  ["assets/img/stage.jpg"]="$WIX/5681b1_60ad9499a696402ca40e4a3a3530dc8d~mv2.jpg"
  ["assets/img/teaching.jpg"]="$WIX/5681b1_65af10c7dec344f9b06cfafd38406314~mv2.jpg"
  ["assets/img/thumb-meadowlark.jpg"]="$WIX/5681b1_4193175b0b6e46e4a4966d03e0570d98f002.jpg/v1/fill/w_1280,h_720,enc_auto/file.jpeg"
  ["assets/img/thumb-baking.jpg"]="$WIX/5681b1_f1ef5cc8d15c46eebb0e040eceede13af002.jpg/v1/fill/w_1280,h_720,enc_auto/file.jpeg"
  ["assets/img/thumb-reel.jpg"]="https://i.ytimg.com/vi/K8fSyA7ZMkI/maxresdefault.jpg"
  ["assets/Mary-Nink-Resume.pdf"]="https://deaa3e24-f055-468d-90e5-e0604a374ff5.filesusr.com/ugd/5681b1_c90a8834eb474aa58bffc261a9542d9f.pdf"
)

for local in "${!FILES[@]}"; do
  echo "→ $local"
  curl -fsSL --retry 3 -o "$local" "${FILES[$local]}"
done

# Rewrite <img src> and the PDF link in every page. Each Wix image id maps to one local file,
# whatever size variant the page requested.
rewrite() {  # $1 = regex to match in src/href, $2 = local path
  sed -i -E "s#(src|href)=\"$1\"#\1=\"$2\"#g" index.html about.html resume.html media.html teaching.html contact.html
}

rewrite "https://static\.wixstatic\.com/media/5681b1_0198e34753824c97a51f817c208abb28~mv2\.jpg[^\"]*" "assets/img/headshot.jpg"
rewrite "https://static\.wixstatic\.com/media/5681b1_aa1f52a4cecd41df82ac7505c5632395~mv2\.jpeg[^\"]*" "assets/img/portrait.jpg"
rewrite "https://static\.wixstatic\.com/media/5681b1_60ad9499a696402ca40e4a3a3530dc8d~mv2\.jpg[^\"]*" "assets/img/stage.jpg"
rewrite "https://static\.wixstatic\.com/media/5681b1_65af10c7dec344f9b06cfafd38406314~mv2\.jpg[^\"]*" "assets/img/teaching.jpg"
rewrite "https://static\.wixstatic\.com/media/5681b1_4193175b0b6e46e4a4966d03e0570d98f002\.jpg[^\"]*" "assets/img/thumb-meadowlark.jpg"
rewrite "https://static\.wixstatic\.com/media/5681b1_f1ef5cc8d15c46eebb0e040eceede13af002\.jpg[^\"]*" "assets/img/thumb-baking.jpg"
rewrite "https://i\.ytimg\.com/vi/K8fSyA7ZMkI/maxresdefault\.jpg" "assets/img/thumb-reel.jpg"
rewrite "https://deaa3e24-f055-468d-90e5-e0604a374ff5\.filesusr\.com/[^\"]*\.pdf" "assets/Mary-Nink-Resume.pdf"

# og:image tags need an absolute URL; point them at the hosted copy of the headshot.
SITE_URL="${SITE_URL:-https://mott-lab.github.io/marynink}"
sed -i -E "s#content=\"https://static\.wixstatic\.com/media/5681b1_0198e34753824c97a51f817c208abb28~mv2\.jpg[^\"]*\"#content=\"$SITE_URL/assets/img/headshot.jpg\"#g" index.html
sed -i -E "s#content=\"https://i\.ytimg\.com/vi/K8fSyA7ZMkI/maxresdefault\.jpg\"#content=\"$SITE_URL/assets/img/thumb-reel.jpg\"#g" media.html

echo
echo "Done. Review with: git diff --stat && git status"

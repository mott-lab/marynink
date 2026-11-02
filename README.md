# marynink — personal site

Static site for Mary Nink: actress, singer, voice & acting coach. Plain HTML, CSS and a little JavaScript; no build step. Hosted on GitHub Pages.

**Live:** https://mott-lab.github.io/marynink/

## Pages

| File | Purpose |
|---|---|
| `index.html` | Home: hero, latest credit, reel teaser, teaching teaser |
| `about.html` | Bio, at-a-glance facts, off-stage work |
| `resume.html` | Credits rendered on the page, PDF download, print-friendly |
| `media.html` | Embedded reel with tracklist, other performances, photos |
| `teaching.html` | Lessons: who it is for, offerings, how it works |
| `contact.html` | Email, social links, contact form |
| `404.html` | Served by GitHub Pages for any missing path |

Shared styling lives in `css/style.css` (design tokens at the top). `js/main.js` handles the mobile menu, the footer year, and the contact form.

## Editing

Each page is self-contained. The header and footer are repeated in every file, so a change to the navigation means editing all six pages (a search-and-replace across `*.html` works well).

Things marked `TODO` in the HTML, or shown in `[BRACKETS]` on the live site, still need real content:

- The two Wix-hosted videos on `media.html` (Meadowlark, What Baking Can Do on piano). Upload them to YouTube and point the cards at the watch URLs, or embed them like the reel.

## Images and the résumé PDF

The pages currently load photos, thumbnails and the résumé PDF **directly from Wix's CDN**, so the site works before anything is copied over. Before the Wix site is deleted, bring those files into this repo:

```bash
bash scripts/localize-images.sh
git add -A && git commit -m "Localize images and résumé PDF" && git push
```

The script downloads each file into `assets/` and rewrites the page references. New or replacement photos go in `assets/img/`; keep them under ~400 KB each (export at 1600 px on the long side, JPEG quality ~80).

## Contact form

By default the form opens the visitor's mail app with the message pre-filled (works anywhere, no account needed). To send without leaving the page:

1. Create a free form at https://formspree.io and copy its endpoint (`https://formspree.io/f/XXXXXXXX`).
2. In `contact.html`, set `data-endpoint="https://formspree.io/f/XXXXXXXX"` on the `<form>`.

## Hosting

GitHub Pages serves the `main` branch from the repository root (Settings → Pages → Deploy from a branch → `main` / `/ (root)`). Every push to `main` redeploys within a minute or two.

### Custom domain (later)

1. Buy the domain (Cloudflare, Porkbun and Namecheap are all fine; roughly $10–15/year for a `.com`).
2. At the registrar, add DNS records: four `A` records for the apex pointing at GitHub Pages' IPs (`185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`) and a `CNAME` for `www` pointing at `mott-lab.github.io`.
3. In the repo: Settings → Pages → Custom domain → enter the domain, then tick "Enforce HTTPS" once the certificate is issued.
4. In this repo, replace `https://mott-lab.github.io/marynink/` with the new domain in the `<link rel="canonical">` and `og:url` tags of each page, and change `/marynink/` to `/` in `404.html`.

GitHub's reference: https://docs.github.com/pages/configuring-a-custom-domain-for-your-github-pages-site

### Moving the repo to Mary's own GitHub account

Settings → General → Danger Zone → Transfer ownership. GitHub redirects the old URL for a while; update the canonical URLs as in step 4 above.

## Design

- Type: Bricolage Grotesque (display), Instrument Sans (body), Fraunces italic (short eyebrow lines), all from Google Fonts.
- Color: ink `#17161A`, paper `#F3F2EF`, garnet accent `#A3202F`. Change `--accent` in `css/style.css` to retheme.
- Original mockup: Claude Design canvas "Mary Nink Site Redesign".

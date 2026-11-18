# marynink — personal site

Static site for Mary Nink: actress, singer, voice & acting coach. Plain HTML, CSS and a little JavaScript; no build step. Hosted on GitHub Pages.

**Live:** https://marynink.com/ (custom domain; `www.marynink.com` redirects here; the old `mott-lab.github.io/marynink/` address redirects as well)

## Pages

| File | Purpose |
|---|---|
| `index.html` | Home: hero, latest credit, reel teaser, teaching teaser |
| `about.html` | Bio, at-a-glance facts, off-stage work |
| `resume.html` | Credits rendered on the page, theatrical résumé and professional CV downloads, print-friendly |
| `media.html` | Embedded reel with tracklist, other performances, photos |
| `teaching.html` | Lessons: who it is for, offerings, how it works |
| `contact.html` | Email, social links, contact form |
| `404.html` | Served by GitHub Pages for any missing path |

Shared styling lives in `css/style.css` (design tokens at the top). `js/main.js` handles the mobile menu, the footer year, and the contact form.

## Editing

Each page is self-contained. The header and footer are repeated in every file, so a change to the navigation means editing all six pages (a search-and-replace across `*.html` works well).

Things marked `TODO` in the HTML, or shown in `[BRACKETS]` on the live site, still need real content:

- The two Wix-hosted videos on `media.html` (Meadowlark, What Baking Can Do on piano). Upload them to YouTube and point the cards at the watch URLs, or embed them like the reel.

## Images

Two downloadable PDFs live in `assets/`: `Mary-Nink-Resume.pdf` (one-page theatrical résumé) and `Mary-Nink-CV.pdf` (professional CV). Keep the names so the links stay stable.

The theatrical résumé is generated from `src/resume-pdf.html`. To update it, edit that file and run `node src/render-resume-pdf.js` (needs Playwright with Chromium and the Caladea font installed); the PDF is written to `assets/`. The CV is maintained outside the repo; replace the file to update it.

The pages currently load photos and thumbnails **directly from Wix's CDN**, so the site works before anything is copied over. Before the Wix site is deleted, bring those files into this repo:

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

### Custom domain

1. Buy the domain (Cloudflare, Porkbun and Namecheap are all fine; roughly $10–15/year for a `.com`).
2. At the registrar, add DNS records: four `A` records for the apex pointing at GitHub Pages' IPs (`185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`) and a `CNAME` for `www` pointing at `mott-lab.github.io`. (Done, November 2026, at Wix.)
3. In the repo: Settings → Pages → Custom domain → enter the domain, then tick "Enforce HTTPS" once the certificate is issued.
4. In this repo, replace `https://marynink.com/` with the new domain in the `<link rel="canonical">` and `og:url` tags of each page, and change `/marynink/` to `/` in `404.html`.

GitHub's reference: https://docs.github.com/pages/configuring-a-custom-domain-for-your-github-pages-site

### Moving the repo to Mary's own GitHub account

Settings → General → Danger Zone → Transfer ownership. GitHub redirects the old URL for a while; update the canonical URLs as in step 4 above.

## Design

- Type: Bricolage Grotesque (display), Instrument Sans (body), Fraunces italic (short eyebrow lines), all from Google Fonts.
- Color: ink `#17161A`, paper `#F3F2EF`, garnet accent `#A3202F`. Change `--accent` in `css/style.css` to retheme.
- Original mockup: Claude Design canvas "Mary Nink Site Redesign".

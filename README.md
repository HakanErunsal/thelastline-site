# The Last Line — landing page

Static marketing site for **The Last Line** (Rigbak), deployed to GitHub Pages at [thelastline.rigbak.com](https://thelastline.rigbak.com).

Layout: **cinematic in-game first** — full-bleed hero video, screenshot-led feature rows, horizontal gallery strip. iPhone / App Store only at launch.

## Local preview

This is a **plain static site** — no Next.js, no build step, no Velite. That is why the folder looks smaller than `hakanerunsal`: it is just HTML, CSS, images, and video.

From this folder:

```bash
cd D:\Repos\haer-website\thelastline
npm run dev
```

Then open **http://localhost:3456** in your browser.

Other options if you prefer:

```bash
npx --yes serve .
# or
python -m http.server 3456
```

**Important:** do not open `index.html` directly from File Explorer (`file://`). CSS paths like `/css/styles.css` only work through a local server.

If images or video look missing, confirm `assets/images/` and `assets/video/` are present (they are copied from the portfolio repo, not pulled at build time).

## Deploy to GitHub Pages

### 1. Create the repository

1. Create a new GitHub repo (e.g. `rigbak/thelastline`).
2. Push this folder to the `main` branch.

```bash
git init
git add .
git commit -m "Add The Last Line landing page"
git remote add origin git@github.com:rigbak/thelastline.git
git push -u origin main
```

### 2. Enable GitHub Pages

1. Repo **Settings → Pages**
2. **Build and deployment → Source:** GitHub Actions
3. After the first workflow run, note the `*.github.io` URL

The `CNAME` file in this repo tells GitHub Pages to serve the site at `thelastline.rigbak.com`.

### 3. DNS at your domain registrar (rigbak.com)

Add a **CNAME** record:

| Type  | Name        | Value              |
|-------|-------------|--------------------|
| CNAME | thelastline | `rigbak.github.io` |

Use your GitHub **organization or user** Pages host if different (shown in repo Settings → Pages after setup).

DNS can take up to 24–48 hours to propagate. GitHub will provision HTTPS automatically once DNS resolves.

### 4. Confirm custom domain in GitHub

In **Settings → Pages → Custom domain**, enter:

```
thelastline.rigbak.com
```

GitHub should show “DNS check successful” once the CNAME is live.

## Structure

```
index.html          Landing page
privacy.html        Privacy policy (placeholder — update before App Store)
terms.html          Terms of use (placeholder — update before App Store)
css/styles.css      Styles
assets/images/      Screenshots & badges
assets/video/       Trailer
CNAME               Custom domain for Pages
.github/workflows/  Deploy on push to main
```

## Assets

Game screenshots and trailer are copied from the [hakanerunsal](https://github.com/hakanerunsal/hakanerunsal) portfolio repo. Re-copy when marketing assets change.

## App Store link

When the App Store listing is live, replace the muted badge in `index.html` with a linked badge:

```html
<a href="https://apps.apple.com/app/idXXXXXXXXX" target="_blank" rel="noopener noreferrer">
  <img class="store-badge" src="/assets/images/appstore-download-badge.svg" alt="Download on the App Store" />
</a>
```

Remove the `opacity` / grayscale styling from `.store-badge` in CSS when the link is active.

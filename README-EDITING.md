# Easy Content & Image Editing Guide (Sibaba Foundation Website)

This website now supports **simple image updates from one config file**.

## 1) Where to put your images
- Place your image files in the project folder (or an `images/` folder if you create one).
- Example:
  - `SIBABA FOUNDATION LOGO.png`
  - `images/new-hero.jpg`

## 2) Edit one file only for image paths
Open:

- `site-config.json`

You will see:

```json
{
  "images": {
    "siteLogo": "SIBABA FOUNDATION LOGO.png",
    "homeHeroMain": "...",
    "servicesHeroMain": "...",
    "servicesEducationCard": "...",
    "servicesFeaturedBlock": "...",
    "aboutHeroMain": "..."
  }
}
```

Change any value to your new image path.

Example:

```json
"siteLogo": "images/new-logo.png"
```

## 3) Save and refresh browser
- Save `site-config.json`
- Refresh the webpage
- All matching image spots update automatically

## 4) Current image keys
- `siteLogo` → Header/footer logo (all pages)
- `homeHeroMain` → Main hero image on Home
- `servicesEducationCard` → Featured card image block
- `aboutHeroMain` → About/education visual blocks
- `servicesFeaturedBlock` → Featured/strategy visual block

## 5) Notes
- Keep filenames exact (including spaces and extension).
- If an image path is wrong, the page will keep existing fallback image.
- This setup avoids editing many HTML lines whenever you change images.

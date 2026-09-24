# Rafael Camacho's personal website

This repository contains the source for
[camachodejay.github.io](https://camachodejay.github.io/). The site currently
uses Jupyter Book 1 while its migration to Jupyter Book 2 is developed and
tested on the `website-modernization` branch. The staged migration plan is in
[`PLAN.md`](PLAN.md).

## Requirements

- Git
- [uv](https://docs.astral.sh/uv/)
- Windows PowerShell for the local preview script

Create or update the locked project environment from the repository root:

```powershell
uv sync --locked
```

## Edit the website

The published content is maintained in:

- `index.md`
- `cv.md`
- `courses.md`
- `publications.md`

Navigation is defined in `_toc.yml`, and Jupyter Book configuration is in
`_config.yml`.

## Build and preview locally

Run:

```powershell
.\scripts\preview.ps1
```

The script builds the site in the Windows temporary directory, serves it at
<http://127.0.0.1:8000/>, and opens the default browser. Press `Ctrl+C` in
PowerShell to stop the server and delete the temporary build.

If the PowerShell execution policy blocks the direct command, use:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\preview.ps1
```

Use `-Port` to select another port, for example:

```powershell
.\scripts\preview.ps1 -Port 8080
```

## Publishing

The live GitHub Pages site is currently maintained separately on the
`gh-pages` branch. During the migration, review changes through the local
preview and do not replace the production build until the new site has been
approved.

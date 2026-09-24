# Rafael Camacho's personal website

This repository contains the source for
[camachodejay.github.io](https://camachodejay.github.io/). The source on the
`website-modernization` branch uses Jupyter Book 2; the production site remains
on the previous Jupyter Book 1 build until the migration is approved. The
staged migration plan is in [`PLAN.md`](PLAN.md).

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

Navigation and Jupyter Book configuration are defined in `myst.yml`.

## Validate locally

Run the non-interactive validation check before committing:

```powershell
.\scripts\check.ps1
```

The script synchronizes the locked environment, removes any previous `_build`
output, and performs a clean Jupyter Book 2 build with strict validation. It
deletes the generated site when the check finishes, including after a failure.

## Build and preview locally

Run:

```powershell
.\scripts\preview.ps1
```

The script synchronizes the locked environment, copies the current working tree
to the Windows temporary directory, performs a strict Jupyter Book 2 build,
serves it at <http://127.0.0.1:8000/>, and opens the default browser. Press
`Ctrl+C` in PowerShell to stop the server and delete the temporary copy.

On its first run, Jupyter Book may download its managed Node.js runtime and web
theme dependencies. The managed Node.js runtime is cached outside the
repository. Because the temporary site build is deleted after every preview,
rebuilding its disposable web theme can take a few minutes.

If the PowerShell execution policy blocks the direct command, use:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\preview.ps1
```

The same fallback can be used for validation by replacing `preview.ps1` with
`check.ps1`.

Use `-Port` to select another port, for example:

```powershell
.\scripts\preview.ps1 -Port 8080
```

## Automated pull-request validation

The workflow in `.github/workflows/validate.yml` runs when a pull request
targets `master`. A fresh Linux runner installs the pinned Python and uv
environment, performs the same locked strict build, and uploads the generated
HTML as a seven-day workflow artifact.

The check and artifact are for validation only. This workflow has read-only
repository permission and does not deploy or modify the live website.

## Publishing

The live GitHub Pages site is currently maintained separately on the
`gh-pages` branch. During the migration, review changes through the local
preview and do not replace the production build until the new site has been
approved.

# Personal website modernization plan

## Goals and agreed direction

Modernize the site without replacing its basic publishing model or expanding the
content before the foundations are reliable. The work should be done in small,
reviewable steps so that each new tool can be understood before the next one is
introduced.

The agreed priorities are:

1. Make the existing content minimal but correct.
2. Create a reproducible local environment and migrate to Jupyter Book 2.
3. Make the local build repeatable, then introduce GitHub build checks one step
   at a time.
4. Design and thoroughly test automated publication and citation metrics.
5. Create a low-effort, human-reviewed workflow for news and article drafts.
6. Perform the larger content review.
7. Improve the visual design after the content and build are stable.
8. Automate production deployment only after the new site has been approved
   locally and in a preview.

## Current state

- The site is a small Jupyter Book 1 project whose last commit was made on July
  6, 2022.
- Editable content is primarily in `index.md`, `cv.md`, `courses.md`, and
  `publications.md`.
- Navigation and site configuration are defined in `_toc.yml` and
  `_config.yml`.
- Publishing is based on generated HTML in the `gh-pages` branch rather than an
  automated workflow.
- There is no GitHub Actions workflow, `.gitignore`, README, or automated
  validation.
- Generated `_build` files account for 140 of the 153 tracked files.
- `requirements.txt` contains three unpinned dependencies: Jupyter Book,
  Matplotlib, and NumPy.
- The configured Mambaforge base environment does not currently contain
  Jupyter Book, Sphinx, NumPy, or Matplotlib.
- `_config.yml` points repository source links at `gh-pages`, although editable
  source files are on `master`.
- The current logo is the generic Jupyter Book logo rather than personal
  branding.
- There is no custom domain. Retain the free `github.io` address; other
  providers' free subdomains would add migration work without providing a
  meaningful branding advantage. Revisit a custom domain only if that changes.

## Decisions from the review

- Keep Jupyter Book and migrate to Jupyter Book 2.
- Use a repository-local, locked Python environment rather than the Conda base
  environment. Prefer `uv`, `pyproject.toml`, `.python-version`, and a committed
  `uv.lock`; confirm that Jupyter Book 2 and all required packages resolve on
  Windows and GitHub's Linux runner before finalizing this choice.
- Test and approve the new site locally before changing production deployment.
- Keep LinkedIn and GitHub as the main social links. Remove the inactive podcast
  and, unless there is a current reason to retain it, Twitter/X.
- Do not make Google Scholar scraping a site dependency. Use a documented API
  and stable author identifier for automated metrics, while keeping Google
  Scholar only as an optional external profile link after its malformed URL is
  corrected.
- Generate news and article drafts, but require human review before anything is
  published.
- Create personal branding later; it is not a prerequisite for the migration.

## Phase 1: Protect the current site and make a minimal content pass

- Create a modernization branch.
- Record the current live URL, GitHub Pages settings, and screenshots of the
  important pages so that the existing site can be compared and restored.
- Confirm which branch is the repository's default and which branch currently
  publishes the site.
- Correct the visible spelling errors:
  - `mictoscopy` to `microscopy`
  - `Microacopy` to `Microscopy`
  - `Scoial media` to `Social media`
  - `Asociations` to `Associations`
  - `Quick into` to `Quick intro`
- Fix broken or malformed links, including the Google Scholar URL with two
  conflicting `user` parameters.
- Remove the podcast and Twitter/X cards, leaving LinkedIn and GitHub.
- Shorten or archive obviously stale news and “latest in 2021” wording without
  attempting the full biography/CV rewrite yet.

**Exit criterion:** the current content is small, accurate enough to migrate,
and the deployed version has not changed.

## Phase 2: Clean the repository and create a reproducible environment

- Add a `.gitignore` covering `_build`, caches, `.venv`, editor files, and local
  secrets.
- Add a concise README with setup, editing, preview, test, and eventual
  deployment instructions.
- Replace the unpinned `requirements.txt` workflow with a `pyproject.toml` and a
  committed lockfile. Document `uv sync` and `uv run` commands so the same
  environment is used locally and in automation.
- Pin the supported Python version and document how VS Code should select the
  repository's `.venv`.
- Remove unused Jupyter Book tutorial/sample pages and notebooks only after
  confirming that they are not linked or needed.
- Keep tracked `_build` artifacts temporarily. Stop tracking them only after a
  replacement preview/deployment path is proven.

**Exit criterion:** a fresh clone can create the environment and run a single
documented command without using the Conda base environment.

## Phase 3: Migrate to Jupyter Book 2 and validate locally

- Run the official Jupyter Book upgrade in the modernization branch, producing
  `myst.yml` from `_config.yml` and `_toc.yml`.
- Review the generated configuration rather than accepting it blindly:
  navigation, repository links, analytics, metadata, logo, notebook execution,
  and bibliography settings all need explicit verification.
- Correct repository links so they point to the editable default branch.
- Build and serve the site locally; resolve build errors and material warnings.
- Check all pages at desktop and mobile widths and compare them with the saved
  baseline screenshots.
- Record old and new URLs. Jupyter Book 2 uses different URL conventions, so
  preserve important inbound links with redirects where feasible.
- Keep the Jupyter Book 1 configuration backups until the migrated site has been
  accepted.

**Exit criterion:** the complete site builds from the locked environment, has
no unexplained warnings, and is approved in a local visual review.

## Phase 4: Introduce build checks in small learning steps

Introduce one concept at a time, documenting what it does and how to inspect a
failure before adding the next:

1. Add a local validation command that performs a clean Jupyter Book build.
2. Add a GitHub Actions workflow that runs the same locked build on pull
   requests and uploads the built site as an artifact; it must not deploy.
3. Add internal-link and basic content checks once the build job is stable.
4. Optionally add a preview mechanism if reviewing an artifact is too awkward.

Do not enable production deployment in this phase.

**Exit criterion:** pull requests clearly show whether the same build that works
locally also works on GitHub, and the workflow is understandable and documented.

## Phase 5: Automate publications and citation metrics

Treat publication identity and citation metrics as separate concerns:

- Use an ORCID iD, DOI list, or maintained BibTeX file as the curated source of
  publication identity. ORCID is useful for identifying works, but it is not the
  citation-count provider.
- Prototype Semantic Scholar and OpenAlex as citation sources. Both expose
  author/work citation data through documented APIs; Semantic Scholar directly
  exposes `paperCount`, `citationCount`, and `hIndex` on author records.
- Compare coverage and author disambiguation for the actual publication list
  before selecting a primary provider. Pin the chosen provider's author ID; do
  not rely on a name search during every build.
- Keep raw API retrieval separate from rendering. A script should write a small,
  deterministic data file, and the site build should render from that file so a
  temporary API outage cannot break the website.
- Display the provider and “last updated” date beside generated metrics because
  citation totals differ between databases.
- Keep a manual override and last-known-good data path.

Required tests:

- Fixture-based parsing tests that do not call a live API.
- Schema and missing-field tests.
- Author-identity and duplicate-publication tests, preferably using DOI and
  ORCID identifiers.
- Sanity checks that reject implausible drops, unexpected empty results, and
  large jumps until reviewed.
- A live integration check run manually before scheduling updates.
- A comparison of publication count, citation count, and h-index against the
  current manually verified values, with accepted differences documented.

After the pipeline is trusted, schedule a monthly GitHub Actions job that opens
a pull request containing updated data. Do not let it publish metric changes
directly to production.

**Exit criterion:** metrics can be regenerated repeatably, their provenance and
date are visible, tests catch bad data, and updates arrive as reviewable diffs.

## Phase 6: Make news and articles easier to publish

Start with the smallest useful human-in-the-loop workflow:

1. Define a short article template with title, date, summary, body, tags, and
   optional source links.
2. Add an `articles/` directory whose frontmatter automatically feeds a “latest
   updates” area, so publishing an article does not also require hand-editing the
   homepage.
3. Create a local draft command that accepts notes or an audio file. Audio may
   be transcribed locally with an open-source speech-to-text model, or through a
   transcription API such as OpenAI's Audio API when convenience is worth the
   API cost and privacy implications.
4. Use an agent to turn the transcript into a concise Markdown draft, preserving
   links and marking uncertain names or facts for review.
5. Preview locally and edit the draft before committing it.
6. Only after this habit proves useful, consider an inbox based on a GitHub
   issue or uploaded recording that creates a draft pull request automatically.

The automation must never publish an unreviewed transcript. Audio files should
not be committed by default, and the retention/privacy policy should be decided
before using a hosted transcription service.

**Exit criterion:** making a small update takes only a recording or rough notes,
one review pass, and a normal pull request.

## Phase 7: Perform the larger content review

- Rewrite the professional summary and current role.
- Update CV responsibilities and experience.
- Update courses, workshops, and presentations.
- Replace time-sensitive “latest” labels with dated entries that age cleanly.
- Review the generated publication list and decide how much detail belongs on
  the site versus external profiles.
- Review all external links and archive rather than silently delete historically
  useful material.

## Phase 8: Improve presentation and accessibility

- Replace the generic Jupyter Book logo after a portrait or personal mark has
  been created.
- Improve homepage hierarchy so current work, expertise, latest updates, GitHub,
  and LinkedIn are immediately visible.
- Add page metadata and social-sharing information.
- Review keyboard navigation, contrast, alt text, heading order, and mobile
  layout.
- Review analytics and privacy choices; retain analytics only if the information
  is actually useful.

## Phase 9: Automate deployment

- Add a separate deploy job only after local review and pull-request build checks
  are trusted.
- Configure GitHub Pages to use GitHub Actions.
- Build from the locked environment, upload only the generated static site as a
  Pages artifact, and deploy only after a successful build on the default
  branch.
- Use the protected `github-pages` environment and the minimum required workflow
  permissions.
- Verify the live site, important URLs, and rollback procedure before removing
  generated `_build` files from source control or retiring the old `gh-pages`
  process.
- Add dependency-update automation only after ordinary builds and deployments
  are stable, and require dependency updates to pass the same checks.

**Exit criterion:** production publishing is reproducible, generated output is
no longer stored on the source branch, and a failed build cannot replace the
working site.

## References

- [Jupyter Book 2 upgrade guide](https://jupyterbook.org/latest/resources/upgrade/)
- [Jupyter Book 2 installation guide](https://jupyterbook.org/stable/get-started/install/)
- [uv project and lockfile guide](https://docs.astral.sh/uv/guides/projects/)
- [GitHub Pages custom workflow documentation](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages)
- [Semantic Scholar Academic Graph API](https://api.semanticscholar.org/api-docs/)
- [ORCID API read-data tutorial](https://info.orcid.org/documentation/api-tutorials/api-tutorial-read-data-on-a-record/)
- [OpenAI speech-to-text guide](https://developers.openai.com/api/docs/guides/speech-to-text)

## Local Jupyter Book 2 preview

The preview script builds the migrated site from an isolated copy of the
current working tree, without creating `_build` output in the repository. Run
it from PowerShell in the repository root:

```powershell
.\scripts\preview.ps1
```

The script synchronizes the locked environment, performs a strict Jupyter Book
2 build in the Windows temporary directory, starts a local server, and opens
<http://127.0.0.1:8000/> in the default browser. Press `Ctrl+C` in PowerShell
to stop the server; the script then deletes the temporary copy.
Recreating the disposable Jupyter Book web theme can take a few minutes.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\preview.ps1
```

Use the second form only if the PowerShell execution policy prevents the direct
command from running. The script locates `uv` on `PATH` or in its default
per-user installation directory. To use another local port:

```powershell
.\scripts\preview.ps1 -Port 8080
```

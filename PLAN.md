# Personal website roadmap

## Purpose

The repository foundation has been modernized and merged into `master`. This
document now tracks the work that remains: safely publishing the Jupyter Book 2
site, then improving its content and adding carefully reviewed automation.

Changes should remain small, understandable, and reviewable. Automation may
prepare content or data, but it must not silently publish unreviewed material.

## Current baseline

As of September 24, 2026:

- Pull request #10 merged the Jupyter Book 2 migration into `master`.
- The source uses Jupyter Book 2.1.7, Python 3.12, `pyproject.toml`, and a
  committed `uv.lock`.
- Navigation and site configuration live in `myst.yml`.
- Generated `_build` output is ignored rather than committed.
- `scripts/check.ps1` performs a clean, locked, strict local build.
- `scripts/preview.ps1` builds in a temporary directory, opens the site
  locally, and removes the temporary site when stopped.
- `.github/workflows/validate.yml` performs the locked strict build on Linux
  for pull requests targeting `master` and uploads the HTML as an artifact.
- The first GitHub validation run passed for the migration pull request.
- The public website is still the previous Jupyter Book 1 output served from
  `gh-pages`. Merging the source migration did not deploy it.
- The `pre-jupyter-book-2` tag and the current `gh-pages` branch preserve
  rollback points.
- The old `_config.yml` and `_toc.yml` remain as hidden backup files until
  the new production site has been verified.

Setup, validation, and preview commands are documented in `README.md`.

## Completed foundation

- [x] Correct the most visible stale content, spelling problems, and malformed
      links.
- [x] Update the current professional roles without publishing a phone number.
- [x] Remove inactive podcast and Twitter/X cards while retaining LinkedIn and
      GitHub.
- [x] Remove unused tutorial pages and notebooks.
- [x] Preserve a pre-migration Git tag.
- [x] Introduce a repository-local, locked uv environment.
- [x] Migrate configuration and navigation to Jupyter Book 2.
- [x] Stop tracking generated build output.
- [x] Add disposable local validation and preview commands.
- [x] Validate the site on Windows and on a fresh GitHub-hosted Linux runner.
- [x] Merge the reviewed migration into `master` without changing production.

## Next milestone: release Jupyter Book 2 safely

### 1. Verify the merged baseline

- After restarting, run `.\scripts\check.ps1` from the repository root.
- Run `.\scripts\preview.ps1` and review the homepage, CV, courses, and
  publications pages.
- Check desktop and narrow/mobile layouts.
- Verify the important internal routes and the principal external profile
  links.
- Record any visual differences that need correction before production.

### 2. Add repository guardrails

- Protect `master` so normal changes arrive through pull requests.
- Require the `Strict Jupyter Book build` status check before merging.
- Do not require a second-person approval while this remains a single-maintainer
  repository.
- Add a deterministic internal-link check if it catches problems beyond the
  strict Jupyter Book build. Keep unreliable external-link checks separate.
- Delete the local and remote `website-modernization` branches only after the
  merged baseline has been rechecked.

### 3. Introduce production deployment separately

Create deployment as a separate reviewed change; do not add deployment
permissions to the validation workflow.

- Add a dedicated GitHub Pages workflow with minimum permissions.
- Build from `uv.lock` and upload only the generated static HTML as the Pages
  artifact.
- Use the protected `github-pages` environment for deployment.
- Begin with a manually triggered first deployment so the result can be checked
  deliberately.
- Configure GitHub Pages to use GitHub Actions only when the deployment workflow
  is ready.
- Verify the live homepage, `/cv/`, `/courses/`, `/publications/`,
  analytics, mobile layout, and important external links.
- Document how to restore the existing `gh-pages` version before retiring that
  publishing path.
- After the first release is accepted, enable deployment following successful
  changes to `master`.
- Remove the legacy configuration backups only after the production site has
  been stable and the rollback procedure is documented.

**Milestone exit criterion:** the Jupyter Book 2 site is live, important routes
are verified, deployment is reproducible, and a failed build cannot replace the
working site.

## Later workstreams

Each workstream should use its own short-lived branch and pull request after the
production migration is stable.

### Content review

- Rewrite the professional summary around the current Head of Unit roles and
  SSF Research Infrastructure Fellow status.
- Review CV responsibilities, experience dates, courses, workshops, and
  presentations.
- Replace undated or time-sensitive �w^~)�tlatesv��y��y� language with dated entries.
- Review professional-network memberships.
- Review external links and archive historically useful material rather than
  silently deleting it.

### Publications and citation metrics

Treat publication identity and citation metrics as separate concerns:

- Use an ORCID iD, curated DOI list, or maintained BibTeX file as the source of
  publication identity.
- Compare Semantic Scholar and OpenAlex coverage using pinned author IDs; do not
  rely on a name search during every build.
- Keep API retrieval separate from site rendering. Retrieval should write a
  small deterministic data file so an API outage cannot break the website.
- Display the provider and last-updated date because citation totals differ
  between databases.
- Retain manual overrides and last-known-good data.

Before automation, add fixture-based parsing tests, schema and missing-field
tests, DOI/author identity checks, duplicate detection, and sanity checks for
implausible metric changes. Run a live comparison manually before scheduling
updates.

Only after the pipeline is trusted should a monthly workflow open a reviewable
pull request. It must never publish changed metrics directly.

### News and articles

- Define a concise article format containing title, date, summary, body, tags,
  and optional source links.
- Add an `articles/` section and derive the homepage's latest updates from
  article metadata.
- Start with manually written Markdown and the normal preview/PR workflow.
- Later, prototype a local draft command that accepts notes or audio and creates
  a draft for human editing.
- Decide audio retention, privacy, and transcription-provider policy before
  using any hosted transcription service.
- Never publish an automatically generated transcript or article without human
  review.

### Presentation and accessibility

- Replace the generic Jupyter Book logo with a portrait or personal mark.
- Improve homepage hierarchy around current work, expertise, updates, GitHub,
  and LinkedIn.
- Add page metadata and social-sharing information.
- Review keyboard navigation, contrast, alternative text, heading order, and
  mobile layout.
- Retain analytics only if the information is useful and the privacy tradeoff is
  acceptable.

### Maintenance

- Add dependency-update automation only after builds and deployments are stable.
- Require dependency updates to pass the same pull-request checks.
- Periodically test the documented setup from a fresh clone.
- Keep generated output, local environments, caches, and secrets out of Git.

## Normal change workflow

For future work:

1. Update local `master` from `origin/master`.
2. Create a short-lived branch for one coherent change.
3. Edit and preview locally.
4. Run `.\scripts\check.ps1`.
5. Commit and push the branch.
6. Open a pull request into `master`.
7. Review the diff, logs, and optional HTML artifact.
8. Merge only after the required check passes.
9. Delete the feature branch after confirming the merge.

Validation and deployment remain separate. A pull-request artifact is for
inspection; it is not the live website.

## References

- [Jupyter Book 2 documentation](https://jupyterbook.org/)
- [uv project and lockfile guide](https://docs.astral.sh/uv/guides/projects/)
- [Using uv in GitHub Actions](https://docs.astral.sh/uv/guides/integration/github/)
- [GitHub pull request documentation](https://docs.github.com/en/pull-requests)
- [GitHub Pages custom workflows](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages)
- [Semantic Scholar Academic Graph API](https://api.semanticscholar.org/api-docs/)
- [OpenAlex API documentation](https://docs.openalex.org/)
- [ORCID public API documentation](https://info.orcid.org/documentation/integration-guide/working-with-public-api/)

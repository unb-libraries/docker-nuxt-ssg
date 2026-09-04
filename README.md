# unb-libraries/docker-nuxt-ssg [![GitHub license](https://img.shields.io/github/license/unb-libraries/docker-nuxt-ssg)](LICENSE)

The base image for prerendered Nuxt sites (`nuxt generate`) at UNB Libraries. It extends
[unb-libraries/docker-nginx](https://github.com/unb-libraries/docker-nginx) with an nginx
configuration suited to a statically generated site.

## Usage

Copy the generated site into `$APP_WEBROOT` from a throw-away build stage:

```dockerfile
FROM node:26-alpine AS build
# ... pnpm install && pnpm run generate ...

FROM ghcr.io/unb-libraries/nuxt-ssg:3.23.x
COPY --from=build /nuxt/.output/public/ ${APP_WEBROOT}/
```

Copy *into* `$APP_WEBROOT` rather than over it, so the parent image's `.well-known/` survives.

## What it changes from the parent

- `try_files $uri $uri.html $uri/index.html =404` — `nuxt generate` emits `/route/index.html`
  and `/route.html`. The parent falls back to `/index.html`, which would answer every dead
  link with the home page and a 200.
- `error_page 404 /404.html` — add `/404.html` to `nitro.prerender.routes` so the file exists.
- **`location = /health`** — the liveness and readiness target for the
  `unblib-daemon-nuxt-ssg` Helm chart, deliberately independent of `try_files`. Without it
  every pod is killed by the liveness probe.
- gzip, and an immutable long-cache for fingerprinted assets. HTML is `no-cache` so a browser
  cannot hold a page referencing `/_nuxt/` hashes a later deploy has purged.

`robots.txt` is handled by the parent's `ROBOTS_TXT_APPEND` / `ROBOTS_TXT_REPLACE`, which the
Helm chart sets.

## Branches/Tags

Tagged by Alpine version, matching the rest of the family.

| Tag | Nginx | Alpine |
|:---:|-------|--------|
| `ghcr.io/unb-libraries/nuxt-ssg:3.23.x` | 1.28 | 3.23 |

## Author / Contributors

This image was created at [UNB Libraries](https://lib.unb.ca).

## License

- As part of our 'open' ethos, UNB Libraries licenses its applications and workflows to be
  freely available to all whenever possible.
- Consequently, the contents of this repository [unb-libraries/docker-nuxt-ssg] are licensed
  under the [MIT License](http://opensource.org/licenses/mit-license.html).

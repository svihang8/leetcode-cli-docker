# leetcode-cli (Docker)

Runs [leetcode-cli](https://github.com/clearloop/leetcode-cli) in a container so
you do not need Rust or Cargo on the Mac.

## Build

```sh
docker build -t leetcode-cli .
```

The first build compiles the crate and takes several minutes. Later rebuilds
are only needed if you change this Dockerfile.

## Wrappers

`bin/leetcode` and `bin/leetcode-clean` live in this repo. They locate the
project via their own path (no hardcoded home directory). If the `leetcode-cli`
image is missing, `bin/leetcode` builds it from this Dockerfile.

Dotfiles put `bin/` on `$PATH` when the directory exists, so you can run:

```sh
leetcode pick 1
leetcode edit 1    # writes a Python file, then opens it in Cursor
leetcode test 1
leetcode-clean     # delete generated files under .leetcode/code/
```

Override the image name with `LEETCODE_CLI_IMAGE` (default `leetcode-cli`).

## Data on the host

This directory's `.leetcode/` is bind-mounted to `/root/.leetcode` in the
container. Cache and generated solutions are gitignored; `leetcode.toml` is
committed:

- `.leetcode/leetcode.toml` — CLI config (`lang` is `python3`; `site` is `leetcode.com`; `editor` is `true` so the container does not open vim). Leave `csrf` and `session` empty.
- `.leetcode/code/` — generated solution files (`leetcode edit` opens these in Cursor)
- `.env` — cookies only (gitignored). Copy `.env.example` and fill in `LEETCODE_CSRF` and `LEETCODE_SESSION`.

## Cookies

Chrome cookie auto-read does not work inside Docker. Log in at
[leetcode.com](https://leetcode.com), copy `csrftoken` and `LEETCODE_SESSION`
from DevTools cookies, and put them in `.env`:

```
LEETCODE_CSRF=<csrftoken>
LEETCODE_SESSION=<LEETCODE_SESSION>
```

`site` stays in `.leetcode/leetcode.toml`. The wrapper passes `.env` into the container with `docker run --env-file`.

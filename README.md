# walg-docker
A Dockerfile for [WAL-G](https://github.com/wal-g/wal-g) and Postgres each bundled with Google's Brotli.

- Build for WAL-G and Postgres
- Use alpine as build and runtime image
- Enable Brotli (It's 3x better compression than gzip)
- Use the latest version of WAL-G (v3.0.3) as of 20250107

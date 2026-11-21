# ohtu_miniprojekti

Ohjelmistotuotantokurssin miniprojekti, Paras_ohturyhmä

The app is running at https://route-ohjelmistotuotanto-lahiopetus-2026-4.ext.okd-cs-test-0.k8s.cs.helsinki.fi.

[![CI](https://github.com/eki-77/ohtu_miniprojekti/actions/workflows/main.yml/badge.svg)](https://github.com/eki-77/ohtu_miniprojekti/actions/workflows/main.yml)
[![Build and push Docker image](https://github.com/eki-77/ohtu_miniprojekti/actions/workflows/docker.yaml/badge.svg)](https://github.com/eki-77/ohtu_miniprojekti/actions/workflows/docker.yaml)

## Usage

First create the database. Note that this destroys any existing data.

```bash
uv run python src/db_helper.py
```

Now run the app with

```bash
uv run python src/index.py
```

## Definition Of Done

- Code is readable and managable.

- The application runs online on the OKD klusteri.

- Tests have been made to evaluate new features; tests are passing.

## Backlogs

- [Product and sprint backlogs](https://github.com/users/eki-77/projects/1/views/1)

## Other

- [Ryhmän pelisäännöt](https://github.com/eki-77/ohtu_miniprojekti/blob/main/pelisaannot.md)


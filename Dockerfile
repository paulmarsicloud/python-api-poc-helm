# Adapted from principles in https://medium.com/@albertazzir/blazing-fast-python-docker-builds-with-poetry-a78a66f5aed0
# Installs deps before copying codebase and clears poetry cache on docker build

FROM python:3.11-buster as builder

RUN pip install poetry==2.1.1

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

COPY pyproject.toml poetry.lock definitions.jsonl ./

RUN poetry install --without dev --no-root && rm -rf $POETRY_CACHE_DIR

FROM python:3.11-slim-buster as runtime

ENV VIRTUAL_ENV=/app/.venv \
    PATH="/app/.venv/bin:$PATH"

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}

COPY src ./src
COPY definitions.jsonl ./definitions.jsonl

ENTRYPOINT ["python", "-m", "src.api"]
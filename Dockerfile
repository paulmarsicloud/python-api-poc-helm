# Adapted from principles in https://medium.com/@albertazzir/blazing-fast-python-docker-builds-with-poetry-a78a66f5aed0
# Installs deps before copying codebase and clears poetry cache on docker build

FROM python:3.11-buster

RUN pip install poetry==1.4.2

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

COPY pyproject.toml poetry.lock definitions.jsonl ./

RUN poetry install --without dev --no-root && rm -rf $POETRY_CACHE_DIR

COPY src ./src

RUN poetry install --without dev

ENTRYPOINT ["poetry", "run", "python", "-m", "src.api"]
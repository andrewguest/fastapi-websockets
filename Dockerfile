FROM python:3.11-slim


# Create a non-root user to run the app as
RUN addgroup --system app && adduser --system --group app

# Environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYTHONPATH=${PYTHONPATH}:${PWD}

# Make a directory for the project
RUN mkdir /app

# Change to the `/app` directory
WORKDIR /app

# Copy the project files over to the container
COPY pyproject.toml /app
COPY . /app

# Chown all the files to the app user
RUN chown -R app:app /app

# Install Poetry
RUN pip3 install poetry

# Export the Poetry pack list to another format
RUN poetry export -f requirements.txt >> requirements.txt

# Set Poetry to NOT install the dependencies into a virtual environment, instead install them into the system's Python environment
RUN poetry config virtualenvs.create false

# Install the Python dependencies
RUN poetry install --only main

# Become the `app` user
USER app

# Expose port 8001 on the container
EXPOSE 8001

CMD ["poetry", "run", "gunicorn"]

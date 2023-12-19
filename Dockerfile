FROM python:3.11.6 AS build
RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes libsasl2-dev libldap2-dev libssl-dev python3-venv && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


FROM build AS build-venv
COPY api/requirements.txt /requirements.txt
RUN /venv/bin/pip install --no-cache-dir --disable-pip-version-check -r /requirements.txt

FROM python:3.11.6-slim
RUN mkdir /app
WORKDIR /app
COPY --from=build-venv /venv /venv
COPY api/. .
RUN apt-get update && \
    apt-get --yes install libldap2-dev libsasl2-dev libpq5 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV PATH="/venv/bin:$PATH"

CMD gunicorn main:app --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind=0.0.0.0:3000 --timeout 120
FROM python:3.12.0b2-alpine3.18 as base
ENV VIRTUAL_ENV=/opt/venv
RUN python3.11 -m venv $VIRTUAL_ENV
WORKDIR /pytemplate
ENV PATH="$VIRTUAL_ENV/bin:$PATH" TZ=Asia/Kolkata PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
COPY . .
RUN apk update && apk upgrade --available && sync
RUN apk add --no-cache --virtual .build-deps gcc musl-dev build-base linux-headers python3-dev && python3.11 -m pip install -U pip && pip3 install --no-cache-dir -U setuptools wheel && pip3 install --no-cache-dir -U -r requirements.txt && rm -rf && apk --purge del .build-deps
RUN python3.11 -m compileall -b -o 2 . && rm -rf main.py requirements.txt
ENTRYPOINT ["python3.11", "main.pyc"]

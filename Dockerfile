FROM python:3.12.0-alpine3.18
ENV VIRTUAL_ENV=/opt/venv
RUN python3.12 -m venv $VIRTUAL_ENV
WORKDIR /pytemplate
ENV PATH="$VIRTUAL_ENV/bin:$PATH" TZ=Asia/Kolkata PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
COPY requirements.txt .
RUN apk update && apk upgrade --available && sync
RUN apk add --no-cache --virtual .build-deps gcc musl-dev build-base linux-headers python3-dev && python3.12 -m pip install -U pip && pip3 install --no-cache-dir -U setuptools wheel && pip3 install --no-cache-dir -U -r requirements.txt && apk --purge del .build-deps
COPY . .
RUN python3.12 -m compileall -b -o 2 . && rm -rf main.py requirements.txt
ENTRYPOINT ["python3.12", "main.pyc"]

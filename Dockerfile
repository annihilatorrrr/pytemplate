FROM python:3.12.4-alpine3.19
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
WORKDIR /pytemplate
ENV PATH="$VIRTUAL_ENV/bin:$PATH" TZ=Asia/Kolkata PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
COPY . .
RUN apk update && apk upgrade --available && sync && apk add --no-cache git && apk add --no-cache --virtual .build-deps gcc musl-dev build-base linux-headers python3-dev && python3 -m pip install -U pip && pip3 install --no-cache-dir -U setuptools wheel && pip3 install --no-cache-dir -U -r requirements.txt && apk --purge del .build-deps && python3 -m compileall -b -o 2 . && rm -rf main.py requirements.txt /var/cache/apk/* && apk del git
ENTRYPOINT ["python3", "main.pyc"]

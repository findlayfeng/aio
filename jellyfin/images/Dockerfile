FROM jellyfin/jellyfin as mdc-builder

ARG MDC_SOURCE_VERSION=6.6.7
ARG MDC_SOURCE_FILE=${MDC_SOURCE_VERSION}.tar.gz
ARG MDC_SOURCE=https://github.com/yoshiko2/Movie_Data_Capture/archive/refs/tags/${MDC_SOURCE_FILE}

ADD ${MDC_SOURCE} /tmp/
RUN mkdir -p /tmp/mdc
RUN tar -C /tmp/mdc --strip-components 1 -axf /tmp/${MDC_SOURCE_FILE}

RUN sed -e 's|deb\.debian\.org|mirrors.ustc.edu.cn|g' \
    -e 's|security\.debian\.org|mirrors.ustc.edu.cn|g' \
    -i.bak \
    $([ -e "/etc/apt/sources.list.d/debian.sources" ] && \
    echo -n /etc/apt/sources.list.d/debian.sources || \
    echo -n /etc/apt/sources.list)

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    binutils python3 python3-venv python3-dev pip

RUN pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple

WORKDIR /tmp/mdc

RUN python3 -m venv venv
RUN . venv/bin/activate \
    && pip install --upgrade pip pyinstaller \
    && pip install -r requirements.txt \
    && pip install face_recognition --no-deps
RUN . venv/bin/activate && \
    pyinstaller \
      -D Movie_Data_Capture.py \
      --python-option u \
      --hidden-import "ImageProcessing.cnn" \
      --add-data "$(python -c 'import cloudscraper as _; print(_.__path__[0])' | tail -n 1):cloudscraper" \
      --add-data "$(python -c 'import opencc as _; print(_.__path__[0])' | tail -n 1):opencc" \
      --add-data "$(python -c 'import face_recognition_models as _; print(_.__path__[0])' | tail -n 1):face_recognition_models" \
      --add-data "Img:Img" \
      --add-data "scrapinglib:scrapinglib"
RUN install /tmp/mdc/config.ini /tmp/mdc/dist/Movie_Data_Capture/config.template

FROM jellyfin/jellyfin

RUN sed -e 's|deb\.debian\.org|mirrors.ustc.edu.cn|g' \
        -e 's|security\.debian\.org|mirrors.ustc.edu.cn|g' \
      -i.bak \
      $([ -e "/etc/apt/sources.list.d/debian.sources" ] && \
        echo -n /etc/apt/sources.list.d/debian.sources || \
        echo -n /etc/apt/sources.list)

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        fonts-noto-cjk-extra \
    ; \
    rm -rf /var/lib/apt/lists/*

COPY --from=mdc-builder /tmp/mdc/dist/Movie_Data_Capture /usr/local/share/mdc
ADD mdc /usr/local/bin/

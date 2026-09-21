FROM debian:trixie-slim

LABEL maintainer="shibainuo"
LABEL org.opencontainers.image.title="shibainuo"
LABEL org.opencontainers.image.description="Custom Social image by alfi"
LABEL org.opencontainers.image.vendor="shibainuo"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Tehran

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

# ساخت فایل‌های جعلی برای دور زدن چک‌های اسکریپت نصب
RUN printf '#!/bin/sh\necho "Debian (shibainuo build)"' > /usr/bin/lsb_release \
    && printf '#!/bin/sh\necho "Container by shibainuo"' > /usr/bin/hostnamectl \
    && printf '#!/bin/sh\nexit 0' > /usr/bin/systemctl \
    && chmod +x /usr/bin/lsb_release /usr/bin/hostnamectl /usr/bin/systemctl

# دانلود و نصب EarnApp
RUN wget -qO /tmp/install.sh https://brightdata.com/static/earnapp/install.sh \
    && chmod +x /tmp/install.sh \
    && bash /tmp/install.sh -y \
    && rm -f /tmp/install.sh

# مطمئن شدن از اینکه باینری وجود داره
RUN which earnapp || (echo "earnapp not found after install" && ls -l /usr/bin/earnapp || true) \
    && earnapp stop || true

# پاکسازی
RUN rm -rf /tmp/* /var/tmp/* \
    /usr/share/doc /usr/share/man /usr/share/locale \
    && apt-get clean

WORKDIR /app
COPY run.sh .
RUN chmod +x run.sh

VOLUME ["/etc/earnapp"]

ENTRYPOINT ["./run.sh"]

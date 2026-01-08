FROM golang:1.23-bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates git rsync bash && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /repo
COPY . /repo

RUN chmod +x /repo/dotman/dotman /repo/dotman/e2e/run_inside.sh
CMD ["/repo/dotman/e2e/run_inside.sh"]

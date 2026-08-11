FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        openssh-client \
        gnupg \
        make \
        build-essential \
        yamllint \
        jq \
        tmux \
        ncurses-term \
        locales \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Generate a UTF-8 locale so forwarded/host LANG values render cleanly. C.UTF-8
# is always present; en_US.UTF-8 covers the common case. The tmux client is
# additionally launched with `-u`, so UTF-8 rendering is correct even when a
# host's exact locale is not generated here.
RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

# Terminal defaults. LANG (not LC_ALL) is set so a forwarded host LANG still
# wins at attach time. TERM is a sane fallback for non-tmux exec contexts.
ENV LANG=C.UTF-8
ENV TERM=xterm-256color

# tmux config, read automatically when the server starts.
COPY docker/tmux.conf /etc/tmux.conf

# Docker CLI (client only) so the agent can drive the host daemon over the
# mounted socket when forge-fleet runs with --docker-host-bind / DOCKER_HOST_BIND.
ARG DOCKER_CLI_VERSION=27.5.1
RUN curl -fsSL "https://download.docker.com/linux/static/stable/$(uname -m)/docker-${DOCKER_CLI_VERSION}.tgz" \
        -o /tmp/docker.tgz \
    && tar -xzf /tmp/docker.tgz -C /tmp \
    && install -m 0755 /tmp/docker/docker /usr/local/bin/docker \
    && rm -rf /tmp/docker /tmp/docker.tgz

# GitHub CLI from GitHub's official apt repo — bookworm's packaged gh is far
# behind upstream. The stable channel here tracks the latest release.
RUN install -d -m 0755 /etc/apt/keyrings \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        -o /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# Node from NodeSource — bookworm's packaged Node 18 is EOL and below the
# minimum for current frontend tooling. corepack is enabled so pnpm/yarn
# resolve per-repo from the packageManager field.
ARG NODE_MAJOR=22
RUN install -d -m 0755 /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
        | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
        > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && corepack enable

RUN groupadd --gid 1000 buddy \
    && useradd --uid 1000 --gid buddy --create-home buddy \
    && mkdir -p /workspace /logs \
    && chown buddy:buddy /workspace /logs

USER buddy
ENV HOME="/home/buddy"
ENV NPM_CONFIG_PREFIX="/home/buddy/.local"
ENV PATH="/home/buddy/.local/bin:${PATH}"

RUN npm install -g @anthropic-ai/claude-code
RUN npm install -g @openai/codex
RUN curl -Ls https://astral.sh/uv/install.sh | sh

WORKDIR /workspace

CMD ["sleep", "infinity"]

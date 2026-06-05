# =============================================================================
# docker/Dockerfile — Test image for dotfiles installation validation
#
# Base image: debian:trixie-slim (Debian 13)
# Purpose: verify that 'make install' completes successfully on a clean system
#          and that all required tools are present and functional.
#
# Build: make docker-build
# Test:  make docker-test
# =============================================================================

FROM debian:trixie-slim

# ---------------------------------------------------------------------------
# Build arguments
# ---------------------------------------------------------------------------
ARG USERNAME=testuser
ARG UID=1000

# ---------------------------------------------------------------------------
# System prerequisites (needed before make install can run)
# ---------------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo \
        git \
        make \
        curl \
        ca-certificates \
        bats \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# Create unprivileged test user with passwordless sudo
# ---------------------------------------------------------------------------
RUN useradd -m -u "${UID}" -s /bin/bash "${USERNAME}" \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/"${USERNAME}" \
    && chmod 0440 /etc/sudoers.d/"${USERNAME}"

# ---------------------------------------------------------------------------
# Copy the dotfiles repository
# ---------------------------------------------------------------------------
WORKDIR /home/${USERNAME}
COPY --chown=${USERNAME}:${USERNAME} . /home/${USERNAME}/dotfiles/

# ---------------------------------------------------------------------------
# Switch to the test user and run the full installation
# ---------------------------------------------------------------------------
USER ${USERNAME}
WORKDIR /home/${USERNAME}/dotfiles

# Skip Docker CE and GUI packages — not needed in the test container:
#   SKIP_DOCKER=1 avoids Docker-in-Docker which fails in build environments
#   SKIP_GUI=1    avoids alacritty and icon theme (headless container)
ENV SKIP_DOCKER=1
ENV SKIP_GUI=1

# Ensure user-installed binaries (starship, lazygit, lazydocker, zellij, etc.)
# under ~/.local/bin are on PATH for all shells, including the
# non-interactive/non-login shells used by docker-compose to run the tests.
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

# Install everything (submodules are already in the repo copy)
RUN make install

# ---------------------------------------------------------------------------
# Default command — run smoke tests then start bash
# ---------------------------------------------------------------------------
SHELL ["/bin/bash", "-c"]
CMD ["bash tests/smoke/smoke.sh && exec bash"]

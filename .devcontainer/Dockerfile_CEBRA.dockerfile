# syntax=docker/dockerfile:1

# CUDA 12.1 + cuDNN 8 on Ubuntu 22.04
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# ---------- System deps (plus headless Chrome prereqs) ----------
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential curl ca-certificates gnupg tini \
    # X/GL bits many Python viz libs need
    libglib2.0-0 libsm6 libxext6 libxrender1 libgl1 libx11-xcb1 libxshmfence1 \
    # Chrome runtime deps
    fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 \
    libcups2 libdrm2 libgbm1 libgtk-3-0 libnspr4 libnss3 libxkbcommon0 \
    libxdamage1 libxfixes3 xdg-utils libu2f-udev \
    python3-pip python3-venv \
    libblas3 liblapack3 libopenblas0-pthread libgfortran5 \
 && rm -rf /var/lib/apt/lists/*

# Up-to-date pip
RUN python3 -m pip install --no-cache-dir --upgrade pip

# ---------- Install Google Chrome (stable) ----------
# (Avoids Snap-based chromium on 22.04 which doesn't work well in containers.)
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-linux.gpg \
 && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends google-chrome-stable \
 && rm -rf /var/lib/apt/lists/*

# Optional (nice to have): basic fonts for plots
RUN apt-get update && apt-get install -y --no-install-recommends fonts-dejavu-core && rm -rf /var/lib/apt/lists/*

# ---------- Non-root user ----------
ARG USERNAME=appuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
 && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
USER $USERNAME

WORKDIR /workspace

# ---- PyTorch cu121 wheels (match CUDA 12.1 base) ----
RUN pip install --no-cache-dir \
  torch==2.4.0+cu121 torchvision==0.19.0+cu121 torchaudio==2.4.0+cu121 \
  --index-url https://download.pytorch.org/whl/cu121

# ---- Your Python deps (includes kaleido + plotly) ----
RUN pip install --no-cache-dir \
    jupyterlab ipywidgets \
    pandas numpy scipy scikit-learn matplotlib tqdm h5py umap-learn xgboost pingouin\
    plotly kaleido colorcet hmmlearn imbalanced-learn statsmodels\
    "cebra[datasets,integrations]==0.6.0a1" \
    wandb nibabel nilearn SUITPy

# Helpful envs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility

EXPOSE 8888

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash", "-lc", "jupyter lab --ip=0.0.0.0 --no-browser --NotebookApp.allow_origin='*' --ServerApp.disable_check_xsrf=True"]





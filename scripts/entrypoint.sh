#!/bin/bash

set -e

# Install ComfyUI
cd /home/runner
if [ ! -f "/home/runner/.download-complete" ] ; then
    chmod +x /home/scripts/download.sh
    bash /home/scripts/download.sh
fi ;

# Oneflow
cd /home/runner/ComfyUI
printf "Cloning onediff repository...\n"
git clone https://github.com/siliconflow/onediff.git --recursive
printf "Installing onediff package...\n"
cd onediff && pip install -e .

printf "Copying onediff_comfy_nodes to ComfyUI/custom_nodes...\n"
cd /home/runner/ComfyUI/onediff
cp -r onediff_comfy_nodes /home/runner/ComfyUI/custom_nodes

# Run user's pre-start script
cd /home/runner
if [ -f "/home/runner/scripts/pre-start.sh" ] ; then
    echo "########################################"
    echo "Running pre-start script..."
    echo "########################################"

    chmod +x /home/runner/scripts/pre-start.sh
    source /home/runner/scripts/pre-start.sh
else
    echo "No pre-start script found. Skipping."
fi ;


echo "########################################"
echo "Starting ComfyUI..."
echo "########################################"

export PATH="${PATH}:/home/runner/.local/bin"

cd /home/runner

python3 ./ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}

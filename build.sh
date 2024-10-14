#!/bin/bash

# Log the current step
echo "Installing Git LFS..."

# Install Git LFS
apt-get update && apt-get install -y git-lfs

# Log the current step
echo "Initializing Git LFS..."

# Initialize Git LFS
git lfs install

# Log the current step
echo "Pulling LFS files..."

# Pull LFS files
git lfs pull

# Check if LFS files were pulled
echo "Listing LFS files..."
ls -lh path/to/images # Adjust path to your images

# Continue with your normal build process
echo "Building the site..."
npm run build

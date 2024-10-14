# Install Git LFS
apt-get update && apt-get install -y git-lfs

# Initialize Git LFS
git lfs install

# Pull the LFS files
git lfs pull

# Continue with your normal build process (adjust based on your build tool)
npm run build
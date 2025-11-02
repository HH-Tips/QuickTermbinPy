#!/bin/bash

available_versions() {
    curl -s https://api.github.com/repos/HH-Tips/QuickTermbinPy/releases | grep '"tag_name"' | cut -d '"' -f 4
}

download() {
    TMP_ZIP="/tmp/QuickTermbinPy.zip"
    mkdir $INSTALLATION_FOLDER
    wget $URL -O $TMP_ZIP
    unzip $TMP_ZIP -d /tmp
    mv "/tmp/QuickTermbinPy-${VERSION}" $INSTALLATION_FOLDER
}

create_launcher() {
    # Usiamo /usr/local/bin, che è lo standard per software installato manualmente
    LAUNCHER_PATH="/usr/local/bin/qtb"
    
    echo "Creating launcher at $LAUNCHER_PATH..."
    
    # Usiamo 'tee' per scrivere il file come root, è più sicuro
    # Il "here document" (<<EOF) rende più pulita la scrittura di file multi-riga
    tee "$LAUNCHER_PATH" > /dev/null <<EOF
#!/bin/bash
# Launcher for QuickTermbin

# Esegue il JAR e passa tutti gli argomenti (\$@)
python3 "$INSTALLATION_FOLDER/quick-termbin.py" "\$@"
EOF

    # Rendiamo il launcher eseguibile per tutti gli utenti
    chmod 755 "$LAUNCHER_PATH"
}

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this installer with sudo or as root."
  exit 1
fi

# Installation folder
INSTALLATION_FOLDER="/opt/quick-termbin"

# A variable to store the version number
VERSION=""

# Process command-line arguments
while getopts "v:" opt; do
  case $opt in
    v)
      VERSION=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: $0 -v <version>"
      exit 1
      ;;
  esac
done

# Check if the version was provided
if [ -z "$VERSION" ]; then
    VERSION=$(available_versions | tail -n 1)
    read -r -d '' VERSION <<< "${VERSION:1}"
fi

# Validate the version format (n.n.n)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Version format must be 'n.n.n' (e.g., '1.0.0')."
  exit 1
fi

# Build the download URL
URL="https://github.com/HH-Tips/QuickTermbinPy/archive/refs/tags/v${VERSION}.zip"

echo "Checking for version ${VERSION}..."

# Use wget to check if the URL exists.
# --spider: doesn't download the file, just checks for its existence.
# -q: quiet mode to suppress output.
# The 'if !' condition checks for a non-zero exit code (like a 404 Not Found error).
if ! wget --spider -q "${URL}"; then
  echo "Error: Version ${VERSION} is not available."
  echo -e "\nThese are the available versions:"
  echo -e "\t"$(available_versions)
  exit 1
else
  echo "Version ${VERSION} found. Proceeding with the installation..."
  download
fi

create_launcher

echo "Installer finished."
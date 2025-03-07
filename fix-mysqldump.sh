#!/bin/bash

# Define the paths
MYSQLDUMP_ORIGINAL="/usr/bin/mysqldump.original"
MYSQLDUMP_WRAPPER="/usr/bin/mysqldump"

# Function to install the wrapper
install_wrapper() {
  echo "Creating the wrapper script..."
  sudo bash -c "cat > $MYSQLDUMP_WRAPPER" << 'EOF'
#!/bin/bash

# Replace --ssl with --ssl-mode=REQUIRED in the arguments
args=("$@")
for i in "${!args[@]}"; do
  if [[ "${args[i]}" == "--ssl" ]]; then
    args[i]="--ssl-mode=REQUIRED"
  fi
done

# Call the original mysqldump with the modified arguments
/usr/bin/mysqldump.original "${args[@]}"
EOF

  # Make the wrapper script executable
  echo "Setting executable permissions for the wrapper script..."
  sudo chmod +x "$MYSQLDUMP_WRAPPER"
}

# Check if the current mysqldump is already the wrapper
if grep -q "mysqldump.original" "$MYSQLDUMP_WRAPPER" 2>/dev/null; then
  echo "mysqldump is already wrapped. No action needed."
  exit 0
else
  # Copy the current mysqldump to mysqldump.original, overwriting if it exists
  echo "Copying current mysqldump to mysqldump.original (overwriting if exists)..."
  sudo cp -f "$MYSQLDUMP_WRAPPER" "$MYSQLDUMP_ORIGINAL"
  
  # Install the wrapper
  install_wrapper
fi

echo "mysqldump has been successfully wrapped to handle --ssl parameter."

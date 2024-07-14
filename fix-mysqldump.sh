#!/bin/bash

# Define the paths
MYSQLDUMP_ORIGINAL="/usr/bin/mysqldump.original"
MYSQLDUMP_WRAPPER="/usr/bin/mysqldump"

# Check if mysqldump.original already exists
if [ -f "$MYSQLDUMP_ORIGINAL" ]; then
  echo "mysqldump.original already exists. Aborting."
  exit 1
fi

# Move the original mysqldump to mysqldump.original
echo "Moving original mysqldump to mysqldump.original..."
sudo mv /usr/bin/mysqldump /usr/bin/mysqldump.original

# Create the wrapper script
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
sudo chmod +x /usr/bin/mysqldump

echo "mysqldump has been successfully wrapped to handle --ssl parameter."

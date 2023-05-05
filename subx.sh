#!/usr/bin/env bash

# Function to display usage information
usage() {
  echo "Usage: subx [OPTIONS] [INPUT_FILES...]"
  echo
  echo "Parse files containing URLs separated by newlines, extract subdomains,"
  echo "and output a list of unique subdomains along with the domain and TLD."
  echo
  echo "Options:"
  echo "  -o, --output FILE   Write unique subdomains to the specified output FILE."
  echo "                      If not specified, write to STDOUT."
  echo "  -q, --quiet         Suppress non-essential output."
  echo "  -v, --verbose       Display additional information about script operation."
  echo "  -h, --help          Display this help message and exit."
  echo
  echo "Examples:"
  echo "  # Read URLs from input.txt and output unique subdomains to the terminal"
  echo "  subx -i input.txt"
  echo
  echo "  # Read URLs from input.txt and output unique subdomains to subdomains.txt"
  echo "  subx -i input.txt -o subdomains.txt"
  echo
  echo "  # Read URLs from multiple input files and output unique subdomains to the terminal"
  echo "  subx -i input1.txt input2.txt"
  echo
  echo "  # Read URLs from STDIN and output unique subdomains to the terminal"
  echo "  cat input.txt | subx"
  echo
  exit 1
}

# Function to extract subdomains along with the domain and TLD from URLs
extract_subdomains() {
  grep -oP '^(?:https?:\/\/)?(?:www\.)?\K[^/]*' "$1" | sort -u
}

# Initialize variables
quiet=false
verbose=false

# Parse command-line options
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -o|--output)
      if [[ "$#" -gt 1 ]]; then
        output_file="$2"
        shift
      else
        echo "Error: Missing argument for $1"
        usage
      fi
      ;;
    -q|--quiet)
      quiet=true
      ;;
    -v|--verbose)
      verbose=true
      ;;
    -h|--help)
      usage
      ;;
    *)
      # Assume any other arguments are input files
      input_files+=("$1")
      ;;
  esac
  shift
done

# If no input files are specified, use STDIN
if [[ ${#input_files[@]} -eq 0 ]]; then
  input_files=("/dev/stdin")
fi

# Check if output file exists and prompt for confirmation
if [[ -n "$output_file" && -e "$output_file" && "$quiet" = false ]]; then
  read -p "Output file '$output_file' already exists. Overwrite? [y/N] " confirm
  if [[ "${confirm,,}" != "y" ]]; then
    echo "Aborted."
    exit 1
  fi
fi

# Initialize associative array for unique subdomains
declare -A unique_subdomains

# Process each input file
for input_file in "${input_files[@]}"; do
  # Validate input file
  if [[ "$input_file" != "/dev/stdin" && ! -r "$input_file" ]]; then
    echo "Error: Input file '$input_file' does not exist or is not readable."
    exit 1
  fi

  # Extract subdomains from the current input file and add them to the associative array
  while IFS= read -r subdomain; do
    unique_subdomains["$subdomain"]=1
  done < <(extract_subdomains "$input_file")
done

# Output the unique subdomains to the specified file or to STDOUT
if [[ -z "$output_file" ]]; then
  for subdomain in "${!unique_subdomains[@]}"; do
    echo "$subdomain"
  done
else
  # Empty or create the output file
  : > "$output_file"
  for subdomain in "${!unique_subdomains[@]}"; do
    echo "$subdomain" >> "$output_file"
  done
fi

# Display verbose information if the verbose mode is enabled
if [[ "$verbose" = true ]]; then
  echo "Processed ${#input_files[@]} input file(s)"
  echo "Extracted ${#unique_subdomains[@]} unique subdomain(s)"
fi

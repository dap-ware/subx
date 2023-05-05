# Subdomain Extractor (subx)

`subx` is a simple command-line tool that extracts unique subdomains from a list of URLs. The input URLs can be provided in a file or via standard input (STDIN). The extracted subdomains can be displayed on the terminal or written to an output file.

## Usage

```
Usage: subx [OPTIONS] [INPUT_FILES...]

Parse files containing URLs separated by newlines, extract subdomains,
and output a list of unique subdomains along with the domain and TLD.

Options:
  -o, --output FILE   Write unique subdomains to the specified output FILE.
                      If not specified, write to STDOUT.
  -q, --quiet         Suppress non-essential output.
  -v, --verbose       Display additional information about script operation.
  -h, --help          Display this help message and exit.

Examples:
  # Read URLs from input.txt and output unique subdomains to the terminal
  subx -i input.txt

  # Read URLs from input.txt and output unique subdomains to subdomains.txt
  subx -i input.txt -o subdomains.txt

  # Read URLs from multiple input files and output unique subdomains to the terminal
  subx -i input1.txt input2.txt

  # Read URLs from STDIN and output unique subdomains to the terminal
  cat input.txt | subx
```

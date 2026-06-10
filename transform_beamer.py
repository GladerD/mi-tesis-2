#!/usr/bin/env python3
import re
import sys

# Read the file
with open(r'C:\Users\Glade\4 Avances\Presentacion\example1.tex', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Extract from line 41 onwards (0-indexed: line 40)
content = ''.join(lines[40:])

# Basic transformations using raw strings
transformations = [
    (r'\\begin\{frame\}\[.*?\]', ''),      # Remove frame options
    (r'\\begin\{frame\}', ''),              # Remove frame start
    (r'\\end\{frame\}', ''),                # Remove frame end
    (r'\\frametitle\{([^}]*)\}', r'\\subsection{\1}'),  # Convert frametitle
    (r'\\framesubtitle\{([^}]*)\}', r'\\subsubsection{\1}'),  # Convert framesubtitle
    (r'\\pause', ''),                       # Remove pause
    (r'\\vspace\{[^}]*\}', ''),            # Remove vspace
    (r'\\begin\{columns\}', ''),            # Remove columns
    (r'\\end\{columns\}', ''),
    (r'\\column\{[^}]*\}', ''),
]

for pattern, replacement in transformations:
    content = re.sub(pattern, replacement, content)

# Remove excessive whitespace (multiple newlines)
content = re.sub(r'\n\n\n+', '\n\n', content)

# Write to output with proper encoding
sys.stdout.reconfigure(encoding='utf-8')
print(content, end='')

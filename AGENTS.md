# AGENTS.md

This codebase contains Conky configurations and Lua scripts for Linux desktop monitoring.

## Build/Test/Lint Commands
- **Generate config**: `python conky-grapes/create_config.py`
- **Run Conky**: `conky -q -d -c ~/conky/conky-grapes/conky_gen.conkyrc`
- **Test with options**: `python conky-grapes/create_config.py -h` (see all options)
- **No formal test suite available**

## Code Style Guidelines

### Python (create_config.py)
- Use snake_case for variables and functions
- Follow PEP 8 indentation (4 spaces)
- Use single quotes for strings by default
- Comprehensive docstrings for functions
- Error handling with try/except blocks
- Use `from __future__ import print_function` for compatibility

### Lua (rings-v2_gen.lua)
- Use lowercase with underscores for variables
- Hex color values in format `0xffffff`
- Comprehensive comments explaining functionality
- Local variable declarations at top of functions

### File Organization
- Templates use `_tpl` suffix, generated files use `_gen` suffix
- Configuration files in root of conky-grapes directory
- Font files (.ttf) stored alongside configs
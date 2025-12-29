# Perl CSV scripts

Will use this repo to store Perl CSV scripts that come up as they're needed.
Many of these scripts replace awk,
which falls short due to difficulty with embedded commas and new lines.

*Todo:*

- [ ] vstack: Need to be able to return unique fields per record, potetnially through flag. May also want stdin parding functionality. Definitely want ability to read more than a single file
- [ ] csvgrep: Need a grep that dosen't get tripped up by embedded new lines

## Scripts

- **vstack:** used to stack fields in the same record vertically, often for piping into unix tools that favor new-line-delimited lists

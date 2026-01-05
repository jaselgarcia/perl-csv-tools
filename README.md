# Perl CSV scripts

Will use this repo to store Perl CSV scripts that come up as they're needed.
Many of these scripts replace awk,
which falls short due to difficulty with embedded commas and new lines.

*Todo:*

- [x] vstack: Need to be able to return unique fields per record, potetnially through flag. May also want stdin parding functionality. Definitely want ability to read more than a single file
- [ ] csvgrep: Need a grep that dosen't get tripped up by embedded new lines
- [x] sub\_newline: Substitute new lines with provided character. Single space by default

## Scripts

- **sub\_newline:** Used to replace embedded newline with string of choice. Accepts files but enables piping in following scripts.
- **vstack:** Used to stack fields in the same record vertically, often for piping into unix tools that favor new-line-delimited lists.

## Changelog

- 2026-01-05: vstack now accepts delimeter as command line arg though still defaults to `\n`.

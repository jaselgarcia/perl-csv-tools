# Perl CSV scripts

Will use this repo to store Perl CSV scripts that come up as they're needed.
Many of these scripts replace awk,
which falls short due to difficulty with embedded commas and new lines.
Implementations of these scripts currently rely on convenient side effects,
such as `sub_newline` stripping unnecessary quote characters
and `vstack`'s ability to function as a delimiter converter.
Devising scripts that more explicitly solve these problems would be worthwhile.

## Dependencies
- Text::CSV

## Scripts
- **sub\_newline:** used to replace embedded newline with string of choice. Accepts files but enables piping in following scripts.
- **vstack:** used to stack fields in the same record vertically, often for piping into Unix tools that favor new-line-delimited lists.
- **pad\_commas:** script that pads each line with commas to match the maximum number of fields in a given column.
- **vlookup:** returns field from lookup array file based off provided search fields from stdin.

## Changelog

- 2026-05-03: prototype `pad_commas` with an awk shell wrapper
- 2026-02-12: configure vstack to also support utf8 character printing. Also, rename master to main
- 2026-01-11: encountered silly bug with extra comma in last field in line with `sub_newline` so implemented for loop that only outputs `$sep` only if not last field. Also removed `add-duplicate-info` to `sf-pipeline` where it aligns more closely to the limited scope of that project.
- 2026-01-06: ran into issues with wide character errors so reached for `use open` params. Need to study in more detail. Also am encountering issues with fields containing new lines that need to be broken up into multiple fields. Would like to address issue with `sub_newline` though may have to develop pipeline with that and `vstack`.
- 2026-01-05: vstack now accepts delimiter as command line arg though still defaults to `\n`.

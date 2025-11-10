# Cornell-letterhead Format

## Installing

_TODO_: Replace the `<github-organization>` with your GitHub organization.

```bash
quarto use template <github-organization>/cornell-letterhead
```

This will install the format extension and create an example qmd file
that you can use as a starting place for your document.

## Using

Set letter metadata in the document YAML to customize the header:

```yaml
letter-name: "Your Name"
letter-title: "Your Title"
letter-roomnumber: "TBD Gates Hall"
letter-phonenumber: "+1 (607) 555-1234"
letter-faxnumber: "+1 (607) 255-9143"
letter-email: "you@example.edu"
letter-website: "https://example.edu"
letter-logo: "path/to/logo.png"
```

Then render with Quarto (Typst output):

```bash
quarto render template.qmd --to typst
```

Adjust logo path and other fields as needed.

## Safe email / website metadata (use included filter)

This extension ships with a small Pandoc Lua filter that:
- decodes base64 metadata keys (letter-email-b64, letter-website-b64) into plain metadata, and
- sanitizes plain values (removes Pandoc-escape backslashes like `\@` or `\/`) so Typst parsing is not broken.

To use it temporarily when rendering:

```bash
quarto preview template.qmd --to typst --lua-filter _extensions/cornell-letterhead/filters/decode-base64.lua
```

Or enable it for the document by adding to YAML:

```yaml
filters:
  - _extensions/cornell-letterhead/filters/decode-base64.lua
```

Examples (YAML):

- Plain (sanitizer will clean obvious Pandoc escapes):
```yaml
letter-email: "ben@example.edu"
letter-website: "https://example.edu"
```

- Base64 (recommended if you prefer not to have raw values in YAML):
```yaml
letter-email-b64: "YmVuQGV4YW1wbGUuZWR1"          # ben@example.edu
letter-website-b64: "aHR0cHM6Ly9leGFtcGxlLmVkdQ==" # https://example.edu
```

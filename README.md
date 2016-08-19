# Bar code generation for vaccine tracking

This [Ruby](https://www.ruby-lang.org) script generates bar codes for vaccine boxes, shelves and frigdes used in the mobile vaccines tracking application (built with [CommCare](https://commcarehq.com)).

The bar codes are generated based on the CSV files in the `csv` directory.

## Usage

```
$ ruby qr.rb
```

## Output

The bar code are rendered in individual PNG files and in merged PDF files. Files are places in the `output` directory.

// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the 
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find 
// documentation on creating typst templates and some examples here: 
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates


#let divider(thickness: 0.5pt, color: luma(30), above: 0.7em) = {
  // produce a visible horizontal rule as content
  block(above: above)[ line(stroke: thickness, color: color, start: (0%,0%), end: (100%,0%)) ]
}

#let letterhead(
  name: none,
  title: none,
  roomnumber: none,
  phonenumber: none,
  faxnumber: none,
  email: none,
  website: none,
  logo: none,
  lockup: none,
  logo_width: 3.5in,
) = {
  // Determine logo path: explicit logo wins, otherwise map lockup keys to resources
  let logo_path = if logo != none {
    logo
  } else if lockup == "is" {
    "resources/Bowers_InformationScience.png"
  } else if lockup == "cis" {
    "resources/Bowers.png"
  } else {
    none
  }

  if name != none {
    // produce content for the header using content expressions (no leading `#` tokens)
    block[
      grid(columns: (logo_width, 1fr), gap: 0.5em)[
        (if logo_path != none { image(logo_path, width: logo_width) } else { vbox[] }),
        align(right)[
          text(weight: "bold")[ name ] \
          if title != none { text()[ title ] } \
          if roomnumber != none { text()[ roomnumber ] } \
          text()[ "Ithaca, NY 14853-7501" ] \
          if phonenumber != none { text()[ "t: " + phonenumber ] } \
          if faxnumber != none { text()[ "f: " + faxnumber ] } \
          if email != none { text()[ "email: " + email ] } \
          if website != none { text()[ website ] }
        ]
      ]
    ]
    // separator rule -> produce content
    divider()
  }
}

#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "libertinus serif",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "libertinus serif",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  pagenumbering: "1",
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,

  // letterhead-specific params (Typst-safe names)
  letter_name: none,
  letter_title: none,
  letter_roomnumber: none,
  letter_phonenumber: none,
  letter_faxnumber: none,
  letter_email: none,
  letter_website: none,
  letter_logo: none,
  letter_lockup: none,
  letter_logo_width: 3.5in,

  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: pagenumbering,
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)

  if title != none {
    align(center)[#block(inset: 2em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
        text(size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  // build the document body, prepending the letterhead content when provided
  let body = if letter_name != none {
    // call the letterhead function (returns content) and concatenate with doc
    letterhead(
      name: letter_name,
      title: letter_title,
      roomnumber: letter_roomnumber,
      phonenumber: letter_phonenumber,
      faxnumber: letter_faxnumber,
      email: letter_email,
      website: letter_website,
      logo: letter_logo,
      lockup: letter_lockup,
      logo_width: letter_logo_width
    ) + doc
  } else {
    doc
  }

  if cols == 1 {
    body
  } else {
    columns(cols, body)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)

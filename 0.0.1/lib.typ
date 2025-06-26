#import "utils.typ": inline_href

#let uservars = (
    headingfont: "Helvetica", // Set font for headings
    bodyfont: "Helvetica",   // Set font for body
    fontsize: 9pt,
    linespacing: 5pt,
)

// set rules
#let setrules(uservars, doc) = {

    // heading settings
    show heading.where( level: 1 ): set text(
        font: uservars.headingfont,
        size: 16pt,
    )
    show heading.where( level: 2 ): set text(
        font: uservars.headingfont,
        size: 12pt,
    )
    // show heading.where( level: 2 ): set block(
    //     below: 0.em
    // )
    show heading.where( level: 3 ): set text(
        font: uservars.headingfont,
        size: 11pt,
    )
    show heading.where( level: 4 ): set text(
        font: uservars.headingfont,
        size: 10pt,
        weight: "regular",
        
    )

    // set page layout
    set page(
        paper: "us-letter", // a4, us-letter
        number-align: center, // left, center, right
        margin: 0.5in,
        numbering: "1"
    )
    // set text settings
    set text(
        font: uservars.bodyfont,
        size: uservars.fontsize,
        hyphenate: false,
    )
    set super(typographic: false)

    // set paragraph settings
    set par(
        leading: uservars.linespacing,
        justify: true,
        spacing: 0.6em,
        first-line-indent: 1.2em,
        
    )

    // tables
    show table.cell.where(y: 0): strong
    set table(
    stroke: (x, y) => if y == 0 {
        (bottom: 0.7pt + black)
    },
    align: (x, y) => (
        if x > 0 { center }
        else { left }
    )
    )

    // figures
    show figure.caption: set text(size: 8pt)
    show figure.caption: set align(left)
    // https://forum.typst.app/t/how-to-customize-the-styling-of-caption-supplements/976/2
    show figure.caption: it => context [
        *#it.supplement~#it.counter.display()#it.separator*#it.body
    ]
    show figure.where(
        kind: table
    ): set figure.caption(position: top)

    doc
}

// set page layout
#let init(doc) = {
    doc = setrules(uservars, doc)
    doc
}

#let title(title_content) = {
    block(width: 100%)[
        #set align(left)
        #title_content
    ]
}

#let authors(author_data) = {
    set par(justify: false)
    let authorn = 1
    for author in author_data.authors {
        let author_string = box({
            let affiln = 1
            box[#author.name]
            for affiliation in author.affiliations {
                super[#affiliation]
                if affiln < author.affiliations.len() {
                    super[,]
                }
                affiln += 1
            }
            if author.keys().contains("correspondence") {
                box[#super[#link("mailto:" + author.correspondence)[ ✉]]]
            }
            if authorn < author_data.authors.len() {
                ", "
            }
        })
        authorn += 1
        author_string
    }
}

#let affiliations(author_data) = {
    set par(first-line-indent: 0em)
    for affil in author_data.affiliations.pairs() {
        let affiliation_string = box({
            set text(size: 8pt)
            super(affil.at(0))
            affil.at(1)
        })
        affiliation_string
        linebreak()
    }
}

#let abstract(content) = {
    // links
    show link: underline
    rect([
        #pad(
            [ #content ],
            x: 0.5pt, 
            y: 0.5pt
        )
    ],
        fill: rgb("#f0f0f0")
    )
    
}

// manuscript content
#let manuscript(doc) = {
    columns(2, [
        #doc
    ])
}
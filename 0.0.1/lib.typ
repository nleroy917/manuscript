#import "utils.typ": inline_href

#let maketitle(title) = {
    block(width: 100%)[
        #set align(left)
        = #title
    ]
}

#let makeabstract(content) = {
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

#let makeauthors(authors) = {
    set par(justify: false)
    let authorn = 1
    for author in authors.authors {
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
            if authorn < authors.authors.len() {
                ", "
            }
        })
        authorn += 1
        author_string
    }

    //
    // affiliations
    // 
    set par(first-line-indent: 0em)
    for affil in authors.affiliations.pairs() {
        let affiliation_string = box({
            set text(size: 8pt)
            super(affil.at(0))
            affil.at(1)
        })
        affiliation_string
        linebreak()
    }
}

#let makekeywords(keywords) = {
    [#keywords.join(" " + " | " + " ")]
}

#let manuscript(
    title: none,
    authors: (),
    abstract: none,
    keywords: (),
    correspondance: none,
    refs: none,
    doc
) = {

    //
    // set page layout
    // 
    set page(
        paper: "us-letter", // a4, us-letter
        number-align: center, // left, center, right
        margin: 0.5in,
        numbering: "1",
    )

    //
    // heading settings
    // 
    show heading.where( level: 1 ): set text(
        font: "Helvetica",
        size: 16pt,
        weight: "extrabold"
    )
    show heading.where( level: 2 ): set text(
        font: "Helvetica",
        size: 12pt,
    )
    show heading.where( level: 3 ): set text(
        font: "Helvetica",
        size: 11pt,
    )
    show heading.where( level: 4 ): set text(
        font: "Helvetica",
        size: 10pt,
        weight: "regular",
    )

    //
    // text settings
    // 
    set text(
        font: "Helvetica",
        size: 9pt,
        hyphenate: false,
    )


    // fix for citation superscript issue
    set super(typographic: false)

    // paragraph settings
    set par(
        leading: 5pt,
        justify: true,
        spacing: 0.6em,
        first-line-indent: 1.2em,    
    )

    
    // table settings/style
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

    //
    // figure settings/style
    // 
    show figure.caption: set text(size: 8pt)
    show figure.caption: set align(left)
    // https://forum.typst.app/t/how-to-customize-the-styling-of-caption-supplements/976/2
    show figure.caption: it => context [
        *#it.supplement~#it.counter.display()#it.separator*#it.body
    ]
    show figure.where(
        kind: table
    ): set figure.caption(position: top)
    set figure(
        supplement: [Fig.],
    )
    
    maketitle(title)
    v(8pt)
    makeauthors(authors)
    v(8pt)
    makeabstract(abstract)
    if keywords != none {
        makekeywords(keywords)
    }
    v(8pt)

    columns(2)[
        #doc
    ]
}

#let backmatter(doc) = {
    state("backmatter").update(true)
    set figure(
        numbering: "S1",
        supplement: "Supplemental Figure"
    )
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)

    doc
}
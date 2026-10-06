#import "@preview/touying:0.8.0": *
#import themes.metropolis: *

#set heading(numbering: "1.")

#show: metropolis-theme.with(
    // aspect-ratio: "16-9",
    // footer-progress: true,
    config-info(
        title: [*Intro to Typst*],
        // subtitle: [Subtitle],
        author: [Yik Jin],
        date: datetime(
            year: 2026,
            month: 10,
            day: 6,
            hour: 19,
            minute: 0,
            second: 0,
        ),
        institution: [*NUS Hackers*],
        contact: [yikjin\@nushackers.org],
    ),
    config-common(
        datetime-format: "[weekday repr:long], [day padding:zero] [month repr:long] [year repr:full], [hour padding:zero repr:24][minute padding:zero]h",
        slide-level: 3,
    ),
    config-page(
        margin: (bottom: 2em),
    ),
)

// #set text(font: "Fira Sans", weight: "light", size: 20pt)
// #show math.equation: set text(font: "Fira Math")
// #set strong(delta: 300)
// #set par(justify: true)

#show link: set text(fill: blue)
#show "e.g.": emph
#show "etc.": emph
#show "i.e.": emph

#let preview(
    content,
    code,
    preview-width: 40%,
    cell-colours: (rgb("fff8e1"), rgb("eee")),
    ..slide-config,
) = {
    slide(composer: (1fr, preview-width), ..slide-config)[
        #content
    ][
        #let c = code.replace(regex("\n {4}"), "\n")

        #grid(
            columns: 1fr,
            rows: (1fr, 1fr),
            column-gutter: 0pt,
            row-gutter: 12pt,
            inset: 12pt,
            fill: (_x, y) => cell-colours.at(calc.rem(y, cell-colours.len())),
            raw(c, block: true, lang: "typ"),
            eval(c, mode: "markup"),
        ) <touying:hidden>
    ]
}

// <https://github.com/typst/typst/discussions/1732#discussioncomment-11286036>
#let LaTeX = {
    set text(font: "New Computer Modern")

    let l = "L"
    let a = text(baseline: -0.35em, size: 0.66em, "A")
    let t = "T"
    let e = text(baseline: 0.22em, "E")
    let x = "X"
    box(l + h(-0.32em) + a + h(-0.13em) + t + h(-0.14em) + e + h(-0.14em) + x)
}


/*
 * Slides start
 */

#title-slide(config: config-common(show-strong-with-alert: false))

= Outline <touying:hidden>

#components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))


= What is Typst?

== Typst summary

Typst is "an open-source typesetting system and corresponding markup language"

- Helps you make *clean, professional documents* from simple *markup code*
    (similar philosophy to, but much more powerful than Markdown)
- Easier than using #LaTeX
- Is a more modern alternative to #LaTeX

== What Typst can create

Typst can output to various common file types:

- PDF #sym.arrow.r *today's focus*
    - Cheat sheets
    - Assignments
    - Resume / CV
    - Slides
    - ...
- PNG
- SVG
- HTML _(experimental)_
- Bundle of various files _(experimental)_

== Some examples

Some examples of documents created using Typst:

- #link(
        "https://github.com/MengYueqi/cheatsheet_typst/blob/main/README.md#preview",
    )[Cheatsheet]
- #link("https://github.com/oldrev/tids/blob/master/demo-ds.pdf")[Datasheet]
- #link(
        "https://github.com/touying-typ/touying/blob/main/README.md#full-example",
    )[Slides]
- ...

== Why not #LaTeX?

While #LaTeX is the de-facto industry standard for creating scientific
documents, it is unwieldy:

- A mistake in the #LaTeX markup often gives unhelpful/mysterious error messages
    (e.g. ```latex ! Missing $ inserted.``` when there is blank lines in math
    environments)
- Modifying the design and layout of files is tricky
- Compiling #LaTeX files takes (tens of) seconds
- Not as easy to pick up compared to Typst

== Disambiguation of Typst

The term "Typst" has different meanings in different contexts

When someone refers to Typst, they may mean:

+ The Typst *markup language*
+ The Typst *compiler* (`typst` binary that compiles the markup language)
+ The Typst *web app* (at #link("https://typst.app/play")[typst.app/play])

== What we'll be using today

We'll be writing the Typst markup language today, which needs the `typst`
compiler to generate output files like PDF

For ease-of-use and simplicity, we will be using the *Typst web app* at #link(
    "https://typst.app/play",
)[typst.app/play] instead

=== Typst web app

#slide(composer: (1fr, auto))[
    The #link("https://typst.app/play")[Typst web app] allows *live-compiling
    Typst markup* to preview the expected output quickly

    - Signing up for an account for today is _optional_
][
    #figure(
        image("res/web_app.png"),
        caption: [Typst web app],
    )
]


= Basics of Typst markup

Typst has a simple markup syntax, and is easy to pick up

It has a similar philosophy to Markdown, but Typst syntax is different

#preview(
    [
        Write a line of plain text as-is

        A paragraph is separated from another with an *empty line in between*
    ],
    "This is a paragraph. It can have multiple lines.

    This is another paragraph.",
)

== *Bold* and _italics_

#preview(
    config: config-common(show-strong-with-alert: false),
    [
        *Bold* words with ```typ *bolded words*```

        _Italicise_ words with ```typ _italicised words_```
    ],
    "This is a paragraph. It can have *multiple lines*.

    This is _another_ paragraph.",
)

== Headings

#preview(
    [
        Create a heading with ```typ = Heading 1```

        Headings have different levels, denoted by number of ```typ =```s
    ],
    "",
    // "= Level 1
    // == Level 2
    // === Level 3
    // ==== Level 4",
)

== Lists

#preview(
    [
        An unordered (i.e. bullet point) list starts with ```typ -```

        An ordered (i.e. numbered) list starts with ```typ +```
    ],
    "- Hang out with friends
    - Book an appointment

    + Take a straw
    + Use straw to poke lid of bubble tea",
)

== Comments

#preview(
    [
        Add a comment with:

        - ```typ // Comment``` for single-line comment
        - ```typ /* Comment */``` for multi-line comment
    ],
    "// This is a comment
    // There is no output below

    /* This comment spans
    multiple lines */",
)

== Raw text

#preview(
    [
        Add raw/monospaced text with ```typ `text` ```
    ],
    "This is a `monospaced text`.",
)

== Code block

#preview(
    [
        There are 2 ways to display code blocks:

        - *Inline* to the paragraph
        - *Block level* as a paragraph

        Code should be surrounded with triple-backticks, with a Markdown
        language tag given
    ],
    "What is ```rust fn main()``` in Rust?

    ```rust
    fn main() {
        println!(\"Hello!\");
    }
    ```",
)


= Modes

Typst has 3 different modes:

- *Markup* mode #pause #sym.arrow.r what we have been doing thus far #meanwhile
- *Math* mode
- *Code* mode

#pause

\

We have been writing in *markup* mode thus far, allowing us to do formatting of
text easily

See a more comprehensive syntax list of markup mode on the
#link("https://typst.app/docs/reference/syntax/#markup")[Typst documentation
    here]


= Code mode

We'll now use some functions in code mode to insert more objects to our document

Enter code mode with ```typ #```, then you can invoke functions, set variables,
etc.

== Adding images

#preview(
    [
        Add local or remote images with ```typc image()```, passing in the URI
    ],
    "#image(\"res/nus_hackers.svg\")",
)

#preview(
    [
        Functions can accept arguments. The ```typc image()``` function accepts
        a named argument "width".
    ],
    "#image(\"res/nus_hackers.svg\", width: 50%)",
)

== Adding tables

#preview(
    [
        Add tables with ```typc table()```, passing in various arguments as
        needed
    ],
    "#table(
        columns: 2,
        table.header(
            [ *A* ], [ *B* ]
        ),
        [ 1 ], [ 2 ],
        [ 3 ], [ 4 ]
    )",
)

== Set and show rules

Use ```typ #set``` to set properties to all occurrences of some kind of content

- e.g. ```typ #set page(paper: "a6")```

#preview(
    [
        Use ```typ #show``` to redefine how certain elements are displayed
    ],
    "#show \"Hackers\": name => box[
        #box(image(
            \"res/nus_hackers.svg\",
            height: 0.7em
        )) #name]

    Welcome to Hackers!",
)

Use a show-set rule to apply to elements matching the selector

- e.g. ```typ #show heading: set align(center)```

== Setting up the page

For general page customisations, you can use set rules on:

- #link("https://typst.app/docs/reference/text/text/")[```typc text```]
- #link("https://typst.app/docs/reference/layout/page/")[```typc page```]
- #link("https://typst.app/docs/reference/model/par/")[```typc par```]
- #link("https://typst.app/docs/reference/model/heading/")[```typc heading```]
- #link("https://typst.app/docs/reference/model/document/")[```typc document```]


= Math mode

#preview(
    [
        Let's start typing some math equations now!

        Enter math mode with ```typ $```, and type math equations before the
        closing ```typ $```
    ],
    "A linear graph has the form $y = m x + c$. Therefore:

    $
        y = m x + c \
        y - c = m x \
        x = (y - c) / m
    $
    ",
)

== Inline and block-level math

#preview(
    [
        There are 2 ways to display math:

        - ```typ $...$``` shows the math *inline* to the paragraph
        - ```typ $ ... $``` with at least a starting and ending space shows the
            math in its *own block*
    ],
    "A linear graph has the form $y = m x + c$. Therefore:

    $
        y = m x + c \
        y - c = m x \
        x = (y - c) / m
    $
    ",
)

== Variables

#preview(
    [
        Variables must be a character (e.g. ```typm m```).

        Multi-character variables (or just strings) can be displayed between
        quotes (e.g. ```typm "gradient"```).
    ],
    "A linear graph has the form $y = m x + c$. Therefore:

    $
        y = m x + c_\"int\" \
        y - c_\"int\" = m x \
        x = (y - c_\"int\") / m
    $
    ",
)

== Sub- and super-script

#preview(
    [
        Create sub-scripts with ```typm _```, and super-scripts with
        ```typm ^```

        You can group multiple terms with brackets (e.g. ```typm 2^(n+1)```)
    ],
    "A linear graph has the form $y = m x + c$. Therefore:

    $
        y_1 = m x_1 + c_\"int\" \
        y_1 - c_\"int\" = m x_1 \
        x_1 = (y_1 - c_\"int\") / m
    $
    ",
)

== Fractions

#preview(
    [
        Create fractions with ```typm /``` (e.g. ```typm a/b```)

        You can group multiple terms with brackets (e.g. ```typm (n+1)/(n^2)```)
    ],
    "A linear graph has the form $y = m x + c$. Therefore:

    $
        y_1 = m x_1 + c_\"int\" \
        y_1 - c_\"int\" = m x_1 \
        x_1 = (y_1 - c_\"int\") / m
    $
    ",
)

== Symbols

#preview(
    [
        Math symbols can be inserted inside math mode

        - See #link("https://typst.app/docs/reference/symbols/sym/")[this Typst
                documentation link] for a full list of symbols
    ],
    "$
        m = (dif y)/(dif x) \
        integral_a^b x^n dif x = [(x^(n+1))/(n+1)]_a^b
    $",
)

== Functions

#preview(
    [
        You can have function calls in math mode (e.g. ```typm mat()``` for
        matrix, ```typm accent()``` for accents over variables)

        - See #link("https://typst.app/docs/reference/math/#definitions")[this
                Typst documentation link] for a list of built-in math functions
    ],
    "$
        c = sqrt(a^2 + b^2) \
        m = mat(1, 2; 3, 4)
    $",
)

== Alignment

#preview(
    [
        Math blocks can have alignment markers as well, useful for aligning
        multiple equations in a block

        - ```typm &``` is the alignment marker used, alternating alignment from
            right to left back to right...
    ],
    "$
        y & = m x + c \
          & = 12
    $",
)

#preview(
    [
        Math blocks can have alignment markers as well, useful for aligning
        multiple equations in a block

        - ```typm &``` is the alignment marker used, alternating alignment from
            right to left back to right...
    ],
    "$
        a & = 1 && != 2.01234 \
        b & = 3.14159 && != 3
    $",
)

== Exercise

Try typing these math equations in one math block using Typst:

$
                                     c_k & = f_p integral_(t_0)^(t_0 + T_p) x_(p)(t) space.thin e^(-j 2 pi k f_p
                                           t) dif t, space forall k in ZZ \
                                         \
             "Phase spectrum" angle X(f) & = tan^(-1)(Im[X(f)] / Re[X(f)]) \
    [x_(n)(t) = cal(F)^(-1){ X_(n)(f) }] & arrows.rl [X_(n)(f) = cal(F){
                                                   x_(n)(t) }]
$

=== Solution

The solution for the previous slide:

```typ
$
    c_k & = f_p integral_(t_0)^(t_0 + T_p) x_(p)(t) space.thin e^(-j 2 pi k f_p
        t) dif t, space forall k in ZZ \
    \
    "Phase spectrum" angle X(f) & = tan^(-1)(Im[X(f)] / Re[X(f)]) \
    [x_(n)(t) = cal(F)^(-1){ X_(n)(f) }] & arrows.rl [X_(n)(f) = cal(F){
        x_(n)(t) }]
$
```


= Outline <touying:hidden>

#focus-slide[
    Thanks for coming :D
]


#let NotoSongti = "Noto Serif CJK SC"
#let LatinFont = "New Computer Modern"

#let book(
  title: [],
  authors: [],
  abstract: none,
  paper-size: "a4",
  bib-file: none,
  body
)={
  import "@preview/i-figured:0.2.4"
  set page(paper: paper-size)

  //标题样式
  set heading(numbering: "1.1.1")
  show heading: set text(weight: "bold", fill: rgb(73, 112, 198))
  show heading.where(level: 1): it => {
    pagebreak()
    block(below: 1.8em)
    let chapter-counter = if counter(heading).display() > "0" [#counter(heading).display("第一章  ")]
                          else []
    align(center)[
    #text([#chapter-counter#it.body], size: 25pt)
    ]
  }

  show heading.where(level: 2): set text(size: 21pt)

  show heading.where(level: 3): set text(size: 18pt)

  show heading.where(level: 4): set text(size: 15pt)

  // 正文字号
  set text(size: 12.5pt, lang: "zh", font: (LatinFont, NotoSongti))

  // 强调样式
  //show emph: set text(size: 15pt, font: (LatinFont, "Kaiti SC"), style: "italic")

  // 强烈强调样式
  show strong: text.with(weight: "bold", font: (LatinFont, NotoSongti))

  // 链接颜色
  show link: set text(fill: rgb(204,33,96))
  show cite: set text(fill: rgb(17,32,233))

  // 行距, 段落间距, 首行缩进
  set par(first-line-indent: 2em, spacing: 2em, leading: 1.5em)

  align(center, text(43pt, weight: "bold")[#title])
  v(3cm) // 垂直间距
  align(center)[
    #text([#authors], size: 30pt) \
    #text([#datetime.today().display("[year]年[month]月[day]日")], size: 22pt)
  ]

  // 数学公式段落额外调整
  show math.equation: set block(
    above: 0.9em,  // 公式上方间距
    below: 0.9em   // 公式下方间距
  )

  // 行间公式要紧凑一些
  show math.equation.where(block:true): set par( leading: 0.7em)

  // 数学公式编号样式
  show heading.where(level: 2): it =>{
    counter(math.equation).update(0) // 每次显示二级标题就更新一次公式计数器
    it
  }
  
  // set math.equation(numbering: n => {
  //   let section-counter = counter(heading).get()
  //   numbering("(1.1.1)", 
  //   section-counter.first(),
  //   section-counter.at(1, default: 0), n)
  // })
  show math.equation: i-figured.show-equation.with(only-labeled: true,level: 2)

  //show math.equation: set text(lang:"zh", font: (LatinFont, NotoSongti))

  // 目录
  outline(title: auto, depth: 2)

  // 正文页码设置
  counter(page).update(0)
  set page(numbering: "1")

  body

  if bib-file != none {
    v(2em)
    counter(heading).update(0) // 重置章节计数器
    bibliography(bib-file,
    title: auto,
    full: true,
    style: "harvard-cite-them-right")
  }
}

// 无编号公式
// 需要这么设置, 是 typst 的缺陷...
#let nonum-equation(body) = {
    math.equation($body$, numbering: none, block: true)
}

//#let scr(body) = math.text(font: "KaTeX_Script")[#body #h(0.3em)]

//#let scr(it) = math.text(font: "KaTeX_Script")[#it #h(0.2em)]

//#let scr(it) = math.class("normal", text(font:"KaTeX_Script")[#it #h(0.05em)])
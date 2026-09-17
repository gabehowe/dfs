\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mla}[MLA Format Class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
% Default options
\setlength{\paperheight}{11in}
\setlength{\paperwidth}{8.5in}
\setlength{\textwidth}{9.5in}
\setlength{\oddsidemargin}{0in}
\setlength{\evensidemargin}{0in}
\setlength{\topmargin}{0in}
\setlength{\headheight}{9pt}
\setlength{\headsep}{\dimexpr(0.5in-\headheight)\relax}
\setlength{\parskip}{0.0in}
\setlength{\parindent}{0.5in}
\ProcessOptions\relax
\LoadClass{article}
\PassOptionsToPackage{letterpaper, margin=1in}{geometry}
\RequirePackage{expl3}
\RequirePackage{geometry, mathptmx}
\RequirePackage{ragged2e}
\setlength{\RaggedRightParindent}{\parindent}
\clubpenalty10000
\widowpenalty10000
\displaywidowpenalty10000

\def\today{\number\day\space\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
   \space\number\year}

\pagenumbering{arabic}
\renewcommand\raggedright{%
  \let\\\@centercr\@rightskip\@flushglue \rightskip\@rightskip
  \leftskip\z@skip}
%\renewcommand{\thepage}{1}

\gdef\@class{\empty}
\gdef\@professor{\empty}
\gdef\@lastname{\empty}
\newcommand{\class}[1]{\gdef\@class{#1}}
\newcommand{\professor}[1]{\gdef\@professor{#1}}
\renewcommand{\author}[2]{
\gdef\@author{#1 #2}
\gdef\@lastname{#2}
}

\def\ps@plain{\let\@mkboth\@gobbletwo
  \let\@oddfoot\@empty\let\@evenfoot\@empty
  \def\@oddhead{\reset@font\hfil\@lastname\space\thepage}\let\@evenhead\@oddhead}
\pagestyle{plain}
\raggedright
\renewcommand{\maketitle}{
  \noindent\@author\par
  \noindent\@professor\par
  \noindent\@class\par
  \noindent\@date
  {\par{\centering\@title\par}}
}
\renewcommand{\normalsize}{\fontsize{12}{28.655}\selectfont}
\renewcommand{\large}{\fontsize{14}{16}\selectfont}
\renewcommand{\Large}{\fontsize{17}{19}\selectfont}

\RequirePackage[colorlinks=true, citecolor=black]{hyperref}
\renewcommand{\UrlFont}{\normalfont}
\RequirePackage[american]{babel}
\RequirePackage{csquotes}
\RequirePackage[ style=mla-strict, backend=biber ]{biblatex}

\defbibheading{bibliography}[\refname]{\centering \noindent \textbf{#1}}
\renewcommand{\section}[1]{\par\noindent{\bfseries\large#1}\par}
\renewcommand{\subsection}[1]{\par\noindent{\scshape#1}\par}
\renewcommand{\subsubsection}[1]{\par\noindent{\slshape#1}\par}
\renewcommand{\paragraph}[1]{\par\noindent{\slshape#1}\par}

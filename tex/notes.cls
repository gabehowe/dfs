%% homework.cls  Copyright (C) 2020  Ahmad Tashfeen
%% This program comes with ABSOLUTELY NO WARRANTY.
%% This is free software, and you are welcome to
%% redistribute it under certain conditions; read
%% file COPYING for more details.

% Put in /usr/local/texlive/texmf-local/tex/latex/local
% And then re-index, see: https://tex.stackexchange.com/q/1137/215221
% Latex documentation: https://en.wikibooks.org/wiki/LaTeX
% 'em' is the horizontal space unit and 'ex' is the vertical

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{notes}[2024/01/01 Notes]
\def\hw@ptsize{12pt} % https://tex.stackexchange.com/a/634138/215221
\DeclareOption{10pt}{\def\hw@ptsize{10pt}}
\DeclareOption{11pt}{\def\hw@ptsize{11pt}}
\DeclareOption{12pt}{\def\hw@ptsize{12pt}}
\def\hw@side{oneside}
\def\hw@dark{dark}
\DeclareOption{oneside}{\def\hw@side{oneside}}
\DeclareOption{twoside}{\def\hw@side{twoside}}
\DeclareOption{light}{\def\hw@dark{light}}

\ProcessOptions\relax
\PassOptionsToPackage{explicit}{titlesec}
\LoadClass[\hw@ptsize, \hw@side]{homework}
\RequirePackage{fontenc, tgheros, float, transparent, pgffor, expl3}

\ifthenelse{\equal{\hw@dark}{light}}{}{
\pagecolor{black!80}
\color{white}
}
\usepgfplotslibrary{fillbetween}
%\usetikzlibrary{patterns}
\usetikzlibrary{arrows.meta}
\usetikzlibrary{patterns.meta}
\renewcommand{\familydefault}{\sfdefault}
\parindent=0pt
\skipquestioncheck%

\pgfdeclarepattern{%
  name=nwl,
  parameters={\nwllw, \nwldst, \nwlop, \nwlang},
  bottom left={\pgfpoint{-.8* (\nwldst)}{-.8* (\nwldst)}},
  top right={\pgfpoint{.8* (\nwldst)}{.8* (\nwldst)}},
  tile size={\pgfpoint{\nwldst}{\nwldst}},
  tile transformation={\pgftransformrotate{\nwlang}},
  code={%
    \pgfsetlinewidth{\nwllw}
    \pgfsetstrokeopacity{\nwlop}
    \pgfpathmoveto{\pgfpoint{0pt}{0pt}}
    \pgfpathlineto{\pgfpoint{\nwldst}{\nwldst}}
    \pgfusepath{stroke}
  }
}

\tikzset{%
  pattern line width/.store in=\nwllw,
  pattern distance/.store in=\nwldst,
  pattern angle/.store in=\nwlang,
  pattern opacity/.store in=\nwlop,
  pattern distance=3pt,
  pattern angle=0,
  pattern line width=0.7pt,
  pattern opacity=0.7,
}


\hypersetup {
  pdfstartview=FitH,
  colorlinks=true
}

\newcommand{\chapter}[1]{\vspace{\baselineskip - 9pt}\par{\bf\transparent{0.3}\hfil#1\par\vspace{-\baselineskip}}}
\titleformat{name=\section}[block]{\bf\large\filcenter}{\thesection}{1em}{#1}
\titleformat{name=\section,numberless}[block]{\Large}{}{0em}{#1}[\color{\styleColor}\vspace{-\baselineskip + 4.5pt}\rule{.33\linewidth}{0.3pt}\vspace{-4pt}]
\titleformat{name=\subsection,numberless}[block]{\normalsize\filcenter}{}{0em}{#1}
[\color{bstyle3}\vspace{-\baselineskip + 2.0pt}\hspace{0.005pt}
\rule{\widthof{#1}}{0.1pt}
\vspace{-4pt}]
\titleformat{name=\subsubsection,numberless}[block]{\normalfont\normalsize\filcenter}{}{0em}{#1}

\AtBeginDocument{
  \hypersetup {
    pdftitle={\@title},
    pdfauthor={\@author},
  }

}

\gdef\stylehue{0}

\renewcommand{\maketitle} {%
% Create alternate colors
  %\definecolor{style##1}{\fp_eval:n {\stylehue+##1},240,240}
  \setupnewcolors{\@colorseed}
  \noindent\begin{minipage}{0.80\textwidth}
  \noindent\ifthenelse{\equal{\@author}{\empty}}{}{\@author\par}%
  \noindent\ifthenelse{\equal{\@title}{\empty}}{}{\@title\par}%
\end{minipage}
\noindent
\begin{minipage}{.19\textwidth}
  \raggedleft
  \noindent\@date\par
  \noindent\ifthenelse{\equal{\@date}{\today}}{}{M: \today\par}
\end{minipage}
%\ifthenelse{\equal{\@title}{\empty}}{}{\\\vspace{\medskipamount}}%
\\\vspace{\medskipamount}
\par
  \begin{center}\unskip%
    {\vspace{-\baselineskip +1.5pt}\color{\styleColor}\rule{0.98\textwidth}{1pt}\vspace{3pt - \baselineskip}}\\
%
  \end{center}%
  \addvspace{1.9\bigskipamount}%
}


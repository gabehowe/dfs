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
\ProvidesClass{homework}[2023/01/01 Homework]
\def\hw@ptsize{12pt} % https://tex.stackexchange.com/a/634138/215221
\DeclareOption{10pt}{\def\hw@ptsize{10pt}}
\DeclareOption{11pt}{\def\hw@ptsize{11pt}}
\DeclareOption{12pt}{\def\hw@ptsize{12pt}}
\def\hw@side{oneside}
\DeclareOption{oneside}{\def\hw@side{oneside}}
\DeclareOption{twoside}{\def\hw@side{twoside}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{amsart}}
\ProcessOptions\relax
\PassOptionsToPackage{approx}{numerica}
\PassOptionsToPackage{=v2}{siunitx}
\PassOptionsToPackage{bookmarksopen=true,bookmarks=true}{hyperref}
\PassOptionsToPackage{explicit}{titlesec}
\LoadClass[\hw@ptsize, \hw@side, reqno]{amsart}
\RequirePackage[margin=0.5in]{geometry}
\RequirePackage{lmodern, enumitem, needspace} % needspace for dynamic line breaking
\RequirePackage{ifthen, titlesec, framed, textcomp, gensymb}
\RequirePackage{datetime, titleref, linegoal}

\RequirePackage{siunitx, setspace}
\RequirePackage{physics, numerica}
\RequirePackage{hwsymb, hwlst, hwcmd} % tashfeen's
\RequirePackage{hyperref, bookmark} % for pdf bookmarks, other information and org-mode
\RequirePackage{tikz, amsmath, etoolbox, atveryend, float, fancyhdr}
\mathtoolsset{showonlyrefs}


\ExplSyntaxOn
\clist_new:N \l_hw_questions_clist
\int_new:N \l_hw_int_total_questions
\bool_const:Nn \l_runquestionchecker_bool {\c_true_bool}

\NewDocumentCommand \skipquestioncheck {}{
 \bool_set_false:N \l_runquestionchecker_bool
}

\AtEndDocument{
	\vfill
	\noindent{\color{gray}\scriptsize~Last~Modified:~\today\space at~\currenttime\qquad}
    \bool_if:NT \l_runquestionchecker_bool {
      \texttt{ \scriptsize \color{red} {
      \clist_count:N \l_hw_questions_clist}/{\int_use:N \l_hw_int_total_questions}~questions~({\clist_use:Nn \l_hw_questions_clist {,}})~remain~unchecked.
      }
    }
}

\str_new:N \l_hw_author_str
\str_new:N \l_hw_class_str
\int_new:N \l_hw_colorseed_int

\DeclareDocumentCommand\author{m}{ \str_set:Nn \l_hw_author_str {#1} }
\DeclareDocumentCommand\class{m}{ \str_set:Nn \l_hw_class_str {#1} }
\DeclareDocumentCommand\colorseed{m}{ \int_set:Nn \l_hw_colorseed_int {#1}
 }
\NewDocumentCommand{\setupnewcolors}{m}{%
  \sys_gset_rand_seed:n #1
  \int_new:N \l_my_stylehue
  \int_set:Nn \l_my_stylehue {\int_rand:nn {0} {240}}
  \definecolor{style_color}{HSB}{\int_eval:n \l_my_stylehue,240,240}
  \color_set:nnn {style0}{HSB}{\int_eval:n \l_my_stylehue, 240, 240}
  \color_set_eq:nn {style_color}{style0}

  \int_step_inline:nn {6}{
    \color_set:nnn {style##1}{HSB}{\int_eval:n {\int_mod:nn {\l_my_stylehue + ##1*7}{240}},240,240}
    \color_export:nnN {style##1}{comma-sep-rgb} \l_tmpa_tl
    \definecolor{style##1}{rgb}{\tl_use:N \l_tmpa_tl}
    }
  \int_step_inline:nn {6}{
    \color_set:nnn{bstyle##1}{HSB}{\int_eval:n {\int_mod:nn {\l_my_stylehue - ##1*7 + 240}{240}},240,240}
    \color_export:nnN {bstyle##1}{comma-sep-rgb} \l_tmpa_tl
    \definecolor{bstyle##1}{rgb}{\tl_use:N \l_tmpa_tl}
  }
}

\RenewDocumentCommand{\headrule}{}{
  \skip_vertical:n {-0.6em}
  \hbox_to_wd:nn {\headwidth}{
    \tikz{\draw[color=style_color,dashdotted, line~width=1.1pt] (0,0)--(\headwidth,0);}}
  \skip_vertical:n {-0.8em}
}

\fancypagestyle{firstpage}{
  \cfoot{}
  \lhead{
    \noindent\str_if_empty:NF \l_hw_author_str {\l_hw_author_str}
  }
  \rhead{
    \raggedleft
    \noindent\@date\par
    \noindent\str_if_empty:NF \l_hw_class_str {\l_hw_class_str}
  }
  \setlength{\headheight}{0.5in}
}

\AtBeginDocument{
  \hypersetup {
    pdftitle={\@title},
    pdfauthor={\l_hw_author_str},
    pdfsubject={\l_hw_class_str}
    pdfstartview=FitH,
  }
 \setupnewcolors{\l_hw_colorseed_int}
 \thispagestyle{firstpage}
}
\NewDocumentCommand\bottomrule{m}{
  {\color{#1}\vspace{-\baselineskip + 4.5pt}\rule{\linewidth}{0.3pt}\vspace{-4pt}}
}

\NewDocumentCommand\middlerule{mm}{
  \unskip
  {
    \color_select:n {#2}
    \rule[0.5ex - 0.4pt]{1em}{0.4pt}
  }
  \skip_horizontal:n {0.3em}
  #1
  \skip_horizontal:n {0.3em}
  {
    \color_select:n {#2}
    \rule[0.5ex - 0.4pt]{\linegoal}{0.4pt}
  }
}

\RenewDocumentCommand{\maketitle}{}{{
    \thispagestyle{firstpage}
  \mode_leave_vertical: 
  \skip_vertical:n {0em}
  \noindent\hfill\bf\large{\uppercasenonmath\@title\@title}\hfill

  \uppercasenonmath\shorttitle
  \begingroup
  \toks@\@xp{\shortauthors}\@temptokena\@xp{\shorttitle}%
  \toks4{\def\\{ \ignorespaces}}% defend against questionable usage
  \edef\@tempa{%
    \@nx\markboth{\the\toks4
      \@nx\MakeUppercase{\the\toks@}}{\the\@temptokena}}%
  \@tempa
  \endgroup
}}
%\def\maketitle{\par
  %%\@topnum\z@ % this prevents figures from falling at the top of page 1
  %%\@setcopyright
  %\thispagestyle{firstpage}% this sets first page specifications
  %%\uppercasenonmath\shorttitle
  %%\ifx\@empty\shortauthors \let\shortauthors\shorttitle
  %%\else \andify\shortauthors
  %%\fi
  %%\@maketitle@hook
%}

\ExplSyntaxOff


\def\styleColor{style_color!80}

\def\currtitle{\ttl@savetitle}
\numberwithin{equation}{section}
\titleformat{name=\section}[block]{\bf\large\filcenter}{\thesection#1}{1em}{}
\titleformat{name=\section,numberless}[block]{\bf\large}{\middlerule{#1}{style0!80}}{-0.1em}{}[{\phantomsection\setcounter{equation}{0} \bookmark[dest=\HyperLocalCurrentHref, level=section]{\ttl@savetitle}}]
\renewcommand{\theequation}{\ifdefined\ttl@savetitle\ttl@savetitle.\fi\arabic{equation}}
\titleformat{name=\subsection,numberless}[block]{\normalsize\slshape}{\middlerule{#1}{bstyle4!80}}{-0.15em}{}
\titleformat{name=\subsubsection,numberless}[block]{\normalfont\normalsize\filcenter}{#1}{-0.15em}{}
\titlespacing{name=\section,numberless}{0pt}{0.5em}{0pt}
\titlespacing{name=\subsection,numberless}{0pt}{0pt}{0pt}
\titlespacing{name=\subsubsection,numberless}{0pt}{0pt}{0pt}

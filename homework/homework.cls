% Homework LaTeX class. Inherits from `article`.
% (c) 2020 Ethan Wu CC BY-SA 4.0
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homework}[2020-12-15 Basic Homework Class]

%%% conditionals %%%
\RequirePackage{xifthen}
\RequirePackage{iftex}

%%% LuaLaTeX utils %%%
\ifluatex
\RequirePackage{luacode}

% simple string replacement
\newcommand*{\@replace}[3]{\luadirect{%
    local replaced, _count = string.gsub(\luastring{#1}, \luastring{#2}, \luastring{#3});%chktex 36
    tex.sprint(replaced)%   % chktex 36
}}
\fi

%%% options %%%
% use microsoft word style
\newboolean{@useWordStyle}
% define logical math operators
\newboolean{@useLogicalOperators}
% use linguistics packages
\newboolean{@useLinguisticsPackages}
\DeclareOption{word}{\setboolean{@useWordStyle}{true}}
\DeclareOption{logic}{\setboolean{@useLogicalOperators}{true}}
\DeclareOption{linguistics}{\setboolean{@useLinguisticsPackages}{true}}
% \DeclareOption*{\PackageWarning{homework}{Unknown option `\CurrentOption`.}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
% inheritance from `article` document class %
\PassOptionsToClass{11pt}{article}
\ProcessOptions\relax
\LoadClass{article}

%%% input/font encoding %%%
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}

%%% page setup %%%
\RequirePackage[letterpaper,
                margin=1.25in]{geometry}

%%% typefaces %%%
\RequirePackage{fontspec}
\RequirePackage[babel, tracking=true]{microtype}
% improved hyphenation
\RequirePackage{hyphenat}

%%% math %%%
\RequirePackage{siunitx}    % units
\RequirePackage[leqno,      % left-aligned equation tags
           ]{amsmath}   % aligned math environments, etc.
\RequirePackage{amsfonts}    % math fonts
\RequirePackage{mathtools}

\sisetup{separate-uncertainty=true}

\DeclarePairedDelimiter\@abs{\lvert}{\rvert}
\DeclarePairedDelimiter\@ceil{\lceil}{\rceil}
\DeclarePairedDelimiter\@floor{\lfloor}{\rfloor}
\DeclarePairedDelimiter\@norm{\lVert}{\rVert}
\DeclareMathOperator\lcm{lcm}

% swap `\abs` and `\abs*`
\def\abs{\@ifstar{\@abs}{\@abs*}}
\def\ceil{\@ifstar{\@ceil}{\@ceil*}}
\def\floor{\@ifstar{\@floor}{\@floor*}}
\def\norm{\@ifstar{\@norm}{\@norm*}}

\newcommand*{\set}[1]{\ensuremath{\ifthenelse{\isempty{#1}}
                                             {\emptyset}
                                             {\{\,#1\,\}}}}
% single-layer implication arrow
\DeclareRobustCommand\implies{\to}
% double-sided biconditional arrow
\DeclareRobustCommand\iff{\leftrightarrow}

% text mode underscore
\AtBeginDocument{
  \catcode`_=12
  \begingroup\lccode`~=`_
  \lowercase{\endgroup\let~}\sb
  \mathcode`_="8000
}


\ifthenelse{\boolean{@useLogicalOperators}}{%
    % https://tex.stackexchange.com/a/299805 V
    \newcommand{\DeclareMathActive}[3]{%
        % #1 is the character, #2 is bool to check, #3 is the definition
        \expandafter\edef\csname keep@#1@code\endcsname{\mathchar\the\mathcode`#1 }
        \begingroup\lccode`~=`#1\relax
        \lowercase{\endgroup\def~}{\ifthenelse{\boolean{#2}}{#3}{\std{#1}}}%
        \AtBeginDocument{\mathcode`#1="8000 }%
    }

    \newcommand{\std}[1]{\csname keep@#1@code\endcsname{}}
    % \iftutex
    % \patchcmd{\newmcodes@}{\Umathcodenum `\-\relax}{\std@minuscode\relax}{}{\ddt}
    % \else
    % \patchcmd{\newmcodes@}{\mathcode`\-\relax}{\std@minuscode\relax}{}{\ddt}
    % \fi
    % \AtBeginDocument{\edef\std@minuscode{\the\mathcode`-}}
    % https://tex.stackexchange.com/a/299805 ^

    \newboolean{@logic}\setboolean{@logic}{false}
    % \def~\ifthenelse\boolean{@logic}\lnot\nobreakspace\relax%
    \DeclareMathActive!{@logic}\lnot%
    \DeclareMathActive.{@logic}\land%
    \DeclareMathActive|{@logic}\lor%
    \DeclareMathActive+{@logic}\lor%
    \DeclareMathActive>{@logic}\implies%
    \DeclareMathActive:{@logic}\iff%
    \DeclareMathActive*{@logic}\oplus%
    \DeclareMathActive={@logic}\equiv%
    \DeclareMathActive A{@logic}\forall%
    \DeclareMathActive E{@logic}\exists%

    \def\logic{\setboolean{@logic}{true}}%
    \def\endlogic{\setboolean{@logic}{false}}%

    \newcommand*\T{\text T}%
    \newcommand*\F{\text F}%
}

%%% margins, lists, and tables %%%
\RequirePackage{enumitem}
\RequirePackage{booktabs}
\newcommand*{\hfrule}{\midrule[0.5\lightrulewidth]}
\newcommand*{\chfrule}[1]{\midrule[0.5\lightrulewidth]{#1}}
\RequirePackage{multirow}   % multirow tabular environments
\let\mc\multicolumn\relax
\let\mr\multirow\relax
\RequirePackage{threeparttable}
% vertical table spacer
% insert between columns like so:
%   { ll@{\vts}ll }
\newcommand*{\vts}{\hskip\tabcolsep\quad}
% fit the following table into the width of the page
\newcommand{\fittab}[1]{\resizebox{\textwidth}{!}{#1}}

\RequirePackage{float}      % manipulate float environments
\RequirePackage{graphicx}   % include illustrations

% optional microsoft word style
\ifthenelse{\boolean{@useWordStyle}}%
           {\RequirePackage{wordlike}%
            \RequirePackage[doublespacing]{setspace}}%
           {}

% angle brackets
\newcommand{\ab}[1]{\textup{⟨}#1\textup{⟩}}

%%% linguistics packages %%%
\ifthenelse{\boolean{@useLinguisticsPackages}}%
           {\RequirePackage{gb4e}\noautomath{}%
            \RequirePackage{vowel}%
            \newcommand*{\rom}[1]{\emph{#1}}%
            \newcommand*{\eng}[1]{`#1'}%
            \newcommand*{\tlpair}[2]{\rom{#1}~\eng{#2}}%
            \newcommand*{\@transcription}[3]{\textup{\nohyphens{#1#2#3}}}%
            \newcommand*{\wipa}[1]{\@transcription{/}{#1}{/}}%
            \newcommand*{\nipa}[1]{\@transcription{[}{#1}{]}}%
            \newcommand*{\orth}[1]{\@transcription{⟨}{#1}{⟩}}%
            \newcommand*{\pron}[1]{\@transcription{\textbackslash}{#1}{\textbackslash}}%
            \renewcommand*{\lb}[1]{[%
                \ifthenelse{\NOT\isempty{#1}}%
                    {\raisebox{-.4ex}{\impt{\textup{#1}}}\,}%
                    {}%
            }%
            \renewcommand*{\rb}[1]{%
                \ifthenelse{\NOT\isempty{#1}}%
                    {\,\raisebox{-.4ex}{\impt{\textup{#1}}}}%
                    {}%
                ]}%
            % wrap in brackets
            % \br[r]{l}{text}
            %   [r=]    - annotation on right side
            %   l       - annotation on left side
            %   text    - text to wrap
            \newcommand*{\br}[3][]{[\lb{#2}#3\rb{#1}}%
           }{}%

%%% localization %%%
\RequirePackage[english]{babel}
\RequirePackage{csquotes}

%%% references %%%
\RequirePackage[hidelinks,      % don't format links differently
                pdfpagelabels,  % fix pdf page labels
                ]{hyperref}     % hyperlinked references

\ifthenelse{\boolean{@useLinguisticsPackages}}%
           {\RequirePackage[leipzighyper]{leipzig}}{}%

\RequirePackage[nameinlink,     % use name as part of hyperlink
                noabbrev,       % full reference names
                ]{cleveref}

\endinput

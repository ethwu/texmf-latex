\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{paper}[2023-02-06]

\RequirePackage{etoolbox}

% Microsoft Word style.
\newbool{zhi:word}
\DeclareOption{word}{%
    \booltrue{zhi:word}%
    \PassOptionsToClass{12pt}{article}%
}
% Load bibliography packages.
\newbool{zhi:bib}\DeclareOption{bib}{\booltrue{zhi:bib}}
% Load table packages.
\newbool{zhi:tab}\DeclareOption{tab}{\booltrue{zhi:tab}}
% Load reference packages.
\newbool{zhi:ref}\DeclareOption{ref}{\booltrue{zhi:ref}}
% Pass through undefined options.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions*\relax

% Superclass article.
\LoadClass{article}

% Font settings.
\RequirePackage{fontspec}
\RequirePackage{microtype}

\RequirePackage{geometry}

\ifbool{zhi:word}{%
    % Microsoft Word style.

    % Use Microsoft Word fonts.
    \setmainfont{Times New Roman}%
    \setsansfont{Helvetica}%
    \setmonofont{Courier New}%

    % Set the margins to 1 inch.
    \geometry{margin=1in}

    % Style title block.

    % Set the title styles.
    \RequirePackage{titling}%
    \pretitle{\LARGE\sffamily\bfseries\vspace*{-\baselineskip}}%
    \posttitle{\par}%
    \preauthor{\large\begin{tabular}[t]{@{}l@{}}}%
    \postauthor{\end{tabular}\par}%
    \predate{\large}%
    \postdate{\par}%
    % Remove the built-in maketitle vertical spacing.%
    \setlength{\droptitle}{-2em}%
    % Flush entire title block to the left.%
    \renewcommand{\maketitlehooka}{\flushleft}%
    \renewcommand{\maketitlehookd}{\endflushleft\vskip-1.5em}%

    % Include commands for setting line spacing.
    \RequirePackage{setspace}

    % Style headings.

    % Style section headers.
    \RequirePackage{titlesec}%
    \titleformat*{\section}{\LARGE\sffamily\bfseries}%
    \titlespacing*{\section}{\z@}{*1}{*0.5}%
    \titleformat*{\subsection}{\Large\sffamily\bfseries\itshape}%
    \titlespacing*{\subsection}{\z@}{*1}{*0.5}%
    \titleformat*{\subsubsection}{\Large\sffamily\bfseries\itshape}%
    \titlespacing*{\subsubsection}{\z@}{*1}{*0.5}%
    \titleformat*{\paragraph}{\normalsize\sffamily\itshape}%
    \titlespacing*{\paragraph}{\z@}{*1}{*0.5}%
    \titleformat*{\subparagraph}{\normalsize\sffamily\itshape}%
    \titlespacing*{\subparagraph}{\parindent}{*1}{*0.5}%
}{}

\ifbool{zhi:tab}{%
    % Provide table packages.

    % Table formatting.
    \RequirePackage{booktabs}%
}{}
\ifbool{zhi:bib}{%
    % Provide bibliography packages.

    % Chicago author-date citations.
    \RequirePackage[authordate]{biblatex-chicago}%
}{}

\ifbool{zhi:ref}{
    % Provide reference linking packages.

    % Hyperlink references.
    \RequirePackage{hyperref}
    \hypersetup{%
        % Small-caps links.
        frenchlinks=true%
    }
    \RequirePackage{cleveref}
}{}

\endinput
% UDG_oldbook.cls
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis}[2025/12/16 v0.1 UDG book-based stable class]

% ---------------- options ----------------
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=udg,prefix=udg@}

\DeclareStringOption[a4paper]{papersize}
\DeclareStringOption[12pt]{fontsize}
\DeclareStringOption[top]{pagenum}          % top | bottom
\DeclareStringOption[even]{chapterstart}    % even | odd | any
\DeclareBoolOption[true]{spanish}
\DeclareBoolOption[false]{english}
\DeclareBoolOption[false]{endnotes}

% pasar opciones desconocidas a book
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{book}}

% 1) procesa opciones estilo key=value (kvoptions)
\ProcessKeyvalOptions*\relax

% coherencia de idioma
\ifudg@english\udg@spanishfalse\fi

% 2) procesa opciones "normales" (incluye desconocidas -> book, y bibtex)
\ProcessOptions\relax

% ---------------- base class ----------------
\LoadClass[\udg@fontsize,\udg@papersize,twoside]{book}


% ---------------- fonts (times new roman) ----------------
\RequirePackage{iftex}
\ifPDFTeX
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage{newtxtext}
  \RequirePackage{newtxmath}
\else
  \RequirePackage{fontspec}
  \setmainfont{Times New Roman}
  %\RequirePackage{unicode-math}
  %\setmathfont{TeX Gyre Termes Math}
\fi

% ---------------- core packages ----------------
\RequirePackage{microtype}
\RequirePackage{geometry}
\RequirePackage{longtable,tabularx}
\RequirePackage{graphicx}

\geometry{left=3cm,right=3cm,top=2.7cm,bottom=2.5cm,headheight=15pt}
\setlength{\headheight}{15pt}

\RequirePackage{setspace}
\onehalfspacing

\RequirePackage{graphicx}
%\RequirePackage{amsmath}

%\makeatletter
%\@ifpackageloaded{amssymb}{}{%
%  \RequirePackage{amssymb}%
%}
%\makeatother

\RequirePackage{iftex}
\ifPDFTeX
  \RequirePackage{amssymb}
\fi

% language (no option clash)
%\RequirePackage{etoolbox}
\makeatletter
\@ifpackageloaded{babel}{}{% 
  \ifudg@spanish
    \RequirePackage[spanish,activeacute,es-tabla]{babel}
  \else
    \RequirePackage[english]{babel}
  \fi
}
\makeatother

% spanish captions
\addto\captionsspanish{\renewcommand{\contentsname}{Índice general}}
\addto\captionsspanish{\renewcommand{\listfigurename}{Índice de figuras}}
\addto\captionsspanish{\renewcommand{\listtablename}{Índice de tablas}}

\RequirePackage{caption}

% captions de tablas: ancho completo y centrados
\captionsetup[table]{width=\textwidth, justification=centering, singlelinecheck=false}

% (opcional) también para figuras
\captionsetup[figure]{width=\textwidth, justification=centering, singlelinecheck=false}


% hyperref last (stable)
\RequirePackage{hyperref}
\hypersetup{hidelinks}

% ===== bibliografia: biblatex por capitulo =====
\RequirePackage{etoolbox}
\RequirePackage{csquotes}
\providecommand{\thesisbibfile}[1]{}
\providecommand{\chapterbibliography}{}

% ===== bibliografia: biblatex por capitulo =====
\RequirePackage[
  backend=biber,
  style=ieee,
  sorting=none,
  refsection=chapter
]{biblatex}

% el usuario declara el .bib desde main.tex
\renewcommand{\thesisbibfile}[1]{\addbibresource{#1}}

% bibliografia al final de cada capitulo
\renewcommand{\chapterbibliography}{%
  \printbibliography[heading=subbibliography,title={Referencias}]%
}

% ---------------- headers: odd=chapter, even=subsection ----------------
\RequirePackage{fancyhdr}
\RequirePackage{etoolbox}
\pagestyle{fancy}
\fancyhf{}
\setlength{\headheight}{15pt}

% macro para el encabezado de seccion
\newcommand{\udgCurrentSection}{}

\makeatletter
\renewcommand{\chaptermark}[1]{%
  \markboth{\thechapter.\ #1}{}%
  \gdef\udgCurrentSection{}% reset al cambiar de capitulo
}

\renewcommand{\sectionmark}[1]{%
  \gdef\udgCurrentSection{\thesection.\ #1}%
  \markright{\thesection.\ #1}%
}

% no subsecciones en encabezado
\renewcommand{\subsectionmark}[1]{}
\makeatother

\newcommand{\udgHeaderStyle}[1]{\textsc{\MakeUppercase{#1}}}

% impares: seccion (si esta vacia, cae a capitulo). pares: capitulo
\fancyhead[LO]{\nouppercase{\udgHeaderStyle{\udgCurrentSection}}} % impares: seccion
\fancyhead[RE]{\nouppercase{\udgHeaderStyle{\leftmark}}}         % pares: capitulo

% numero de pagina (ajusta si lo quieres abajo)
\fancyhead[RO]{\thepage}
\fancyhead[LE]{\thepage}

\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}

\fancypagestyle{plain}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \fancyfoot[LE,RO]{\thepage}%
}

% equivalente a cleardoublepage pero con pagina vacia realmente vacia
\newcommand{\clearemptydoublepage}{%
  \clearpage
  {\pagestyle{empty}%
   \if@twoside
     \ifodd\value{page}\else
       \null\newpage
     \fi
   \fi
  }%
}

\makeatother

% ---------------- page number position (top/bottom) ----------------
\makeatletter
\newcommand{\udg@setpagenumpos}{%
  \ifdefstring{\udg@pagenum}{top}{%
    \fancyhead[LE,RO]{\thepage}\fancyfoot{}%
  }{%
    \fancyfoot[LE,RO]{\thepage}\fancyhead[LE,RO]{}%
  }%
}
\udg@setpagenumpos
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}
\makeatother

% ---------------- start chapters on even page ----------------

\makeatletter
\newcommand{\udg@cleartoevenpage}{%
  \clearpage
  \ifodd\value{page}\else
    \hbox{}\thispagestyle{empty}\newpage
  \fi
}
\newcommand{\udg@clearchapterpage}{%
  \if@mainmatter
    \ifdefstring{\udg@chapterstart}{even}{\udg@cleartoevenpage}{%
      \ifdefstring{\udg@chapterstart}{odd}{\cleardoublepage}{\clearpage}%
    }%
  \else
    \clearpage
  \fi
}
\pretocmd{\chapter}{\udg@clearchapterpage}{}{}
\makeatother

% ---------------- chapter style (1/3 page, versales) ----------------
\makeatletter
\def\@makechapterhead#1{%
  \vspace*{0.1\textheight}%
  {\centering\normalfont
    {\Large\textsc{capitulo \thechapter}\par}%
    \vspace{1.0em}%
    {\Huge\bfseries\textsc{#1}\par}%
  }%
  \vspace{2.0em}%
}
\def\@makeschapterhead#1{%
  \vspace*{0.1\textheight}%
  {\centering\normalfont
    {\Huge\bfseries\textsc{#1}\par}%
  }%
  \vspace{2.0em}%
}
\makeatother

% ===== titulos en versales para secciones y subsecciones =====
\RequirePackage{titlesec}

% seccion: numero normal + titulo en small caps
\titleformat{\section}
  {\normalfont\Large}
  {\bfseries\thesection}
  {1em}
  {\bfseries\textsc}

% subseccion: numero normal + titulo en small caps
\titleformat{\subsection}
  {\normalfont\large}
  {\bfseries\thesubsection}
  {1em}
  {\bfseries\textsc}

  \titleformat{\subsubsection}
  {\normalfont\normalsize}
  {\bfseries\thesubsubsection}
  {1em}
  {\bfseries\textsc}

% ---------------- dedication & acknowledgements ----------------
\newcommand{\dedicatoria}[1]{%
  \chapter*{Dedicatoria}
  \addcontentsline{toc}{chapter}{Dedicatoria}
  \begin{flushright}\itshape #1\end{flushright}
  \clearpage
  \thispagestyle{empty}\null\newpage
}

\newcommand{\agradecimientos}[1]{%
  \chapter*{Agradecimientos}
  \addcontentsline{toc}{chapter}{Agradecimientos}
  #1
  \clearpage
  \thispagestyle{empty}\null\newpage
}

% ---------------- portada ----------------
\makeatletter

\newcommand*{\university}[1]{\gdef\@udguniversity{#1}}
\newcommand*{\@udguniversity}{Universidad de Guadalajara}

\newcommand*{\campus}[2]{\gdef\@udgcampus{#1}\gdef\@udgdiv{#2}}
\newcommand*{\@udgcampus}{Centro Universitario de Ciencias Exactas e Ingenierias}
\newcommand*{\@udgdiv}{Division de Ingenierias}

\renewcommand*{\title}[1]{\gdef\@udgtitle{#1}}
\newcommand*{\@udgtitle}{Titulo de la tesis}

\newcommand*{\grade}[1]{\gdef\@udggrade{#1}}
\newcommand*{\@udggrade}{Maestro en Ciencias en Ingenieria Electrica}

\renewcommand*{\author}[1]{\gdef\@udgauthor{#1}}
\newcommand*{\@udgauthor}{Nombre}

\newcommand*{\directors}[1]{\gdef\@udgdira{#1}}
\newcommand*{\@udgdira}{Director}

% codirector opcional
\newcommand*{\codirector}[1]{\gdef\@udgcodir{#1}}
\newcommand*{\@udgcodir}{} % vacio por defecto

% lugar (ciudad, estado)
\newcommand*{\place}[1]{\gdef\@udgplace{#1}}
\newcommand*{\@udgplace}{Guadalajara, Jalisco}

% fecha:
\renewcommand*{\date}[1]{\gdef\@udgdate{#1}}
\newcommand*{\udg@monthname}{%
  \ifcase\month\or
    Enero\or Febrero\or Marzo\or Abril\or Mayo\or Junio\or
    Julio\or Agosto\or Septiembre\or Octubre\or Noviembre\or Diciembre%
  \fi
}
\newcommand*{\@udgdate}{\udg@monthname\space \number\year}

\newcommand*{\udglogo}[1]{\gdef\@udglogo{#1}}
\newcommand*{\@udglogo}{}

\renewcommand{\maketitle}{%
  \begingroup
    \thispagestyle{empty}%
    \newgeometry{left=2.25cm,right=2.25cm,bottom=2cm,top=2cm}%
    \begin{center}
      {\Huge\bfseries\MakeUppercase{\@udguniversity}\par}
      \vspace{0.4cm}
      {\Large\bfseries\textsc{\@udgcampus}\par}
      {\Large\bfseries\textsc{\@udgdiv}\par}
      \vspace{1cm}

      \ifx\@udglogo\@empty\else
        \includegraphics[width=5cm]{\@udglogo}\par\vspace{0.8cm}
      \fi

      {\Large\bfseries \@udgtitle\par}
      \vspace{0.8cm}
      {\large\textsc{Tesis que para obtener el grado de}\par}
      {\Large\bfseries \@udggrade\par}
      \vspace{0.8cm}
      {\large\textsc{Presenta}\par}
      {\Large\bfseries \@udgauthor\par}
      \vspace{0.8cm}

      {\large\textsc{Director de tesis}\par}
      {\Large\bfseries \@udgdira\par}

      \ifx\@udgcodir\@empty\else
        \vspace{0.5cm}
        {\large\textsc{Codirector de tesis}\par}
        {\Large\bfseries \@udgcodir\par}
      \fi

      \vfill
      % ciudad, estado, mes y año
      {\large \@udgplace, \@udgdate\par}
    \end{center}

    \restoregeometry
    \clearpage

    \thispagestyle{empty}\null\newpage
  \endgroup

  
}
\makeatother

\makeatletter

% - --------------- custom toc ----------------
\newif\ifthesis@toc@seenmainchap
\thesis@toc@seenmainchapfalse

% numero de capitulo adelantado para el toc
\newcommand{\thesis@tocchapnum}{\number\numexpr\value{chapter}+1\relax}

\newcommand{\thesis@tocromanarabicsep}{%
  \par\addvspace{0.4\baselineskip}%
  \noindent\rule{\textwidth}{0.6pt}\par%
  \addvspace{0.4\baselineskip}%
  \global\thesis@toc@seenmainchapfalse
}

\newcommand{\thesis@tocchapterdivider}{%
  \ifthesis@toc@seenmainchap
    \par\addvspace{0.4\baselineskip}%
    \noindent\rule{\textwidth}{0.6pt}\par%
    \addvspace{0.4\baselineskip}%
  \else
    \global\thesis@toc@seenmainchaptrue
  \fi
}

\pretocmd{\mainmatter}{%
  \addtocontents{toc}{\protect\thesis@tocromanarabicsep}%
}{}{}

\newcommand*\l@chapterlabel[2]{
  \addpenalty{-\@highpenalty}
  \vskip 0.2\baselineskip
  {\noindent\bfseries\textsc{#1}\par}
  \nobreak\vskip 0.2\baselineskip
}

\renewcommand*\l@chapter[2]{%
  \ifnum\c@tocdepth>-1\relax
    \addpenalty{-\@highpenalty}%
    \addvspace{0.2\baselineskip}%
    \begingroup
      \def\numberline##1{}% elimina la numeracion "1 "
      \@dottedtocline{0}{0em}{1.5em}{\bfseries\textsc{#1}}{#2}%
    \endgroup
  \fi
}


\pretocmd{\@chapter}{%
  \if@mainmatter
    \addtocontents{toc}{\protect\thesis@tocchapterdivider}%
    \addcontentsline{toc}{chapterlabel}{Capitulo \thesis@tocchapnum}%
  \fi
}{}{}

\renewcommand{\chapterbibliography}{%
  \clearemptydoublepage
  \section*{Referencias}%
  \addcontentsline{toc}{section}{Referencias}%
  \gdef\udgCurrentSection{Referencias}%
  \markright{Referencias}%
  \printbibliography[heading=none]%
}

\makeatother


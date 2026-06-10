%==============================================================================
%
%							UNIVERSIDAD DE GUADALAJARA
%
%					Centro Universitario de Ciencias Exáctas e Ingenierías
%
%						Maestría en Ciencias en Ingeniería Eléctrica
%
%==============================================================================
%
%		Autores:
%			Ing. Juan Antonio López Guevara
%			Ing. José Angel Rodriguez Chavez
%			Dr. Dunstano del Puerto Flores
%
%		Fecha:
%			Julio 2017
%
%==============================================================================
%
%	VERSIONES:
%		
%		UDG_thesis_Ver. 1.0	Julio 2017
%		UDG_thesis_Ver. 1.1	Agosto 2017
%				Se añade: Resumen del capítulo
%				Se corrige: Portada, numero de primera página del capítulo, formato una-cara/doble-cara, título de 		%					tablas. lof, lot, toc.
%		UDG_thesis_Ver. 1.2	Septiembre 2017
%				Se corrige: Nombre de tablas y figuras, toc, portada
%		UDG_thesis_Ver. 1.3	Noviembre 2017
%				Se corrige: tamaños de letra en numeros de pagina, tablas, espaciado e interlineado, portada.
%				Se añade: Inserción de oficios.
%		UDG_thesis_Ver. 1.4	Noviembre 2017
%				Se corrige: Se definen acentos para que trabaje en entorno de mac y win
%		UDG_thesis_Ver. 1.5	Noviembre 2017
%				Se añade: Espaciado entre elementos en listas con viñetas
%				Se corrige: Encabezados
%
%==============================================================================

\ProvidesClass{UDG}[2017/11/21 v1.5_mcie]
\NeedsTeXFormat{LaTeX2e}[1995/12/01]

\newif\ifnum@bib\num@bibtrue
\newif\ifnote@end\note@endfalse
	\DeclareOption{oneline}{\PassOptionsToPackage{doublespacing}{setspace}}
	\DeclareOption{halfline}{\PassOptionsToPackage{onehalfspacing}{setspace}}
	\DeclareOption{endnotes}{\ProvidesPackage{endnotes}\note@endtrue}
	\DeclareOption{numbib}{\num@bibtrue}
	\DeclareOption{nonumbib}{\num@bibfalse}
	\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions
\LoadClass{book}
		\RequirePackage{amsmath,amssymb,amsfonts,verbatim,graphicx,setspace,endnotes}%%
		\RequirePackage[left=3cm,right=3cm,top=2.5cm,bottom=2cm]{geometry}
		\RequirePackage{appendix,tocloft}
			\usepackage{xspace,amscd,rotating,latexsym,multicol,array,algorithm}
			\usepackage[hyphens,obeyspaces]{url}
			\usepackage{amsthm}
			\usepackage{fancyhdr}
			\usepackage[usenames]{xcolor}
			% \usepackage{hyperref}
			\usepackage{titlesec}
			\usepackage{booktabs}
			\usepackage{titletoc}
			\usepackage{bold-extra}
			\usepackage{changepage}
             %<--- agregado
%==============================================================================
%	Title Format
%==============================================================================
	%Chapter format
	\titleformat{\chapter}[display]
		{\Huge \filcenter}
		{\vspace{-3.5cm}\rule{\textwidth}{2pt}\\ \hfill \chaptertitlename \  \hfill}
		{-6pt}{ }
		[\vspace{-2.2cm}\rule{\textwidth}{1pt}]
	%Section format
	\titleformat{\section}[hang]
		{\vspace{-12pt}\Large}
		{\hspace{0.4cm} \filleft \thesection .}
		{1ex}{}
		[\vspace{-8pt}]
	% Subsection format
	\titleformat{\subsection}[hang]
		{\vspace{-15pt}\large}
		{\hspace{0.4cm}\filleft \thesubsection .}
		{1ex}{}
		[\vspace{-8pt}]
	%Subsubsection format
	\titleformat{\subsubsection}[hang]
		{\vspace{-12pt}\normalsize}
		{\hspace{0.4cm}\filleft \thesubsubsection .}
		{1ex}{}
		[\vspace{-8pt}]

%==============================================================================
%	Text format
%==============================================================================
	\setlength{\parindent}{0.5cm}		% indent lenght
	\setlength{\parskip}{8pt}			% paragraph skip
	\renewcommand{\baselinestretch}{1.2}% line spacing
	% Acute definitions
		\ifx{Á}\defÁ{\'A}\fi			\ifx{á}\defá{\'a}\fi
		\ifx{É}\defÉ{\'E}\fi			\ifx{é}\defé{\'e}\fi
		\ifx{Í}\defÍ{\'I}\fi			\ifx{í}\defí{\'i}\fi
		\ifx{Ó}\defÓ{\'O}\fi	     	\ifx{ó}\defó{\'o}\fi
		\ifx{Ú}\defÚ{\'U}\fi			\ifx{ú}\defú{\'u}\fi
		\ifx{Ñ}\defÑ{\~N}\fi		    \ifx{ñ}\defñ{\~n}\fi

%==============================================================================
%	Lists  Format
%==============================================================================
	\setlength\itemsep{-1ex}			% item enviroment spacing

%==============================================================================
%	Tables Caption Format
%==============================================================================
	\def\table{\let\@makecaption\@tablecaption\@float{table}}
	\newbox\tablecaptionbox
	\long\def\@tablecaption#1#2{
		\setbox\tablecaptionbox=\hbox to \textwidth{\hfil\fontsize{10}{11}\selectfont	\textrm{\thetable \\ }\hfil  #2}
		\ifdim\wd\tablecaptionbox<\hsize{\box\tablecaptionbox}
		\else \fontsize{10}{11}\selectfont \unhbox\tablecaptionbox\filcenter
		\fi\vspace{6pt}}
	\long\def\@makecaption#1#2{\vskip\abovecaptionskip\textbf{\textit{#1}.} \textit{#2}\par\vskip\belowcaptionskip}

%==============================================================================
%	Bibliography Format
%==============================================================================
	\renewenvironment{thebibliography}[1] {\section{\refname}
		\@mkboth{\leftmark }{\leftmark }
		\list{\ifnum@bib\@biblabel{\@arabic\c@enumiv}\fi}{
			\settowidth\labelwidth{\@biblabel{#1}}
			\ifnum@bib\leftmargin\labelwidth\advance\leftmargin\labelsep
				\else\leftmargin\bibindent\advance\itemindent-\bibindent
				\fi
			\@openbib@code\usecounter{enumiv}\let\p@enumiv\@empty
			\renewcommand\theenumiv{\@arabic\c@enumiv}}
		\sloppy\clubpenalty4000 \@clubpenalty \clubpenalty\widowpenalty4000 \sfcode`\.\@m}

%==============================================================================
%	Foot & Head Format
%==============================================================================
	\pagestyle{fancy}
\if@twoside
	%Headnote format
	\renewcommand{\headrulewidth}{0pt}
	\renewcommand{\chaptermark}[1]{\markboth{#1}{}
	\setlength{\headheight}{0pt}\fancyhead{}\fancyfoot{}
		\fancyhead[RO]{
			\vspace{-1em}\footnotesize
			\leftmark \hspace{1ex}
			\colorbox{ lightgray}{\color{white} \bfseries{\ \chaptertitlename \ \thechapter \ }}
			\settowidth\labelwidth{\colorbox{gray}{\bfseries{aaaa\chaptertitlename\thechapter}}}
			\hspace{-\labelwidth}}
		\fancyhead[LE]{
			\vspace{-1em}\footnotesize
			\settowidth\labelwidth{\colorbox{gray}{\bfseries{aaa\chaptertitlename\thechapter}}}
			\hspace{-\labelwidth}
			\colorbox{ lightgray}{\color{white}\bfseries{\ \chaptertitlename \ \thechapter\ }}
			\hspace{1ex}\leftmark}
	%Footnote format
	\renewcommand{\footrulewidth}{1pt}
		\fancyfoot[RO,LE]{\footnotesize \thepage}\pagestyle{fancy}}
		\fancypagestyle{plain}{\fancyhf{}\fancyfoot[RO,LE]{\footnotesize \thepage}}
\else
	%Headnote format
	\renewcommand{\headrulewidth}{0pt}
	\renewcommand{\chaptermark}[1]{\markboth{#1}{}
	\setlength{\headheight}{0pt}\fancyhead{}\fancyfoot{}
		\fancyhead[RO,RE]{
			\vspace{-1em}\footnotesize
			\leftmark \hspace{1ex}
			\colorbox{ lightgray}{\color{white} \bfseries{\ \chaptertitlename \ \thechapter \ }}
			\settowidth\labelwidth{\colorbox{gray}{\bfseries{aaaa\chaptertitlename\thechapter}}}
			\hspace{-\labelwidth}}
	%Footnote format
	\renewcommand{\footrulewidth}{1pt}
		\fancyfoot[RO,RE]{\footnotesize \thepage}\pagestyle{fancy}}
		\fancypagestyle{plain}{\fancyhf{}\fancyfoot[RO,RE]{\footnotesize\thepage}}
\fi

%==============================================================================
%	Cover Format
%==============================================================================
	% Declaration of default values
	\newcommand*{\university}[1]{\gdef\@udguniversity{#1}}
	\newcommand*{\@udguniversity}{Universidad de Guadalajara}
	\newcommand*{\campus}[2]{{\gdef\@udgcampus{#1}}{\gdef\@udgdiv{#2}}}
	\newcommand*{\@udgcampus}{Centro Universitario de Ciencias Exactas e Ingenier\'ias}
	\newcommand*{\@udgdiv}{Divisi\'on de Ingenier\'ias}
	\renewcommand*{\title}[1]{\gdef\@udgtitle{#1}}
	\newcommand*{\@udgtitle}{T\'itulo de la tesis}
	\newcommand*{\grade}[1]{\gdef\@udggrade{#1}}
	\newcommand*{\@udggrade}{Maestro en Ciencias en Ingenier\'ia El\'ectrica}
	\renewcommand*{\author}[1]{\gdef\@udgauthor{#1}}
	\newcommand*{\@udgauthor}{Ing. Nombre}
	\newcommand*{\directors}[3]{{\gdef\@udgdira{#1}}{\gdef\@udgdirb{#2}}{\gdef\@udgdirc{#3}}}
	\newcommand*{\@udgdira}{Dr. Nombre}
	\newcommand*{\@udgdirb}{Codirector de tesis}
	\newcommand*{\@udgdirc}{Dr. Nombre}
	\renewcommand*{\date}[1]{\gdef\@udgdate{#1}}
	\newcommand*{\@udgdate}{Guadalajara, Jalisco, Noviembre del 2017}
	% maketitle command
	\renewcommand{\maketitle}{
		\pagenumbering{alph}
		\newgeometry{left=1cm,right=1cm,bottom=2.5cm,top=2.5cm}
			\begin{center}
				\vspace{0.5cm}\Huge\textbf{\MakeUppercase{\@udguniversity}}\\
				\Large\bfseries\scshape\@udgcampus\\
				\Large \bfseries\scshape\@udgdiv\\[2ex]
				\begin{figure}[H]
					\centering
					\includegraphics[width=5cm]{University_emblem}
				\end{figure}
				\rm\vspace{-0.5cm} \Large \textbf{\@udgtitle}\\[0.6cm]
				\large \textsc{Tesis que para obtener el grado de}\\ \Large \textbf{\@udggrade}\\[0.6cm]
				\large \textsc{Presenta}\\ \Large \textbf{\@udgauthor}\\[0.6cm]
				\large \scshape{Director de tesis} \\ \rm\Large\bfseries \@udgdira \\[0.6cm] 
				\rm\large\scshape{\@udgdirb} \\ \rm\Large\bfseries \@udgdirc \\ \normalsize\rm
			\end{center}
		\fancyhf{} \fancyfoot[RE,RO]{\@udgdate\hspace{-2cm}} \newpage
		\begin{center}
			\textcolor{white}{This page intentional left blank.}
		\end{center}
%==============================================================================
%
%		For add the authorization and request letters to the thesis file, delete the \latex comment symbol (%) to follow part
%
%==============================================================================
%%	Thesis authorization letter (this is a comment)
%		\newgeometry{left=1cm,right=1cm,bottom=2.5cm,top=1cm}\fancyhf{}\thispagestyle{empty} \newpage
%			\begin{figure}[H]
%				\centering \includegraphics[width=1\textwidth]{thesis_letter}
%			\end{figure}
%		\fancyhf{}\thispagestyle{empty} \newpage
%			\begin{center}
%				\textcolor{white}{This page intentional left blank.}
%			\end{center}
%%	Thesis print request letter (this is a comment)
%		\newgeometry{left=1cm,right=1cm,bottom=2.5cm,top=1cm}\fancyhf{}\thispagestyle{empty} \newpage
%			\begin{figure}[H]
%				\centering \includegraphics[width=1\textwidth]{print_request}
%			\end{figure}
%		\fancyhf{}\thispagestyle{empty} \newpage
%			\begin{center}
%				\textcolor{white}{This page intentional left blank.}
%			\end{center}
%%	Thesis print authorization letter (this is a comment)
%		\newgeometry{left=1cm,right=1cm,bottom=2.5cm,top=1cm}\fancyhf{}\thispagestyle{empty} \newpage
%			\begin{figure}[H]
%				\centering \includegraphics[width=1\textwidth]{print_authorization}
%			\end{figure}
%		\fancyhf{}\thispagestyle{empty} \newpage
%			\begin{center}
%				\textcolor{white}{This page intentional left blank.}
%			\end{center}
%%	End  authorization and request letters (this is a comment)

		\fancyhf{}\thispagestyle{empty} \newpage \restoregeometry \pagenumbering{roman}
	}

%==============================================================================
%	LoF, LoT & ToC Format
%==============================================================================
	%LoF
	\setlength{\cftfignumwidth}{2.5cm}
	\renewcommand{\thefigure}{Fig.\  \thechapter.\arabic{figure}}\setlength{\cftfignumwidth}{2.5cm}
	%LoT
	\setlength{\cfttabnumwidth}{2.5cm}
	\renewcommand{\thetable}{Tabla\  \thechapter.\arabic{table}}\setlength{\cfttabnumwidth}{2.5cm}
	%ToC
	\global\newcounter{startap}\renewcommand\thestartap{\arabic{startap}}
	\setcounter{tocdepth}{3}	\setcounter{secnumdepth}{3}

	\titlecontents*{chapter} [0pt] 
		{\vspace{1ex} \rm\rule[0pt]{\textwidth}{1pt}}
		{\vspace{-2em}\hspace{0.2cm}\bfseries \stepcounter{startap}
	% Note: To  change the chapter number and apendix chapter, set the apendixcounter compare.
		\ifnum\value{startap}>5
			\renewcommand{\chaptertitlename}{Ap\'endice}
		\fi
		\chaptertitlename\ \thecontentslabel\quad}{}
		{\bfseries{\hfill\vspace{1ex}\contentspage}}
	\renewcommand{\cftsecafterpnum}{\hspace{0.5cm}\hfil}
	\renewcommand{\cftsubsecafterpnum}{\hspace{0.5cm}\hfil}
	\renewcommand{\cftsubsubsecafterpnum}{\hspace{0.5cm}\hfil}
	\cftsetindents{section}{0.7cm}{1.0cm}
	\cftsetindents{subsection}{1.7cm}{1.3cm}
	\cftsetindents{subsubsection}{3.0cm}{1.5cm}

%==============================================================================%	New Environments
%==============================================================================
	%Cover page format
	\newenvironment{cover}[1]
		{\par\thispagestyle{fancy}}
		{\clearpage \fancyhf{} \par}
	%Dedication section format
	\newenvironment{dedication}
		{\noindent  \vspace{1ex} \rule{\textwidth}{2pt}
		\makebox[\textwidth]{\LARGE \filcenter Dedicatoria}\\[-1ex]
		\noindent \normalsize\rule{\textwidth}{1pt}}
		{\fancyfoot[CO,CE]{\thepage}\thispagestyle{fancy} \newpage\par}
	%Acknowledge section format
	\newenvironment{acknowledge}
		{\noindent  \vspace{1ex} \rule{\textwidth}{2pt} 
		\makebox[\textwidth]{\LARGE \filcenter Agradecimientos}\\ [-1ex]
		\noindent \normalsize \rule{\textwidth}{1pt}}
		{\newpage}
	%Spanish abstract section format
	\newenvironment{resumen}
		{\noindent  \vspace{1ex} \rule{\textwidth}{2pt}
		\makebox[\textwidth]{\LARGE \filcenter Resumen}\\[-1ex]
		\noindent \normalsize \rule{\textwidth}{1pt}}
		{\addcontentsline{toc}{section}{Resumen} \newpage}
	%English abstract section format
	\newenvironment{abstract}
		{\noindent  \vspace{1ex} \rule{\textwidth}{2pt}
		\makebox[\textwidth]{\LARGE \filcenter Abstract}\\[-1ex]
		\noindent\normalsize \rule{\textwidth}{1pt}}
		{\addcontentsline{toc}{section}{Abstract} \newpage}
	%List of figures section format
	\newenvironment{figurelist}
		{\noindent \vspace{-1.5cm} \rule{\textwidth}{2pt}
		\renewcommand{\listfigurename}{\vspace{-1.2cm}\hfil\rm\LARGE Lista de Figuras\\[-1ex]
		\noindent \vspace{-2em} \rule{\textwidth}{1pt}}\normalsize\vspace{3ex}}
		{\addcontentsline{toc}{section}{Lista de Figuras}\thispagestyle{fancy}\newpage}
	%List of tables section format
	\newenvironment{tablelist}
		{\noindent \vspace{-1.5cm} \rule{\textwidth}{2pt}
		\renewcommand{\listtablename}{\vspace{-1.2cm}\hfil\rm\LARGE Lista de Tablas\\[-1ex]
		\noindent \vspace{-2em} \rule{\textwidth}{1pt}}\normalsize\vspace{3ex}}
		{\addcontentsline{toc}{section}{Lista de Tablas}\thispagestyle{fancy}\newpage}
	%Acronyms list section format
	\newenvironment{acronymlist}
		{\noindent \vspace{1ex} \rule{\textwidth}{2pt}
		\makebox[\textwidth]{\LARGE \filcenter Lista de acr\'onimos}\\[-1ex]
		\noindent \normalsize \rule{\textwidth}{1pt}}
		{\addcontentsline{toc}{section}{Lista de Acr\'onimos}\newpage}
	%Table of contents section format
	\newenvironment{contentlist}
		{\noindent \vspace{-0.9cm} \rule{\textwidth}{2pt}
		\renewcommand{\contentsname}{\vspace{-1.8cm}\hfil\rm\LARGE Tabla de Contenido\\[-1ex]
		 \thispagestyle{fancy}\noindent \vspace{-1em} \rule{\textwidth}{1pt}}\normalsize\vspace{3ex}}
		{\thispagestyle{fancy}\newpage
		\checkoddpage
		\ifoddpage
			\pagenumbering{arabic}
		\else
	 		\begin{center}
				\textcolor{white}{This page intentional left blank.}
			\end{center}
			\newpage\pagenumbering{arabic}
		\fi}
	%Chapter abstract section format
	\newenvironment{resumencap}
		{ \vspace{-26pt} \par \noindent \itshape Resumen: }
		{\par \rm \vspace{2pt}}

%\newcommand{\marginalnote}[1]{\mbox{}\marginpar{\raggedright\hspace{0pt}#1}} \marginalnote{texto al margen}
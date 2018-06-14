install_all <- function(reinstall = FALSE) {
  oldwd <- setwd(tempdir())
  on.exit(setwd(oldwd))
  
  cran <- "http://cran.r-project.org/"
  
  # Gtk and RGtk2 ------------------------------------------------------------
  if (!is_installed("gtk") || reinstall) {
    message("Installing Gtk")
    url <- "http://downloads.sourceforge.net/gtk-win/gtk2-runtime-2.22.0-2010-10-21-ash.exe?download"
    download.file(url, basename(url), mode = "wb")
    shell.exec(basename(url))
  }
  
  if (!is_installed("rgtk2") || reinstall) {
   message("Installing RGtk2")     
   install.packages("RGtk2", repos = cran)
  }

  # Missing dlls -------------------------------------------------------------
  gtk_path <- dirname(Sys.which("libcairo-2.dll"))
  if (!is_installed("libxml2")) {
    message("Installing libxml2")
    url <- "http://yihui.name/fun/libxml2.dll"
    download.file(url, file.path(gtk_path, "libxml2.dll"), mode = "wb")
  }
  if (!is_installed("iconv")) {
    message("Installing iconv")
    url <- "http://yihui.name/fun/iconv.dll"
    download.file(url, file.path(gtk_path, "iconv.dll"), mode = "wb")
  }
  
  # GGobi and rggobi ---------------------------------------------------------
  if (!is_installed("ggobi") || reinstall) {
    message("Installing GGobi")
    ggobi.url <- "http://www.ggobi.org/downloads/ggobi-2.1.8.exe"
    download.file(ggobi.url, basename(ggobi.url), mode = "wb")
    shell.exec(ggobi.exe)
  }
  
  if (!is_installed("rggobi") || reinstall) {
    message("Installing rggobi")
    install.packages("rggobi", repos = cran)
  }

  message("Installation completed. Run the following code to test")
  message("library(rggobi); ggobi(mtcars)")
}

is_installed <- function(pkg) {
  in_path <- function(x) length(Sys.which(x)) > 0
  pkg_installed <- function(x) system.file(package = x) != ""
     
  switch(pkg,
    ggobi = in_path("ggobi"),
    rggobi = pkg_installed("rggobi"),
    gtk = in_path("libcairo-2.dll"),
    rgtk2 = pkg_installed("RGtk2"),
    libxml2 = in_path("libxml2.dll"),
    iconv = in_path("iconv.dll")
  )
}
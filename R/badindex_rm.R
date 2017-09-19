#' Remove bad values from the index
#'
#' @description This function will remove predefined text from a specified vector.
#' @inheritParams badindex_add
#' @author Frederik Sachser
#' @seealso \code{\link{badvalue_rm}}, \code{\link{badindex_add}}
#' @export

badindex_rm <-
  function(data, badindex, badstring, separator = ", ") {
    badval_column <- data[, badindex]
    # convert to character
    badval_column <- as.character(badval_column)
    # store for output
    separator_inout <- separator
    # remove spaces
    separator <- gsub(pattern = " ", replacement = "", separator)
    if (badstring %in% unlist(strsplit(gsub(
      pattern = " ", replacement = "", badval_column
    ), split = separator)) == FALSE) {
      return(message("Pattern not found. Check spelling of input."))
    }
    # positive cases
    vector_string <-
      badval_column[grep(pattern = badstring, x = badval_column)]
    if (length(vector_string) == 0) {
      return(warning("Pattern not found. Check spelling of input"))
    }
    # remove spaces
    vector_string <- gsub(pattern = " ",
                          replacement = "",
                          x = vector_string)
    # remove the badstring
    vector_no_string <-
      trimws(gsub(paste0(
        '\\b(', paste(badstring, collapse = '|'), ')\\b'
      ), '', vector_string))
    # remove potentially doubled separator
    beauty_output <-
      gsub(
        pattern = paste0(separator, separator),
        replacement = separator,
        x = vector_no_string
      )
    # remove last char separator
    last_char <-
      beauty_output[endsWith(x = beauty_output, suffix = separator)]
    beauty_output[endsWith(x = beauty_output, suffix = separator)] <-
      substr(last_char, 1, nchar(last_char) - 1)
    # remove first char separator
    firstchar <-
      beauty_output[startsWith(x = beauty_output, separator)]
    beauty_output[startsWith(x = beauty_output, separator)] <-
      substr(x = firstchar,
             start = 2,
             stop = nchar(firstchar))
    # Add separator as specified
    beauty_output <-
      gsub(pattern = separator, replacement = separator_inout, beauty_output)
    # edit the badval_column
    badval_column[grep(pattern = badstring, x = badval_column)] <-
      beauty_output
    if (isTRUE(any(badval_column == ""))) {
      badval_column[which(badval_column == "")] <- NA
    }
    message("\nThe following bad values are left:",
            paste(unique(unlist(
              strsplit(gsub(
                pattern = " ", replacement = "", badval_column
              ), split = separator)
            )), collapse = ", "),
            "\n")

    badstring_exist(data, badindex, separator)

    # return badval_column
    return(badval_column)
  }
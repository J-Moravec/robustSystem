#' Catch stderr and stdout from external application
#'
#' Function \code{robust_system} provide easy way how to catch stdout, stderr and
#' exit status from external application. It builds on \code{base::system2}
#'  and utilize it internally. It catch \code{stdout} and \code{stderr} of
#' command ran by \code{system2} by redirecting them into temporary file and
#' reading them with \code{readLines}.
#'
#' Function \code{robust_system} works by redirecting \code{stdout} and
#' \code{stderr} to temporary files, either in R's temporary directory, which
#' is deleted after R's session ends, or in user specified directory.
#'
#' Parameters \code{command} and \code{args} are directly passed to
#' \code{system2}, as well as any other optional parameters passed as \code{...}.
#'
#' If \code{keep_temp=FALSE}, temporary files are deleted, but directory is
#' deleted only if it was created by this function. This makes function clean
#' after itself, but might be problematic if used in parallel.
#'
#' With \code{stdout_read} and \code{stderr_read}, you can pass additional
#' parameters to \code{readLines} function, should as \code{warn=TRUE}, as
#' \code{readLines} throw warning whenever line doesn't end with a newline.
#'
#'
#' @param command external program to run, same as \code{command} in
#'  \code{system2}.
#' @param args arguments for external program, same as \code{args} in
#'  \code{system2}.
#' @param dir directory that will be used, if not specified, R's temporary
#'  directory is used.
#' @param keep_temp if temporary files with \code{stdout} and \code{stderr}
#'  should be kept, if \code{dir} is specified, and was created by this
#'  function, it is deleted as well.
#' @param stdout_read parameters to be passed to \code{readLines} function of
#'  \code{stdout}.
#' @param stderr_read parameters to be passed to \code{readLines} function of
#'  \code{stderr}
#' @param ... other parameters passed to \code{system2}.
#' 
#' @return list with \code{stdout}, \code{sderr}, exit code and if
#' \code{keep_temp=TRUE} path to temporary files.
#'
#' @export
robust_system = function(command, args=character(), dir=NULL,
                         keep_temp=FALSE, stdout_read=list(),
                         stderr_read=list(), ...){
    dir_delete = FALSE
    if(is.null(dir)){
        tmpdir = tempdir()
        } else {
        tmpdir = dir
        if(!dir.exists(dir)){
            dir.create(dir, recursive=TRUE)
            dir_delete = TRUE
            }
        }
    stderr_file = tempfile("robust_system.stderr.", tmpdir=tmpdir)
    stdout_file = tempfile("robust_system.stdout.", tmpdir=tmpdir)
    output = list()
    output$exit_status = system2(
        command, args, stdout=stdout_file, stderr=stderr_file, ...
        )
    output$stderr = do.call(readLines, args=c(stderr_file, stderr_read))
    output$stdout = do.call(readLines, args=c(stdout_file, stdout_read))
    if(!keep_temp){
        unlink(c(stdout_file, stderr_file))
        if(dir_delete){
            unlink(tmpdir, recursive=TRUE)
            }
        } else {
        output$stderr_file = stderr_file
        output$stdout_file = stdout_file
        }
    return(output)
    }

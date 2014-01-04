function s:FindFile(file)
    let curdir = getcwd()
    let found = curdir
    while !filereadable(a:file) && found != "/"
        cd ..
        let found = getcwd()
    endwhile
    execute "cd " . curdir
    return found
endfunction

if has('cscope')
    let $CSCOPE_DIR=s:FindFile("cscope.out")
    let $CSCOPE_DB=$CSCOPE_DIR."/cscope.out"
    if filereadable($CSCOPE_DB)
        cscope add $CSCOPE_DB $CSCOPE_DIR
    endif

    command -nargs=0 Cscope !cscope -ub -R &
endif

if exists("g:loaded_neosess")
	finish
endif

let g:loaded_neosess = 1

command! -nargs=1 SaveSession lua require("neosess").save_session(<f-args>)
command! -nargs=1 LoadSession lua require("neosess").load_session(<f-args>)
command! -nargs=0 DisplaySession lua require("neosess").display_session_files()


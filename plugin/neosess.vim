if exists("g:loaded_neosess")
	finish
endif

let g:loaded_neosess = 1

command! -nargs=1 SaveSession lua require("neosess").save_session(<f-args>)
command! -nargs=1 LoadSession lua require("neosess").load_session(<f-args>)
command! -nargs=0 FetchSession lua require("neosess").fetch_session_file()


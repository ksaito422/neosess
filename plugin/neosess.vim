if exists('g:loaded_example_plugin')
	finish
endif

let g:loaded_example_plugin = 1

command! -nargs=1 CreateSession lua require("neosess").create_session(<f-args>)
command! -nargs=1 LoadSession lua require("neosess").load_session(<f-args>)

